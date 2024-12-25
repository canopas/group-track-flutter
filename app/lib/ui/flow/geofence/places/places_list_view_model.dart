import 'dart:async';

import 'package:data/api/auth/auth_models.dart';
import 'package:data/api/place/api_place.dart';
import 'package:data/api/space/api_space_service.dart';
import 'package:data/api/space/space_models.dart';
import 'package:data/log/logger.dart';
import 'package:data/service/place_service.dart';
import 'package:data/service/space_service.dart';
import 'package:data/storage/app_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'places_list_view_model.freezed.dart';

final placesListViewStateProvider =
    StateNotifierProvider.autoDispose<PlacesListViewNotifier, PlacesListState>(
        (ref) {
  return PlacesListViewNotifier(
    ref.read(currentUserPod),
    ref.read(placeServiceProvider),
    ref.read(spaceServiceProvider),
    ref.read(apiSpaceServiceProvider),
  );
});

class PlacesListViewNotifier extends StateNotifier<PlacesListState> {
  final PlaceService placeService;
  final SpaceService spaceService;
  final ApiSpaceService apiSpaceService;
  late StreamSubscription<List<ApiSpaceMember>> _spaceMemberSubscription;

  PlacesListViewNotifier(
      currentUser, this.placeService, this.spaceService, this.apiSpaceService)
      : super(PlacesListState(currentUser: currentUser));

  void loadPlaces(String spaceId) async {
    if (state.loading) return;
    try {
      state = state.copyWith(loading: true, spaceId: spaceId);
      placeService.getAllPlacesStream(spaceId).listen((places) {
        print(places.map((e) => e.space_member_ids));
        if (!mounted) return;
        suggestionPlaces(places);
        state = state.copyWith(places: places, loading: false, error: null);
      });
    } catch (error, stack) {
      state = state.copyWith(loading: false, error: error);
      logger.e(
        'PlacesListViewNotifier: Error while getting All places',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void getSpaceMember(String spaceId) {
    try {
      _spaceMemberSubscription = apiSpaceService
          .getStreamSpaceMemberBySpaceId(spaceId)
          .listen((member) {
        if (mounted) {
          state = state.copyWith(spaceMember: member);
        }
      });
    } catch (error, stack) {
      state = state.copyWith(error: error);
      logger.e('PlaceListViewNotifier: error while stream space info',
          error: error, stackTrace: stack);
    }
  }

  void suggestionPlaces(List<ApiPlace> places) {
    final suggestedPlaces = [
      'Home',
      'Work',
      'School',
      'Gym',
      'Library',
      'Local park'
    ];

    final newSuggestedPlace = suggestedPlaces.where((suggestion) {
      final suggestionName = suggestion.toLowerCase();

      for (final place in places) {
        final placeName = place.name.toLowerCase();
        if (suggestionName == placeName) {
          return false;
        }
      }
      return true;
    }).toList();
    state = state.copyWith(suggestions: newSuggestedPlace);
  }

  void onClickDeletePlace(ApiPlace place) {
    state = state.copyWith(
      placesToDelete: place,
      showDeletePlaceDialog: DateTime.now(),
    );
  }

  void dismissDeletePlaceDialog() {
    state = state.copyWith(placesToDelete: null);
  }

  void deletePlace() async {
    try {
      state = state.copyWith(deletingPlaces: true);
      final place = state.placesToDelete;
      await placeService.deletePlace(state.spaceId!, place!.id);
      state = state.copyWith(deletingPlaces: false);
    } catch (error, stack) {
      state = state.copyWith(deletingPlaces: false);
      logger.e(
        'PlaceListNotifier: Error while deleting place',
        error: error,
        stackTrace: stack,
      );
    }
  }

  void onAddNewMemberTap(String spaceId) async {
    try {
      state = state.copyWith(fetchingInviteCode: true);
      final code =
      await spaceService.getInviteCode(spaceId);
      state = state.copyWith(
          spaceInvitationCode: code ?? '',
          fetchingInviteCode: false,
          error: null);
    } catch (error, stack) {
      state = state.copyWith(error: error);
      logger.e(
        'MessageViewNotifier: Error while getting invitation code',
        error: error,
        stackTrace: stack,
      );
    }
  }

  @override
  void dispose() {
    _spaceMemberSubscription.cancel();
    super.dispose();
  }
}

@freezed
class PlacesListState with _$PlacesListState {
  const factory PlacesListState({
    @Default(false) bool loading,
    @Default(false) bool deletingPlaces,
    @Default(false) bool fetchingInviteCode,
    @Default('') String spaceInvitationCode,
    String? spaceId,
    DateTime? showDeletePlaceDialog,
    ApiPlace? placesToDelete,
    ApiUser? currentUser,
    @Default([]) List<ApiPlace> places,
    @Default([]) List<String> suggestions,
    @Default([]) List<ApiSpaceMember> spaceMember,
    Object? error,
  }) = _PlacesListState;
}

@freezed
class Suggestions with _$Suggestions {
  const factory Suggestions({
    required String name,
    required String icon,
  }) = _Suggestions;
}
