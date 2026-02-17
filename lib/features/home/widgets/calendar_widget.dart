import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Function(DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;

  const CalendarWidget({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late List<DateTime> _days;

  @override
  void initState() {
    super.initState();
    _days = _getDaysForCalendar(widget.focusedDay);
  }

  @override
  void didUpdateWidget(covariant CalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusedDay.year != widget.focusedDay.year ||
        oldWidget.focusedDay.month != widget.focusedDay.month) {
      _days = _getDaysForCalendar(widget.focusedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('MMMM yyyy').format(widget.focusedDay),
              style: AppTheme.serifTitleStyle.copyWith(fontSize: 20.sp),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onPageChanged(
                      DateTime(
                        widget.focusedDay.year,
                        widget.focusedDay.month - 1,
                      ),
                    );
                  },
                  child: const Icon(Icons.chevron_left, color: Colors.grey),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () {
                    widget.onPageChanged(
                      DateTime(
                        widget.focusedDay.year,
                        widget.focusedDay.month + 1,
                      ),
                    );
                  },
                  child: const Icon(Icons.chevron_right, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 20.h),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: Container(
            key: ValueKey(widget.focusedDay),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ["M", "T", "W", "T", "F", "S", "S"]
                      .map(
                        (e) => SizedBox(
                          width: 30.w,
                          child: Center(
                            child: Text(
                              e,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFA0A0B0),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 16.h),
                ..._buildCalendarWeeks(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCalendarWeeks() {
    // Only use cached _days
    final List<Widget> weeks = [];

    for (int i = 0; i < _days.length; i += 7) {
      weeks.add(
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _days
                .sublist(i, i + 7)
                .map((day) => _buildCalendarDay(day))
                .toList(),
          ),
        ),
      );
    }
    return weeks;
  }

  Widget _buildCalendarDay(DateTime day) {
    bool isSelected =
        day.year == widget.selectedDay.year &&
        day.month == widget.selectedDay.month &&
        day.day == widget.selectedDay.day;
    bool isOutsideMonth = day.month != widget.focusedDay.month;
    bool isToday =
        day.year == DateTime.now().year &&
        day.month == DateTime.now().month &&
        day.day == DateTime.now().day;

    return GestureDetector(
      onTap: () => widget.onDaySelected(day),
      child: Container(
        width: 35.w,
        height: 40.h,
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.pink,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.pink.withOpacity(0.4),
                    blurRadius: 8.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              )
            : (isToday
                  ? BoxDecoration(
                      border: Border.all(
                        color: AppColors.pink.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    )
                  : null),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${day.day}",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isOutsideMonth
                          ? AppColors.greyText.withOpacity(0.5)
                          : AppColors.darkText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DateTime> _getDaysForCalendar(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);

    final int padDays = firstDayOfMonth.weekday - 1;
    final List<DateTime> days = [];

    // Previous month days
    final prevMonthLastDay = DateTime(month.year, month.month, 0);
    for (int i = 0; i < padDays; i++) {
      days.add(prevMonthLastDay.subtract(Duration(days: padDays - 1 - i)));
    }

    // Current month days
    for (int i = 0; i < lastDayOfMonth.day; i++) {
      days.add(firstDayOfMonth.add(Duration(days: i)));
    }

    // Next month days
    final int remaining = 42 - days.length;
    final nextMonthFirstDay = DateTime(month.year, month.month + 1, 1);
    for (int i = 0; i < remaining; i++) {
      days.add(nextMonthFirstDay.add(Duration(days: i)));
    }

    return days;
  }
}
