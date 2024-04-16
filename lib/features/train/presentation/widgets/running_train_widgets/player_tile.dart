import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/colors.dart';
import 'package:inmotion_mobile_test/core/utils/stats_calculator.dart';
import 'package:inmotion_mobile_test/core/utils/utils.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/running_train_widgets/legend_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/running_train_widgets/player_line_chart.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/running_train_widgets/ranges_widget.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';
import 'package:provider/provider.dart';

class PlayerTile extends StatefulWidget {
  const PlayerTile({
    super.key,
    required this.player,
    required this.maxHeight,
    this.onExpansion,
  });

  final PlayerEntity player;
  final double maxHeight;
  final Function(PlayerEntity, bool)? onExpansion;

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
            return PhysicalModel(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
              elevation: 2,
              child: ExpansionWidget(
                duration: Duration.zero,
                onExpansionWillChange: (isExpanded) {
                  if (widget.onExpansion != null) {
                    widget.onExpansion!(player, isExpanded);
                  }
                  return true;
                },
                titleBuilder:
                    (animationValue, easeInValue, isExpanded, toggleFunction) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: GestureDetector(
                      onTap: () {
                        toggleFunction();
                      },
                      child: Container(
                        color: theme.colorScheme.primaryContainer,
                        height: titleHeight,
                        child: Row(
                          children: [
                            Container(
                              width: 90,
                              color: getColorByPulse(player.pulse),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SvgPicture.asset(
                                          AppIcons.heart,
                                          width: 14,
                                          height: 14,
                                        ),
                                        Text(
                                          "${player.pulse}",
                                          style: theme.textTheme.labelLarge,
                                        )
                                      ],
                                    ),
                                    Text(
                                      getRunBySpeed(player.speedMps, context),
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.labelSmall,
                                    )
                                  ],
                                ),
                              ),
                            ),
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
                                              Text('${player.number}',
                                                  style: theme
                                                      .textTheme.headlineMedium),
                                              Text(
                                                'Датчик ${player.sensor?.number}',
                                                style:
                                                    theme.textTheme.headlineSmall,
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                  Text(
                                                    "${player.distance} м",
                                                    style: theme
                                                        .textTheme.displaySmall,
                                                  ),
                                                  const SizedBox(width: 22),
                                                  Text(
                                                    "${player.steps} шагов",
                                                    style: theme
                                                        .textTheme.displaySmall,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  LayoutBuilder(
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
                                              style: theme.textTheme.displaySmall
                                                  ?.copyWith(
                                                color: AppColors.blue,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                content: Container(
                  height: widget.maxHeight - titleHeight - 30,
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: widget.maxHeight - titleHeight - 100,
                        child: Row(
                          children: [
                            Expanded(
                              child: PlayerLineChart(data: player.coordinates),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: AppColors.darkBlue),
                                        ),
                                        child: Text(
                                          player.speedKph.toStringAsFixed(1),
                                          style: theme.textTheme.labelMedium
                                              ?.copyWith(
                                                  color: AppColors.darkBlue),
                                        ),
                                      ),
                                      // TODO переделать с intl
                                      Text(
                                        "км/ч",
                                        style: theme.textTheme.displaySmall,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 12,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                              AppColors.blue,
                              AppColors.green,
                              AppColors.orange,
                              AppColors.red,
                            ])),
                      ),
                      const SizedBox(height: 8),
                      DefaultTextStyle(
                        style: theme.textTheme.displaySmall!,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // TODO переделать с intl
                          children: [
                            LegendItem(
                              text: "Ходьба",
                              color: AppColors.blue,
                              maxWidth: 80,
                              minWidth: 50,
                              hasOverflow: false,
                            ),
                            LegendItem(
                              color: AppColors.green,
                              text: "Легкий бег",
                              maxWidth: 80,
                              minWidth: 50,
                              hasOverflow: false,
                            ),
                            LegendItem(
                              color: AppColors.orange,
                              text: "Средний темп",
                              maxWidth: 80,
                              minWidth: 50,
                              hasOverflow: false,
                            ),
                            LegendItem(
                              color: AppColors.red,
                              text: "Макс. скорость",
                              maxWidth: 80,
                              minWidth: 50,
                              hasOverflow: false,
                            ),
                          ],
                        ),
                      )
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
}
