import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptography/cryptography.dart';
import 'package:data/log/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import '../api/space/api_group_key_model.dart';

class EphemeralECDHUtils {
  static const int syntheticIvLength =
      16; // Length of the synthetic initialization vector (IV).

  /// Encrypts the provided plaintext for a specific recipient using their public key.
  static Future<EncryptedDistribution> encrypt(
    String receiverId,
    Uint8List plaintext,
    ECPublicKey receiverPub,
  ) async {
    final ephemeralPubKey = Curve.generateKeyPair();
    final ephemeralPrivateKeyBytes = ephemeralPubKey.privateKey;
    final masterSecret =
        Curve.calculateAgreement(receiverPub, ephemeralPrivateKeyBytes);

    // Compute synthetic IV
    final syntheticIv =
        await _computeSyntheticIv(SecretKey(masterSecret), plaintext);

    // Compute cipher key
    final cipherKey =
        await _computeCipherKey(SecretKey(masterSecret), syntheticIv);

    // Encrypt plaintext
    final algorithm = AesCtr.with128bits(macAlgorithm: MacAlgorithm.empty);
    final secretKey = SecretKey(cipherKey);
    final secretBox = await algorithm.encrypt(
      plaintext,
      secretKey: secretKey,
      nonce: syntheticIv,
    );

    final ciphertext = Uint8List.fromList(secretBox.cipherText);
    final distribution = EncryptedDistribution(
      recipient_id: receiverId,
      ephemeral_pub: Blob(ephemeralPubKey.publicKey.serialize()),
      iv: Blob(Uint8List.fromList(syntheticIv)),
      ciphertext: Blob(ciphertext),
    );
    distribution.validateFieldSizes();
    return distribution;
  }

  /// Computes a synthetic IV using the master secret and plaintext.
  static Future<Uint8List> _computeSyntheticIv(
    SecretKey sharedSecret,
    Uint8List plaintext,
  ) async {
    final mac = Hmac.sha256();

    // Derive synthetic IV key
    final syntheticIvKey = await mac.calculateMac(
      utf8.encode("auth"),
      secretKey: sharedSecret,
    );

    // Compute synthetic IV
    final syntheticIv = await mac.calculateMac(
      plaintext,
      secretKey: SecretKey(syntheticIvKey.bytes),
    );

    return Uint8List.fromList(syntheticIv.bytes.sublist(0, syntheticIvLength));
  }

  static Future<Uint8List> _computeCipherKey(
    SecretKey masterSecret,
    Uint8List syntheticIv,
  ) async {
    final mac = Hmac.sha256();

    // Derive cipher key
    final cipherKeyMaterial = await mac.calculateMac(
      utf8.encode("cipher"),
      secretKey: masterSecret,
    );

    final cipherKey = await mac.calculateMac(
      syntheticIv,
      secretKey: SecretKey(cipherKeyMaterial.bytes),
    );

    return Uint8List.fromList(cipherKey.bytes.sublist(0,
        syntheticIvLength)); // TODO check if this is correct, getting 32 instead of 16
  }

  // Decrypts the provided ciphertext using the provided private key.
  static Future<Uint8List?> decrypt(
    EncryptedDistribution message,
    ECPrivateKey receiverPrivateKey,
  ) async {
    try {
      final mac = Hmac.sha256();

      final syntheticIv = message.iv;
      final cipherText = message.ciphertext;


      final ephemeralPublic = Curve.decodePoint(message.ephemeral_pub.bytes, 0);
      print("XXX receiverPrivateKey ${receiverPrivateKey.serialize().length}");

      final masterSecret =
          Curve.calculateAgreement(ephemeralPublic, receiverPrivateKey);

      final cipherKeyPart1 = await mac.calculateMac(
        utf8.encode("cipher"),
        secretKey: SecretKey(masterSecret),
      );

      final cipherKey = await mac.calculateMac(
        cipherKeyPart1.bytes,
        secretKey: SecretKey(syntheticIv.bytes),
      );

      // Encrypt plaintext
      final algorithm = AesCtr.with128bits(macAlgorithm: MacAlgorithm.empty);
      final secretKey = SecretKey(cipherKey.bytes);
      final secretBox = await algorithm.encrypt(
        cipherText.bytes,
        secretKey: secretKey,
        nonce: syntheticIv.bytes,
      );

      final plaintext = Uint8List.fromList(secretBox.cipherText);

      final verificationPart1 = await mac.calculateMac(
        utf8.encode("auth"),
        secretKey: SecretKey(masterSecret),
      );

      final verificationPart2 = await mac.calculateMac(
        plaintext,
        secretKey: SecretKey(verificationPart1.bytes),
      );

      final ourSyntheticIv = verificationPart2.bytes.sublist(0, 16);

      if (!listEquals(ourSyntheticIv, syntheticIv.bytes)) {
        throw Exception(
            "The computed syntheticIv didn't match the actual syntheticIv.");
      }

      return plaintext;
    } catch (e, s) {
      logger.e("Error while decrypting", error: e, stackTrace: s);
      return null;
    }
  }
}
