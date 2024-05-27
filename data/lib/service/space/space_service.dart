import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/space/api_space_invitation_service/api_space_invitation_service.dart';
import '../../api/space/api_space_service/api_space_service.dart';

final spaceServiceProvider = Provider((ref) => SpaceService(
  ref.read(apiSpaceServiceProvider),
  ref.read(apiSpaceInvitationServiceProvider),
));

class SpaceService {
  final ApiSpaceService spaceService;
  final ApiSpaceInvitationService spaceInvitationService;

  SpaceService(this.spaceService, this.spaceInvitationService);

  Future<String> createSpaceAndGetInviteCode(String spaceName) async {
    final String spaceId = await spaceService.createSpace(spaceName);
    final String generatedCode = await spaceInvitationService.createInvitation(spaceId);
    // currentSpaceId = spaceId;
    return generatedCode;
  }
}
