import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' show sha256;
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptDecrypt {
  Future<String> encryptPrivateKey(dynamic value, String groupKey) async {
    final key = Uint8List.fromList(sha256.convert(utf8.encode(groupKey)).bytes);

    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key(key), mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encryptBytes(value, iv: iv);

    return base64Encode(iv.bytes + encrypted.bytes);
  }

  Future<Uint8List> decryptPrivateKey(String encryptedData, String groupKey) async {
    final key = Uint8List.fromList(sha256.convert(utf8.encode(groupKey)).bytes);

    final fullData = base64Decode(encryptedData);

    final iv = encrypt.IV(fullData.sublist(0, 16));
    final encryptedBytes = fullData.sublist(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key(key), mode: encrypt.AESMode.cbc));

    final decryptedBytes = encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);

    return Uint8List.fromList(decryptedBytes);
  }
}