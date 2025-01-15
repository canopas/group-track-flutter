import 'dart:math';

import 'package:flutter/material.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/extenstions/date_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/date_formatter.dart';
import 'package:yourspace_flutter/ui/flow/journey/calender/three_page_scroller.dart';

class HorizontalCalendarView extends StatefulWidget {
  final DateTime allowedAfterDate;
  final DateTime weekStartDate;
  final DateTime selectedDate;
  final ValueChanged<int> onSwipeWeek;
  final void Function(DateTime date) onTap;

  const HorizontalCalendarView({
    super.key,
    required this.allowedAfterDate,
    required this.weekStartDate,
    required this.selectedDate,
    required this.onSwipeWeek,
    required this.onTap,
  });

  @override
  State<HorizontalCalendarView> createState() => _HorizontalCalendarViewState();
}

class _HorizontalCalendarViewState extends State<HorizontalCalendarView> {
  @override
  Widget build(BuildContext context) {
    final previousWeekDate =
        widget.weekStartDate.subtract(const Duration(days: 7));
    final nextWeekDate = widget.weekStartDate.add(const Duration(days: 7));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 16),
          child: ThreePageScroller(
            current: _weekDays(startDate: widget.weekStartDate),
            previous: _weekDays(startDate: previousWeekDate),
            next: _weekDays(startDate: nextWeekDate),
            onPageChanged: (direction) => widget.onSwipeWeek(direction),
          ),
        ),
        Divider(thickness: 1, height: 1, color: context.colorScheme.outline)
      ],
    );
  }

  Widget _weekDays({
    required DateTime startDate,
  }) {
    final weekDays = <DateTime>[];
    for (var i = 0; i < 7; i++) {
      weekDays.add(startDate.add(Duration(days: i)));
    }
    final isWeekAfter = weekDays.first.isAfter(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: weekDays.map(
          (date) {
            return isWeekAfter
                ? const SizedBox()
                : _weekDayItem(date: date, context: context);
          },
        ).toList(),
      ),
    );
  }

  Widget _weekDayItem({required BuildContext context, required DateTime date}) {
    final bool isSelected = date.isSameDay(widget.selectedDate);
    final groupCreatedDate = widget.allowedAfterDate.add(const Duration(days: -1));
    final isDayAfter = date.isAfter(DateTime.now());
    final isDayBefore = date.isBefore(groupCreatedDate);
    final textColor = isDayAfter || isDayBefore
        ? context.colorScheme.textDisabled
        : context.colorScheme.textPrimary;

    return Expanded(
      child: GestureDetector(
        onTap: () => (!isDayAfter && !isDayBefore) ? widget.onTap(date) : null,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                width: [48, constraints.maxWidth].reduce(min).toDouble(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isSelected
                      ? context.colorScheme.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: (isSelected || !date.isToday)
                        ? Colors.transparent
                        : context.colorScheme.containerLow,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      date.format(context, DateFormatType.weekShort),
                      style: AppTextStyle.caption.copyWith(
                        color: isSelected
                            ? context.colorScheme.textInversePrimary
                            : context.colorScheme.textDisabled,
                      ),
                      textScaler: TextScaler.noScaling,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date.day.toString(),
                      style: AppTextStyle.bodyBold.copyWith(
                        color: isSelected
                            ? context.colorScheme.textInversePrimary
                            : textColor,
                      ),
                      textScaler: TextScaler.noScaling,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
