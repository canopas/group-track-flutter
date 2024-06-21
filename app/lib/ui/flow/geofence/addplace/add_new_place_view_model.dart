import 'dart:async';

import 'package:data/log/logger.dart';
import 'package:data/service/place_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_new_place_view_model.freezed.dart';

final addNewPLaceStateProvider = StateNotifierProvider.autoDispose<
    AddNewPlaceViewNotifier, AddNewPlaceState>((ref) {
  return AddNewPlaceViewNotifier(ref.read(placeServiceProvider));
});

class AddNewPlaceViewNotifier extends StateNotifier<AddNewPlaceState> {
  final PlaceService placeService;

  AddNewPlaceViewNotifier(this.placeService) : super(const AddNewPlaceState());

  Timer? _debounce;

  void onPlaceNameChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      fidePlace(value);
    });
  }

  void fidePlace(String value) async {
    try {
      state = state.copyWith(loading: true);
     await placeService.findPlace(value,0.0,0.0);
    } catch (error, stack) {
      state = state.copyWith(error: error, loading: false);
      logger.e(
        'PlaceListNotifier: Error while deleting place',
        error: error,
        stackTrace: stack,
      );
    }
  }
}

@freezed
class AddNewPlaceState with _$AddNewPlaceState {
  const factory AddNewPlaceState({
    @Default(false) loading,
    Object? error,
  }) = _AddNewPlaceState;
}
