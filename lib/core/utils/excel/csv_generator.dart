import 'dart:io';

import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/measure_entity.dart';
import 'package:path_provider/path_provider.dart';

class CsvGenerator {


  Map<String, String> createCsv(TrainEntity train) {

    Map<String, String> result = {};

    for (final player in train.players) {
      result[player.sensor?.device.remoteId.str ?? "No ID"] = [Csv.getHeader(),...
        player.measures.map((e) => e.toCsv())
      ].join("\n");
    }

    result.forEach((name, content) { 
      _localFile(name).then((file) => file.writeAsStringSync(content));
    });

    return result;
  }
}

extension Csv on MeasureEntity {
  static String getHeader() => "time,hr,latitude,longitude,speed,distance,steps,activity";

  String toCsv() {
    return "$time,$hr,$latitude,$longitude,$speed,$distance,$steps,$activity";
  }
}

Future<String> get _localPath async {
  final directory = await getExternalStorageDirectory();
  return directory!.path;
}

Future<File> _localFile(String name) async {
  final path = await _localPath;
  return File('$path/$name.csv');
}