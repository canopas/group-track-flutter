import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/services.dart';

import '../../log/logger.dart';

const int ivSize = 12;

String? encrypt(Map<String, dynamic> data, String key) {
  try {
    final jsonString = json.encode(data);
    final iv = enc.IV.fromSecureRandom(ivSize);

    final myKey = utf8.encode(key);
    final keyBytes = Uint8List.fromList(
      List.filled(32, 0)..setRange(0, min(32, myKey.length), myKey),
    );

    final cipher = enc.Encrypter(enc.AES(enc.Key(keyBytes), mode: enc.AESMode.gcm));
    final encrypted = cipher.encrypt(jsonString, iv: iv);
    final encryptedData = iv.bytes + encrypted.bytes;

    return base64Encode(encryptedData);
  } catch (e) {
    logger.e('AES256Encryption - Error while encrypt', error: e);
    return null;
  }
}

Map<String, dynamic>? decrypt(String encryptedText, String key) {
  try {
    final encryptedData = base64Decode(encryptedText.replaceAll(RegExp(r'\s'), ''));
    final iv = enc.IV(encryptedData.sublist(0, ivSize));
    final encrypted = enc.Encrypted(encryptedData.sublist(ivSize));
    final myKey = utf8.encode(key);
    final keyBytes = Uint8List.fromList(
      List.filled(32, 0)..setRange(0, min(32, myKey.length), myKey),
    );

    final cipher = enc.Encrypter(enc.AES(enc.Key(keyBytes), mode: enc.AESMode.gcm));
    final decryptedString = cipher.decrypt(encrypted, iv: iv); // Decrypt to String

    return json.decode(decryptedString) as Map<String, dynamic>; // Parse the JSON string back to Map
  } catch (e) {
    logger.e('AES256Encryption - Error while decrypt', error: e);
    return null;
  }
}