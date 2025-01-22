import 'dart:math';

import 'package:data/log/logger.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:uuid/uuid.dart';

import '../api/space/api_group_key_model.dart';
import '../api/space/space_models.dart';
import 'buffered_sender_keystore.dart';
import 'ephemeral_distribution_helper.dart';

Future<ApiMemberKeyData> generateMemberKeyData(String spaceId,
    {required String senderUserId,
    required List<ApiSpaceMember> spaceMembers,
    required BufferedSenderKeystore bufferedSenderKeyStore,
    int? memberDeviceId}) async {
  final deviceId = memberDeviceId ?? Random.secure().nextInt(0x7FFFFFFF);
  final groupAddress = SignalProtocolAddress(spaceId, deviceId);
  final sessionBuilder = GroupSessionBuilder(bufferedSenderKeyStore);
  final senderKey = SenderKeyName(spaceId, groupAddress);

  //print("XXXX generateMemberKeyData senderUserId $senderUserId");

  final distributionMessage = await sessionBuilder.create(senderKey);
  final distributionBytes = distributionMessage.serialize();

  // print("XXX create DM:${distributionMessage.serialize()}");
  //print("XXX create SK ${senderKey.serialize()}");

  // print(
  //     "XXXX create senderKey groupId ${senderKey.groupId} sender name ${senderKey.sender.getName()}, devicId ${senderKey.sender.getDeviceId()}");

  final List<EncryptedDistribution> distributions = [];

  for (final member in spaceMembers) {
    final publicKeyBytes = member.identity_key_public;

    if (publicKeyBytes == null) continue;

    try {
      if (publicKeyBytes.length != 33) {
        logger.e(
            "Invalid public key size for member ${member.user_id} length: ${publicKeyBytes.length}");
        continue;
      }

      final publicKey = Curve.decodePoint(publicKeyBytes, 0);

      final encryptedDistribution = await EphemeralECDHUtils.encrypt(
        member.user_id,
        distributionBytes,
        publicKey,
      );
      distributions.add(encryptedDistribution);
    } catch (e) {
      logger.e("Failed to decode public key for member ${member.user_id}: $e");
      continue;
    }
  }

  return ApiMemberKeyData(
      data_updated_at: DateTime.now().millisecondsSinceEpoch,
      member_device_id: deviceId,
      distributions: distributions);
}
