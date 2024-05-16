import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/core/utils/utils.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:provider/provider.dart';

class TrainCalendar extends StatefulWidget {
  const TrainCalendar({
    super.key,
    required this.onDateRangeSelected, required this.initRange,
  });

  final List<DateTime?> initRange;
  final Function(List<DateTime?> range) onDateRangeSelected;

  @override
  State<TrainCalendar> createState() => _TrainCalendarState();
}

class _TrainCalendarState extends State<TrainCalendar> {
  List<DateTime?> _dates = [];

  @override
  void initState() {
    super.initState();
    _dates = widget.initRange;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Selector<TrainModel, List<TrainEntity>>(
      selector: (context, model) => model.trains,
      builder: (context, trains, child) {
        return AppContainer(
          borderRadius: BorderRadius.circular(16),
          child: CalendarDatePicker2(
            config: CalendarDatePicker2Config(
              calendarType: CalendarDatePicker2Type.range,
              rangeBidirectional: true,
              daySplashColor: Colors.transparent,
              selectedDayHighlightColor: theme.primaryColor,
              dayTextStyle:
                  theme.textTheme.headlineSmall?.copyWith(fontSize: 14),
              selectedDayTextStyle: theme.textTheme.labelSmall,
              dayBuilder: ({
                required DateTime date,
                TextStyle? textStyle,
                BoxDecoration? decoration,
                bool? isSelected,
                bool? isDisabled,
                bool? isToday,
              }) {
                final trainsCount = trains
                    .where((train) => train.startTime.isSameDay(date))
                    .length
                    .clamp(0, 3);
                return Container(
                  decoration: decoration,
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          '${date.day}',
                          style: textStyle,
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            for (int i = 0; i < trainsCount; i++) ...[
                              const _TrainMark()
                            ]
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            value: _dates,
            onValueChanged: (dates) {
              _dates = dates;
              widget.onDateRangeSelected(dates);
            },
          ),
        );
      },
    );
  }
}

class _TrainMark extends StatelessWidget {
  const _TrainMark();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: ClipOval(
        child: SizedBox(
          width: 4,
          height: 4,
          child: ColoredBox(
            color: theme.primaryColor,
          ),
        ),
      ),
    );
  }
}
