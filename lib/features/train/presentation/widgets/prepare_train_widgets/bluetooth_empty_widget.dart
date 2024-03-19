import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';

class BluetoothEmptyWidget extends StatelessWidget {
  const BluetoothEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppContainer(
      padding: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Подключите устроиство",
            style: theme.textTheme.bodyMedium,
          ),
          Text(
            "Включите Bluetooth на смартфоне. Нажмите кнопку ниже и добавьте ранее не подключенный датчик или выберете уже используемый на этом устройстве",
            style: theme.textTheme.displaySmall,
          ),
        ],
      ),
    );
  }
}
