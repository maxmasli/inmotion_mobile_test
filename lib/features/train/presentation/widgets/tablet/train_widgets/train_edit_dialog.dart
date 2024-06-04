import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_button.dart';

class TrainEditDialog extends StatefulWidget {
  const TrainEditDialog({
    super.key,
    required this.initFields,
  });

  final ({String name, String description}) initFields;

  @override
  State<TrainEditDialog> createState() => _TrainEditDialogState();
}

class _TrainEditDialogState extends State<TrainEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descrController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initFields.name);
    _descrController =
        TextEditingController(text: widget.initFields.description);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(
        'Данные о тренировке',
        style: theme.textTheme.titleMedium,
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 400, maxWidth: 500),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                      width: 80,
                      child: Text("Название",
                          style: theme.textTheme.displayMedium)),
                  Expanded(
                    child: _TrainEditDialogTextField(
                      controller: _nameController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: 80,
                      child: Text("Описание",
                          style: theme.textTheme.displayMedium)),
                  Expanded(
                    child: _TrainEditDialogTextField(
                      controller: _descrController,
                      maxLines: 4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      color: theme.colorScheme.secondaryContainer,
                      onTap: () {
                        Navigator.pop(context, (
                          _nameController.text.trim(),
                          _descrController.text.trim(),
                        ));
                      },
                      borderRadius: BorderRadius.circular(8),
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          "Сохранить",
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppButton(
                      color: theme.colorScheme.secondaryContainer,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(8),
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          "Отмена",
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TrainEditDialogTextField extends StatelessWidget {
  const _TrainEditDialogTextField({
    required this.controller,
    this.maxLines,
  });

  final TextEditingController controller;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(4),
        isCollapsed: true,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor)),
      ),
    );
  }
}
