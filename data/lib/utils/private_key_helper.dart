// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:data/log/logger.dart';
import 'package:data/utils/ephemeral_distribution_helper.dart';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import '../api/space/api_group_key_model.dart';
import 'buffered_sender_keystore.dart';

class EncryptionException implements Exception {
  final String message;
  final dynamic cause;

  EncryptionException(this.message, [this.cause]);
}

const int KEY_SIZE = 128; // bits
const int ITERATION_COUNT = 100000;
const int GCM_IV_SIZE = 12; // bytes
const int GCM_TAG_SIZE = 128; // bits

/// Derives a SecretKey from the user's passkey/PIN using PBKDF2.
Future<SecretKey> _deriveKeyFromPasskey(String passkey, Uint8List salt) async {
  try {
    final pbkdf2 = Pbkdf2.hmacSha256(
      iterations: ITERATION_COUNT,
      bits: KEY_SIZE, // 128 bits = 16 bytes output
    );

    final newSecretKey = await pbkdf2.deriveKeyFromPassword(
      password: passkey,
      nonce: salt,
    );
    return newSecretKey;
  } catch (e) {
    throw EncryptionException('Key derivation failed', e);
  }
}

// Encrypt data using AES-GCM with the provided key. Returns the IV prepended to the ciphertext.
Future<Uint8List> _encryptData(Uint8List data, SecretKey key) async {
  final gcm = AesGcm.with128bits();
  final iv = gcm.newNonce();

  final secretBox = await gcm.encrypt(data, secretKey: key, nonce: iv);
  return secretBox.concatenation();
}

/// Encrypts the private key using the user's passkey/PIN.
/// Retrieves or generates the salt and stores it.
Future<Uint8List> encryptPrivateKey(
    Uint8List privateKey, String passkey, Uint8List salt) async {
  if (salt.isEmpty) {
    throw Exception('Salt is empty');
  }

  final key = await _deriveKeyFromPasskey(passkey, salt);
  return await _encryptData(privateKey, key);
}

// Decrypts the provided ciphertext using the provided private key.
Future<Uint8List> _decryptData(
    Uint8List encryptedPrivateKey, Uint8List salt, String passkey) async {
  final key = await _deriveKeyFromPasskey(passkey, salt);

  if (encryptedPrivateKey.length < GCM_IV_SIZE) {
    throw Exception("Encrypted data is too short");
  }

  print(
      "XXX  encryptedPrivateKey ${encryptedPrivateKey.length} key ${encryptedPrivateKey}");

  final iv = encryptedPrivateKey.sublist(0, GCM_IV_SIZE);

  final ciphertext =
      encryptedPrivateKey.sublist(GCM_IV_SIZE, encryptedPrivateKey.length - 16);
  final mac = encryptedPrivateKey.sublist(encryptedPrivateKey.length - 16);

  print(
      "XXX _decryptData iv ${iv.length} ciphertext ${ciphertext.length} mac ${mac.length}");

  final algorithm = AesGcm.with128bits();

  final secretBox = SecretBox(
    ciphertext,
    nonce: iv,
    mac: Mac(mac),
  );

  final decrypted = await algorithm.decrypt(
    secretBox,
    secretKey: key,
  );

  return Uint8List.fromList(decrypted);
}

Future<GroupCipher?> getGroupCipher({
  required String spaceId,
  required int deviceId,
  required Uint8List privateKeyBytes,
  required Uint8List salt,
  required String passkey,
  required EncryptedDistribution distribution,
  required BufferedSenderKeystore bufferedSenderKeyStore,
}) async {
  final privateKey = await _decodePrivateKey(
    privateKeyBytes: privateKeyBytes,
    salt: salt,
    passkey: passkey,
  );

  print(
      "XXX privateKeyBytes ${privateKeyBytes.length} _decodePrivateKey ${privateKey?.serialize().length}");

  if (privateKey == null) {
    return null;
  }

  final decryptedDistribution =
      await EphemeralECDHUtils.decrypt(distribution, privateKey);

  if (decryptedDistribution == null) {
    return null;
  }

  final distributionMessage =
      SenderKeyDistributionMessageWrapper.fromSerialized(decryptedDistribution);

  final groupAddress = SignalProtocolAddress(spaceId, deviceId);

  final senderKey = SenderKeyName(
   // groupAddress.getDeviceId().toString(),
    distributionMessage.id.toString(),
    groupAddress,
  );


  bufferedSenderKeyStore.loadSenderKey(senderKey);

  // TODO rotate sender key

  try {
    GroupSessionBuilder(bufferedSenderKeyStore).process(senderKey, distributionMessage);
    final groupCipher = GroupCipher(bufferedSenderKeyStore, senderKey);
    return groupCipher;
  } catch (e, s) {
    logger.e("Error processing group session", error: e, stackTrace: s);
    return null;
  }
}

Future<ECPrivateKey?> _decodePrivateKey(
    {required Uint8List privateKeyBytes,
    required Uint8List salt,
    required String passkey}) async {
  // try {
  //   return Curve.decodePrivatePoint(privateKeyBytes);
  // } catch (e, s) {
  // logger.d("Error decoding private key", error: e, stackTrace: s);
  final decodedPrivateKey = await _decryptData(privateKeyBytes, salt, passkey);
  return Curve.decodePrivatePoint(decodedPrivateKey);
  //}
}
