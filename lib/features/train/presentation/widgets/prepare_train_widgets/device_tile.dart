import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';

class DeviceTile extends StatelessWidget {
  const DeviceTile({super.key, required this.device, required this.onTap});

  final BluetoothDevice device;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppContainer(
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(10),
      onTap: onTap,
      child: Text(
        "${device.advName} ${device.remoteId.str}",
        style: theme.textTheme.bodyMedium,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
