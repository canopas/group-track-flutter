// ignore_for_file: constant_identifier_names

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

const int KEY_SIZE = 256; // bits
const int ITERATION_COUNT = 100000;
const int GCM_IV_SIZE = 12; // bytes
const int GCM_TAG_SIZE = 128; // bits

/// Derives a SecretKey from the user's passkey/PIN using PBKDF2.
Future<SecretKey> _deriveKeyFromPasskey(String passkey, Uint8List salt) async {
  try {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: ITERATION_COUNT,
      bits: KEY_SIZE, // 256 bits = 32 bytes output
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
  try {
    final gcm = AesGcm.with256bits();
    final iv = Uint8List(GCM_IV_SIZE)
      ..setAll(0, List.generate(GCM_IV_SIZE, (i) => (i + 1) % 256));
    final secretBox = await gcm.encrypt(data, secretKey: key, nonce: iv);
    return Uint8List.fromList(iv + secretBox.cipherText);
  } catch (e) {
    throw EncryptionException("Encryption failed", e);
  }
}

/// Encrypts the private key using the user's passkey/PIN.
/// Retrieves or generates the salt and stores it.
Future<Uint8List> encryptPrivateKey(
    Uint8List privateKey, String passkey, Uint8List salt) async {
  if (salt.isEmpty) {
    throw EncryptionException('Salt is empty');
  }
  final key = await _deriveKeyFromPasskey(passkey, salt);
  return await _encryptData(privateKey, key);
}

// Decrypts the provided ciphertext using the provided private key.
Future<Uint8List> _decryptData(
    Uint8List encryptedPrivateKey, Uint8List salt, String passkey) async {
  try {
    final key = await _deriveKeyFromPasskey(passkey, salt);
    if (encryptedPrivateKey.length < GCM_IV_SIZE) {
      throw EncryptionException("Encrypted data is too short");
    }

    final iv = Uint8List(GCM_IV_SIZE)
      ..setAll(0, List.generate(GCM_IV_SIZE, (i) => (i + 1) % 256));

    final ciphertext = encryptedPrivateKey.sublist(GCM_IV_SIZE);

    final algorithm = AesCtr.with128bits(macAlgorithm: MacAlgorithm.empty);

    final secretBox = SecretBox(
      ciphertext,
      nonce: iv,
      mac: Mac.empty,
    );

    final clearText = await algorithm.decrypt(
      secretBox,
      secretKey: key,
    );

    return Uint8List.fromList(clearText);
  } catch (e) {
    throw EncryptionException("Decryption failed", e);
  }
}

Future<GroupCipher?>
    getGroupCipher({
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

  if (privateKey == null) {
    return null;
  }

  final decryptedDistribution =
      await EphemeralECDHUtils.decrypt(distribution, privateKey);

  if (decryptedDistribution == null) {
    return null;
  }

  final distributionMessage =
      SenderKeyDistributionMessageWrapper.fromSerialized(
    decryptedDistribution,
  );

  final groupAddress = SignalProtocolAddress(spaceId, deviceId);

  final senderKey = SenderKeyName(
    distributionMessage.id.toString(),
    groupAddress,
  );

  bufferedSenderKeyStore.loadSenderKey(senderKey);

  // TODO rotate sender key

  try {
    GroupSessionBuilder(bufferedSenderKeyStore)
        .process(senderKey, distributionMessage);
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
  try {
    return Curve.decodePrivatePoint(privateKeyBytes);
  } catch (e, s) {
    logger.d("Error decoding private key", error: e, stackTrace: s);
    final decodedPrivateKey =
        await _decryptData(privateKeyBytes, salt, passkey);
    return Curve.decodePrivatePoint(decodedPrivateKey);
  }
}
