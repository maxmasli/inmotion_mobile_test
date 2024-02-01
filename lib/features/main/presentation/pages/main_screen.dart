import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/features/main/presentation/provider/main_provider.dart';
import 'package:inmotion_mobile_test/features/main/presentation/widgets/main_body.dart';
import 'package:provider/provider.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainModel()..init(),
      child: const Scaffold(
        body: MainBody(),
      ),
    );
  }
}
