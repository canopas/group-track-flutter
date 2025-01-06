import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style/extenstions/date_extenstions.dart';

part 'horizontal_calendar_view_model.freezed.dart';

final horizontalCalendarViewStateProvider = StateNotifierProvider.autoDispose<
    HorizontalCalendarViewModel, CalendarViewState>((ref) {
  return HorizontalCalendarViewModel();
});

class HorizontalCalendarViewModel extends StateNotifier<CalendarViewState> {

  HorizontalCalendarViewModel() : super(
    CalendarViewState(
      weekStartDate: DateTime.now().startOfDay,
      selectedDate: DateTime.now().startOfDay,
    ),
  ) {
    setCurrentWeekStartDate();
  }

  void setCurrentWeekStartDate() {
    final currentDate = state.selectedDate;
    // Monday
    final dayOfWeek = currentDate.weekday;
    final daysToSubtract = dayOfWeek == 1 ? 0 : dayOfWeek - 1;
    final currentWeekStartDate =
    currentDate.subtract(Duration(days: daysToSubtract));
    state = state.copyWith(weekStartDate: currentWeekStartDate);
  }

  void onSwipeWeek(int direction) {
    final currentWeekStartDate = state.weekStartDate;
    final newWeekStartDate =
    currentWeekStartDate.add(Duration(days: direction * 7));
    if(newWeekStartDate.isAfter(DateTime.now().startOfDay)) {
      return;
    }
    state = state.copyWith(weekStartDate: newWeekStartDate);
    setContainsToday();
  }

  void setSelectedDate(DateTime? date) {
    state =
        state.copyWith(selectedDate: date?.startOfDay ?? DateTime.now().startOfDay);
  }

  void setContainsToday() {
    final DateTime today = DateTime.now();
    final DateTime endOfWeek =
    state.weekStartDate.add(const Duration(days: 6));

    final containsToday =
        today.isAfter(state.weekStartDate) && today.isBefore(endOfWeek);
    state = state.copyWith(containsToday: containsToday);
  }

  void goToToday() {
    setSelectedDate(DateTime.now());
    setCurrentWeekStartDate();
    setContainsToday();
  }
}

@freezed
class CalendarViewState with _$CalendarViewState {
  const factory CalendarViewState({
    required DateTime selectedDate,
    required DateTime weekStartDate,
    @Default(true) bool containsToday,
  }) = _CalendarViewState;
}