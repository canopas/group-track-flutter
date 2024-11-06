import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart' as encrypt;

String generateRandomKey() {
  final random = Random.secure();
  final keyBytes = List<int>.generate(32, (i) => random.nextInt(256));
  return base64Encode(keyBytes);
}

final _encryptionKey = encrypt.Key.fromBase64(generateRandomKey());
final _iv = encrypt.IV.fromLength(16);

/// Encrypts a JSON object by converting it to a string and encrypting.
String encryptModel(Map<String, dynamic> jsonData) {
  final encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey));
  final jsonString = jsonEncode(jsonData);
  final encrypted = encrypter.encrypt(jsonString, iv: _iv);
  return encrypted.base64;
}

/// Decrypts an encrypted string and converts it back to a JSON object.
Map<String, dynamic> decryptModel(String encryptedData) {
  final encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey));
  final decrypted = encrypter.decrypt64(encryptedData, iv: _iv);
  return jsonDecode(decrypted);
}
