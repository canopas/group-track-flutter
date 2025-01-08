// ignore_for_file: constant_identifier_names

import 'package:cryptography/cryptography.dart';
import 'dart:typed_data';

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
