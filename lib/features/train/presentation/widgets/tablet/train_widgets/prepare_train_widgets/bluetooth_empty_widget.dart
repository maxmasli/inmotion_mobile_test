import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';

class BluetoothEmptyWidget extends StatelessWidget {
  const BluetoothEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AppContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColoredBox(
              color: theme.colorScheme.secondaryContainer,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Подключите устройство",
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  "Включите Bluetooth на смартфоне.\nНажмите кнопку ниже для добавление нового датчика",
                  style: theme.textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
