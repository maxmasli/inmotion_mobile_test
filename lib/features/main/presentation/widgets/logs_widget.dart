import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/core/presentation/app_logs_controller.dart';
import 'package:inmotion_mobile_test/di.dart';
import 'package:inmotion_mobile_test/features/main/presentation/provider/main_provider.dart';
import 'package:provider/provider.dart';

class LogsWidget extends StatefulWidget {
  const LogsWidget({super.key, required this.controller});

  final AppLogsController controller;

  @override
  State<LogsWidget> createState() => _LogsWidgetState();
}

class _LogsWidgetState extends State<LogsWidget> {
  var _isOpen = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    getIt<AppLogsController>().addListener(_scrollDown);
    super.initState();
  }

  @override
  void dispose() {
    getIt<AppLogsController>().removeListener(_scrollDown);
    super.dispose();
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider.value(
      value: widget.controller,
      child: Consumer<AppLogsController>(
        builder: (context, controller, _) {
          return AppContainer(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      "Логи",
                      style: theme.textTheme.displaySmall,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        widget.controller.deleteLogs();
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    const SizedBox(height: 16),
                    IconButton(
                      onPressed: () {
                        _isOpen = !_isOpen;
                        setState(() {});
                      },
                      icon: Icon(
                        _isOpen ? Icons.arrow_downward : Icons.arrow_upward,
                        color: theme.textTheme.displaySmall!.color,
                      ),
                    )
                  ],
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: _isOpen ? 220 : 60,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 40),
                    itemCount: widget.controller.logs.length,
                    itemBuilder: (context, i) {
                      return Text(
                        widget.controller.logs[i],
                        style: theme.textTheme.displaySmall,
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
