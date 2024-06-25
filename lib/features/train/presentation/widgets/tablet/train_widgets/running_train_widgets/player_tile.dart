import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/colors.dart';
import 'package:inmotion_mobile_test/core/utils/stats_calculator.dart';
import 'package:inmotion_mobile_test/core/utils/utils.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/mobile/running_train_widgets/ranges_widget.dart';
import 'package:inmotion_mobile_test/core/presentation/heartbeat_widget.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';
import 'package:provider/provider.dart';

class PlayerTile extends StatefulWidget {
  const PlayerTile({
    super.key,
    required this.player,
    required this.onTap,
    required this.isSelected,
  });

  final PlayerEntity player;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  State<PlayerTile> createState() => _PlayerTileState();
}

class _PlayerTileState extends State<PlayerTile> {
  final titleHeight = 84.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RepaintBoundary(
      child: ChangeNotifierProvider.value(
        value: widget.player,
        child: Consumer<PlayerEntity>(
          builder: (context, player, child) {
            final isHrOk = player.sensor!.isHrOk;
            return PhysicalModel(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(18),
              elevation: 2,
              child: GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  height: titleHeight,
                  decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      border: widget.isSelected
                          ? Border.all(color: AppColors.darkBlue, width: 2)
                          : null,
                      borderRadius: BorderRadius.circular(18)),
                  child: Row(
                    children: [
                      hrInfo(player),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(width: 14),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${player.number}',
                                          style: theme.textTheme.headlineMedium,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Датчик ${player.sensor?.number}',
                                          style: theme.textTheme.headlineSmall,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                player.name,
                                                style: theme
                                                    .textTheme.headlineMedium,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                if (!isHrOk)
                                                  SvgPicture.asset(
                                                    AppIcons.heart,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                      theme.colorScheme.error,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${player.distance} м",
                                              style:
                                                  theme.textTheme.displaySmall,
                                            ),
                                            const SizedBox(width: 22),
                                            Text(
                                              "${player.steps} шагов",
                                              style:
                                                  theme.textTheme.displaySmall,
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ),
                            rangesWidget(player),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget rangesWidget(PlayerEntity player) {
    final isHrOk = player.sensor!.isHrOk;
    final theme = Theme.of(context);
    if (isHrOk) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(14)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return RangesWidget(
              width: constraints.maxWidth,
              height: 30,
              values: StatsCalculator.getHrStats(
                player.hrMeasures,
              ),
              builder: (value, i) {
                return Center(
                  child: Text(
                    '${(value * 100).round()}%',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: AppColors.blue,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }

  Widget hrInfo(PlayerEntity player) {
    final isHrOk = player.sensor!.isHrOk;
    final theme = Theme.of(context);
    if (isHrOk) {
      return Container(
        padding: EdgeInsets.zero,
        width: 80,
        decoration: BoxDecoration(
            color: getColorByPulse(player.pulse),
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(14))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HeartbeatWidget(
                  frequency: player.pulse,
                  child: SvgPicture.asset(
                    AppIcons.heart,
                    width: 14,
                    height: 14,
                  ),
                ),
                Text(
                  "${player.pulse}",
                  style: theme.textTheme.labelLarge,
                )
              ],
            ),
            Text(
              getRunBySpeed(player.speedMps, context),
              overflow: TextOverflow.visible,
              maxLines: 1,
              style: theme.textTheme.labelSmall,
            )
          ],
        ),
      );
    } else {
      return Container(
        width: 80,
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.horizontal(left: Radius.circular(16)),
          color: theme.primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.heart,
                width: 14,
                height: 14,
              ),
              const SizedBox(height: 5),
              Text(
                getRunBySpeed(player.speedMps, context),
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        ),
      );
    }
  }
}
