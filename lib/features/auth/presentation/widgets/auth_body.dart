import 'package:flutter/material.dart';

class AuthBody extends StatelessWidget {
  const AuthBody({super.key, required this.onResult});

  final Function(bool) onResult;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        child: const Text("Auth"),
        onPressed: () {
          onResult(true);
        },
      ),
    );
  }
}
