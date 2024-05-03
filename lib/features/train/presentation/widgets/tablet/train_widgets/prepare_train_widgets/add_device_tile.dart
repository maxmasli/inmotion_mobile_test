import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';

class AddDeviceTile extends StatelessWidget {
  const AddDeviceTile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppContainer(
      color: theme.colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "Добавить устройство", // TODO intl
              style: theme.textTheme.labelSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SvgPicture.asset(
            AppIcons.add,
          )
        ],
      ),
    );
  }
}
