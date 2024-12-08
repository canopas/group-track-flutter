import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart' show sha256;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class EncryptionHandler {
  Future<Map<String, dynamic>> install() async {
    final identityKeyPair = generateIdentityKeyPair();

    final prefKeys = generatePreKeys(0, 110);

    final signedPrefKey = generateSignedPreKey(identityKeyPair, 0);

    final preKeyStore = InMemoryPreKeyStore();
    final signedPreKeyStore = InMemorySignedPreKeyStore();

    for (final p in prefKeys) {
      await preKeyStore.storePreKey(p.id, p);
    }
    await signedPreKeyStore.storeSignedPreKey(signedPrefKey.id, signedPrefKey);

    final encryptedPrivateKey = await _encryptPrivateKey(identityKeyPair.getPrivateKey().serialize(), 'asdfghjkl123');
    // user passkey we have to take it from user, currently i have used dummy

    final preKeyBundle = {
      "identity_key": base64.encode(identityKeyPair.getPublicKey().serialize()),
      "signed_pre_keys": prefKeys.map((p) => base64Encode(p.getKeyPair().publicKey.serialize())).toList(),
      "one_time_pre_key": prefKeys.map((p) => base64Encode(p.getKeyPair().privateKey.serialize())).toList(),
    };

    return {
      "public_key": base64Encode(identityKeyPair.getPublicKey().serialize()),
      "private_key_encrypted": encryptedPrivateKey,
      "pre_key_bundle": preKeyBundle,
    };
  }

  Future<String> _encryptPrivateKey(Uint8List privateKey, String passphrase) async {
    final key = Uint8List.fromList(sha256.convert(utf8.encode(passphrase)).bytes);

    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key(key), mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encryptBytes(privateKey, iv: iv);

    return base64Encode(iv.bytes + encrypted.bytes);
  }
}
