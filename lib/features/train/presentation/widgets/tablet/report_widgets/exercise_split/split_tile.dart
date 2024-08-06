import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/train_text_field.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/split_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';

class SplitTile extends StatefulWidget {
  const SplitTile({
    super.key,
    required this.onCheckboxTap,
    required this.isSelected,
    required this.split,
    required this.onSplitUpdated,
    required this.trainDuration,
  });

  final SplitEntity split;
  final Function() onCheckboxTap;
  final Function(SplitEntity) onSplitUpdated;
  final bool isSelected;
  final Duration trainDuration;

  @override
  State<SplitTile> createState() => _SplitTileState();
}

class _SplitTileState extends State<SplitTile> {
  final totalController = TextEditingController();
  final startController = TextEditingController();
  final endController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.split.name;
    if (widget.split.correctFragments(widget.trainDuration)) {
      startController.text = widget.split.startFragment!.format();
      endController.text = widget.split.endFragment!.format();
      totalController.text =
          (widget.split.endFragment! - widget.split.startFragment!).format();
    }
  }

  void _updateFields() {
    if (widget.split.startFragment != null &&
        widget.split.endFragment != null &&
        widget.split.correctFragments(widget.trainDuration)) {
      totalController.text =
          (widget.split.endFragment! - widget.split.startFragment!).format();
    } else {
      totalController.text = "";
    }
    if (widget.split.startFragment != null) {
      startController.text = widget.split.startFragment!.format();
    }
    if (widget.split.endFragment != null) {
      endController.text = widget.split.endFragment!.format();
    }

    widget.onSplitUpdated(widget.split);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: TrainTextField(
              onChanged: (String value) {
                widget.split.name = value;
                widget.onSplitUpdated(widget.split);
              },
              controller: nameController,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: TrainTextField(
              onChanged: (String value) {
                widget.split.tryParseStartFragment(value);
                _updateFields();
                setState(() {});
              },
              error: !widget.split.correctFragments(widget.trainDuration),
              controller: startController,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: TrainTextField(
              onChanged: (String value) {
                widget.split.tryParseEndFragment(value);
                _updateFields();
                setState(() {});
              },
              error: !widget.split.correctFragments(widget.trainDuration),
              controller: endController,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: TrainTextField(
              enabled: false,
              error: !widget.split.correctFragments(widget.trainDuration),
              onChanged: (String value) {},
              controller: totalController,
            ),
          ),
          Checkbox(
            value: widget.isSelected,
            onChanged: (value) {
              widget.onCheckboxTap();
            },
          )
        ],
      ),
    );
  }
}
