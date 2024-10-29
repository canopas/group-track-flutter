import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

// Encryption key and IV
final _encryptionKey = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows!');
final _iv = encrypt.IV.fromLength(16);

/// Encrypts a JSON object by converting it to a string and encrypting.
String encryptModel(Map<String, dynamic> jsonData) {
  final encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey));
  final jsonString = jsonEncode(jsonData);  // Convert JSON to string
  final encrypted = encrypter.encrypt(jsonString, iv: _iv);
  return encrypted.base64;
}

/// Decrypts an encrypted string and converts it back to a JSON object.
Map<String, dynamic> decryptModel(String encryptedData) {
  final encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey));
  final decrypted = encrypter.decrypt64(encryptedData, iv: _iv);
  return jsonDecode(decrypted);  // Convert string back to JSON
}
