import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayerEditDialog extends StatefulWidget {
  const PlayerEditDialog({super.key, required this.initFields});

  final (String name, String number, String deviceNumber) initFields;

  @override
  State<PlayerEditDialog> createState() => _PlayerEditDialogState();
}

class _PlayerEditDialogState extends State<PlayerEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _numberController;
  late TextEditingController _deviceNumberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initFields.$1);
    _numberController = TextEditingController(text: widget.initFields.$2);
    _deviceNumberController = TextEditingController(text: widget.initFields.$3);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text("Редактирование игрока", style: theme.textTheme.titleMedium),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Имя", style: theme.textTheme.displayMedium),
          _PlayerEditDialogTextField(
            controller: _nameController,
          ),
          const SizedBox(height: 10),
          Text("Номер", style: theme.textTheme.displayMedium),
          _PlayerEditDialogTextField(
            controller: _numberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          const SizedBox(height: 10),
          Text("Номер датчика", style: theme.textTheme.displayMedium),
          _PlayerEditDialogTextField(
            controller: _deviceNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Отменить",
            style: theme.textTheme.titleSmall,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, (
              _nameController.text,
              _numberController.text,
              _deviceNumberController.text,
            ));
          },
          child: Text(
            "Сохранить",
            style: theme.textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}

class _PlayerEditDialogTextField extends StatelessWidget {
  const _PlayerEditDialogTextField({
    required this.controller,
    this.inputFormatters,
    this.keyboardType,
  });

  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      keyboardType: keyboardType,
      controller: controller,
      inputFormatters: inputFormatters,
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
