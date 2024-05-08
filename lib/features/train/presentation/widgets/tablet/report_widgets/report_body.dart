import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/description_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/train_calendar.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/train_list.dart';

class ReportBody extends StatefulWidget {
  const ReportBody({super.key});

  @override
  State<ReportBody> createState() => _ReportBodyState();
}

class _ReportBodyState extends State<ReportBody> {

  List<DateTime?> range = [];

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
                      setState(() {
                        this.range = range;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: TrainList(
                  range: range,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
