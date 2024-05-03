import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';

class DeviceTile extends StatelessWidget {
  const DeviceTile({
    super.key,
    required this.onTap,
    required this.device,
  });

  final BluetoothDevice device;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppContainer(
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "ID: ${device.advName} ${device.remoteId.str}",
              style: theme.textTheme.displayMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SvgPicture.asset(
            AppIcons.add,
            colorFilter: ColorFilter.mode(theme.primaryColor, BlendMode.srcIn),
          )
        ],
      ),
    );
  }
}
