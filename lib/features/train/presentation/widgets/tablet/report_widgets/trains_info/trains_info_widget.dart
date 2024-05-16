import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/train_calendar.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/trains_info/description_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/trains_info/train_list.dart';

class TrainsInfoWidget extends StatelessWidget {
  const TrainsInfoWidget({
    super.key,
    required this.range,
    required this.onRangeChanged,
    required this.onTrainSelect,
  });

  final List<DateTime?> range;
  final Function(List<DateTime?>) onRangeChanged;
  final Function(TrainEntity) onTrainSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DescriptionWidget(),
        const SizedBox(height: 10),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: TrainCalendar(
                    onDateRangeSelected: (List<DateTime?> range) {
                      onRangeChanged(range);
                    },
                    initRange: range,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: TrainList(
                  range: range,
                  onTrainSelect: (train) {
                    onTrainSelect(train);
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
