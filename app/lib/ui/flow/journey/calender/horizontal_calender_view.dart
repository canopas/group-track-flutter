import 'dart:math';

import 'package:flutter/material.dart';
import 'package:style/animation/on_tap_scale.dart';
import 'package:style/extenstions/context_extenstions.dart';
import 'package:style/extenstions/date_extenstions.dart';
import 'package:style/text/app_text_dart.dart';
import 'package:yourspace_flutter/domain/extenstions/context_extenstions.dart';
import 'package:yourspace_flutter/domain/extenstions/date_formatter.dart';
import 'package:yourspace_flutter/ui/flow/journey/calender/three_page_scroller.dart';

class HorizontalCalenderView extends StatefulWidget {
  final bool showDatePicker;
  final DateTime weekStartDate;
  final DateTime selectedDate;
  final ValueChanged<int> onSwipeWeek;
  final void Function(DateTime date) onTap;
  final bool showTodayBtn;
  final VoidCallback onTodayTap;

  const HorizontalCalenderView({
    super.key,
    required this.showDatePicker,
    required this.weekStartDate,
    required this.selectedDate,
    required this.onSwipeWeek,
    required this.onTap,
    required this.showTodayBtn,
    required this.onTodayTap,
  });

  @override
  State<HorizontalCalenderView> createState() => _HorizontalCalenderViewState();
}

class _HorizontalCalenderViewState extends State<HorizontalCalenderView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: widget.showDatePicker
          ? _calendar(context)
          : const SizedBox(height: 0),
    );
  }

  Widget _calendar(BuildContext context) {
    final previousWeekDate =
        widget.weekStartDate.subtract(const Duration(days: 7));
    final nextWeekDate = widget.weekStartDate.add(const Duration(days: 7));

    return Column(
      children: [
        _dateHeaderView(),
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

  Widget _dateHeaderView() {
    return Padding(
      padding: const EdgeInsets.only(top: 4,left: 16, right: 16),
      child: Row(
        children: [
          Text(
            widget.selectedDate.format(context, DateFormatType.relativeDate),
            style: AppTextStyle.header4,
          ),
          const Spacer(),
          Visibility(
            visible: widget.showTodayBtn,
            child: OnTapScale(
              onTap: () => widget.onTodayTap(),
              child: Text(
                context.l10n.common_today,
                style: AppTextStyle.button.copyWith(
                  color: context.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _weekDays({
    required DateTime startDate,
  }) {
    final weekDays = <DateTime>[];
    for (var i = 0; i < 7; i++) {
      weekDays.add(startDate.add(Duration(days: i)));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: weekDays.map(
          (date) {
            return _weekDayItem(date: date, context: context);
          },
        ).toList(),
      ),
    );
  }

  Widget _weekDayItem({required BuildContext context, required DateTime date}) {
    final bool isSelected = date.isSameDay(widget.selectedDate);

    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap(date),
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
                            : context.colorScheme.textPrimary,
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
