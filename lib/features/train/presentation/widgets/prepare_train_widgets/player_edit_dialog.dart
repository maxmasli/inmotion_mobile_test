import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PlayerEditDialog extends StatefulWidget {
  const PlayerEditDialog({super.key, required this.initFields});

  final ({
    String name,
    String number,
    String deviceNumber,
    String deviceName
  }) initFields;

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
    _nameController = TextEditingController(text: widget.initFields.name);
    _numberController = TextEditingController(text: widget.initFields.number);
    _deviceNumberController =
        TextEditingController(text: widget.initFields.deviceNumber);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(widget.initFields.deviceName,
          style: theme.textTheme.titleMedium),
      content: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      width: 60,
                      child: Text("Имя", style: theme.textTheme.displayMedium)),
                  Expanded(
                    child: _PlayerEditDialogTextField(
                      controller: _nameController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                      width: 60,
                      child:
                          Text("Номер", style: theme.textTheme.displayMedium)),
                  Expanded(
                    child: _PlayerEditDialogTextField(
                      controller: _numberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                      width: 60,
                      child: Text("Датчик ЧСС",
                          style: theme.textTheme.displayMedium)),
                  Expanded(
                    child: _PlayerEditDialogTextField(
                      controller: _deviceNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
