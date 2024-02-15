import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/colors.dart';
import 'package:inmotion_mobile_test/core/utils/stats_calculator.dart';
import 'package:inmotion_mobile_test/core/utils/utils.dart';
import 'package:inmotion_mobile_test/features/main/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/main/presentation/widgets/legend_widget.dart';
import 'package:inmotion_mobile_test/features/main/presentation/widgets/player_line_chart.dart';
import 'package:inmotion_mobile_test/features/main/presentation/widgets/ranges_widget.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';
import 'package:provider/provider.dart';

class PlayerTile extends StatelessWidget {
  const PlayerTile({super.key, required this.player});

  final PlayerEntity player;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider.value(
      value: player,
      child: Consumer<PlayerEntity>(
        builder: (context, player, child) {
          return PhysicalModel(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
            elevation: 2,
            child: ExpansionWidget(
              titleBuilder:
                  (animationValue, easeInValue, isExpanded, toggleFunction) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: GestureDetector(
                    onTap: () {
                      toggleFunction(animated: true);
                    },
                    child: Container(
                      color: theme.colorScheme.primaryContainer,
                      height: 84,
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
                                    getRunBySpeed(player.speed, context),
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
                                              'Датчик 01',
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
                      height: 200,
                      child: PlayerLineChart(data: player.coordinates),
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // TODO переделать с intl
                      children: [
                        LegendItem(
                          text: "Ходьба",
                          color: AppColors.blue,
                          maxWidth: 80,
                          minWidth: 50,
                        ),
                        LegendItem(
                          color: AppColors.green,
                          text: "Легкий бег",
                          maxWidth: 80,
                          minWidth: 50,
                        ),
                        LegendItem(
                          color: AppColors.orange,
                          text: "Средний темп",
                          maxWidth: 80,
                          minWidth: 50,
                        ),
                        LegendItem(
                          color: AppColors.red,
                          text: "Макс. скорость",
                          maxWidth: 80,
                          minWidth: 50,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
