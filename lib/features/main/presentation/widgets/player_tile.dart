import 'package:flutter/material.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/colors.dart';
import 'package:inmotion_mobile_test/features/main/presentation/widgets/ranges_widget.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';

class PlayerTile extends StatelessWidget {
  const PlayerTile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PhysicalModel(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: ExpansionWidget(
        titleBuilder: (
          double animationValue,
          double easeInValue,
          bool isExpanded,
          dynamic Function({bool animated}) toggleFunction,
        ) {
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
                      color: AppColors.green,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.heart,
                                  width: 14,
                                  height: 14,
                                ),
                                Text(
                                  "110",
                                  style: theme.textTheme.labelLarge,
                                )
                              ],
                            ),
                            Text(
                              "Трусцой",
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('8',
                                          style: theme.textTheme.headlineMedium),
                                      Text('Датчик 01',
                                          style: theme.textTheme.headlineSmall)
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "Иванов И.",
                                          style: theme.textTheme.headlineMedium,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "2500 м",
                                            style: theme.textTheme.displaySmall,
                                          ),
                                          const SizedBox(width: 22),
                                          Text(
                                            "5000 шагов",
                                            style: theme.textTheme.displaySmall,
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
                                values: const [
                                  0.12,
                                  0.15,
                                  0.28,
                                  0.36,
                                  0.09,
                                ],
                                builder: (value, i) {
                                  return Center(
                                    child: Text(
                                      '${(value * 100).round()}%',
                                      style:
                                          theme.textTheme.displaySmall?.copyWith(
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
          height: 200,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          child: const Center(
            child: Text("graph"),
          ),
        ),
      ),
    );
  }
}
