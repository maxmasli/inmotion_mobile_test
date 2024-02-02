import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';

void main() {
  test('app_icons assets test', () {
    expect(File(AppIcons.logo).existsSync(), isTrue);
  });
}
