import 'package:data/api/auth/auth_models.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_view_model.freezed.dart';

final mapViewStateProvider =
    StateNotifierProvider.autoDispose<MapViewNotifier, MapViewState>((ref) {
  final notifier = MapViewNotifier(
    ref.read(currentUserSessionJsonPod.notifier),
  );
  return notifier;
});

class MapViewNotifier extends StateNotifier<MapViewState> {
  final StateController<String?> _currentSpaceId;

  MapViewNotifier(this._currentSpaceId) : super(const MapViewState()) {
    spaceId(_currentSpaceId.state);
  }

  void spaceId(String? spaceId) {
    print('XXX space id:${spaceId}');
  }

  void getSpaceMembersLocation() async {

  }
}

@freezed
class MapViewState with _$MapViewState {
  const factory MapViewState({
    ApiUserInfo? selectedMember,
    Object? error,
  }) = _MapViewState;
}
