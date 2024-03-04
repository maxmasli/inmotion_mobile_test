import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';

void main() {
  test('app_icons assets test', () {
    expect(File(AppIcons.arrowUp).existsSync(), isTrue);
    expect(File(AppIcons.error).existsSync(), isTrue);
    expect(File(AppIcons.heart).existsSync(), isTrue);
    expect(File(AppIcons.logo).existsSync(), isTrue);
    expect(File(AppIcons.off).existsSync(), isTrue);
    expect(File(AppIcons.pause).existsSync(), isTrue);
    expect(File(AppIcons.play).existsSync(), isTrue);
    expect(File(AppIcons.ready).existsSync(), isTrue);
    expect(File(AppIcons.rec).existsSync(), isTrue);
    expect(File(AppIcons.stop).existsSync(), isTrue);
  });
}
