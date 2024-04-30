import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';

void main() {
  test('app_icons assets test', () {
    expect(File(AppIcons.add).existsSync(), isTrue);
    expect(File(AppIcons.appIcon).existsSync(), isTrue);
    expect(File(AppIcons.arrowUp).existsSync(), isTrue);
    expect(File(AppIcons.battery100).existsSync(), isTrue);
    expect(File(AppIcons.bluePoint).existsSync(), isTrue);
    expect(File(AppIcons.edit).existsSync(), isTrue);
    expect(File(AppIcons.error).existsSync(), isTrue);
    expect(File(AppIcons.exit).existsSync(), isTrue);
    expect(File(AppIcons.greenPoint).existsSync(), isTrue);
    expect(File(AppIcons.heart).existsSync(), isTrue);
    expect(File(AppIcons.heartSmall).existsSync(), isTrue);
    expect(File(AppIcons.home).existsSync(), isTrue);
    expect(File(AppIcons.logo).existsSync(), isTrue);
    expect(File(AppIcons.mapPoint).existsSync(), isTrue);
    expect(File(AppIcons.off).existsSync(), isTrue);
    expect(File(AppIcons.orangePoint).existsSync(), isTrue);
    expect(File(AppIcons.pause).existsSync(), isTrue);
    expect(File(AppIcons.play).existsSync(), isTrue);
    expect(File(AppIcons.ready).existsSync(), isTrue);
    expect(File(AppIcons.rec).existsSync(), isTrue);
    expect(File(AppIcons.redPoint).existsSync(), isTrue);
    expect(File(AppIcons.report).existsSync(), isTrue);
    expect(File(AppIcons.stop).existsSync(), isTrue);
  });
}
