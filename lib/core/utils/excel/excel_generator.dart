import 'dart:io';

import 'package:inmotion_mobile_test/core/utils/stats_calculator.dart';
import 'package:inmotion_mobile_test/core/utils/utils.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelGenerator {
  final workbook = Workbook();

  Future<String> createExcel(TrainEntity train) async {
    final Worksheet sheet = workbook.worksheets[0];

    _setSheetLayout(sheet);
    _setTrainInfo(sheet, train);
    _buildTableTitle(sheet);
    _addPlayers(sheet, train);

    // Save the workbook in file system as XLSX format.
    final format = DateFormat("HHmmss_DDMMyy");
    final List<int> bytes = await workbook.save();
    final directory = await getWorkingDirectory();
    final file = await File(
        '${directory.path}/${format.format(train.startTime)}.xlsx')
        .writeAsBytes(bytes);
    return file.path;
  }

  void _setSheetLayout(Worksheet sheet) {
    sheet.getRangeByName('A1').columnWidth = 4.43;
    sheet.getRangeByName('B1').columnWidth = 17.86;
    sheet.getRangeByName('C1').columnWidth = 17.86;
    sheet.getRangeByName('D1').columnWidth = 12.14;
    sheet.getRangeByName('E1').columnWidth = 12.14;
    sheet.getRangeByName('F1:H1').columnWidth = 14.29;
    sheet.getRangeByName('I1:O1').columnWidth = 12.14;
    sheet.getRangeByName('P1').columnWidth = 13.57;

    sheet.getRangeByIndex(1, 1).rowHeight = 30;
    sheet.getRangeByIndex(2, 1).rowHeight = 23.25;
    sheet.getRangeByIndex(3, 1).rowHeight = 16.5;
    sheet.getRangeByIndex(4, 1).rowHeight = 16.5;
    sheet.getRangeByIndex(5, 1).rowHeight = 16.5;
    sheet.getRangeByIndex(6, 1).rowHeight = 15.75;
    sheet.getRangeByIndex(7, 1).rowHeight = 17.25;
    sheet.getRangeByIndex(8, 1).rowHeight = 37.5;
    sheet.getRangeByIndex(9, 1).rowHeight = 37.5;

    sheet.getRangeByName('A1:P1').merge();
    sheet.getRangeByName('A2:P2').merge();
    sheet.getRangeByName('A3:P3').merge();
    sheet.getRangeByName('A4:P4').merge();
    sheet.getRangeByName('A5:P5').merge();
    sheet.getRangeByName('A6:P6').merge();
    sheet.getRangeByName('A7:P7').merge();

    //Merging table titles
    sheet.getRangeByName('A8:A9').merge();
    sheet.getRangeByName('B8:B9').merge();
    sheet.getRangeByName('C8:C9').merge();
    sheet.getRangeByName('D8:D9').merge();
    sheet.getRangeByName('E8:E9').merge();
    sheet.getRangeByName('F8:G8').merge();
    sheet.getRangeByName('H8:H9').merge();
    sheet.getRangeByName('I8:K8').merge();
    sheet.getRangeByName('L8:N8').merge();
    sheet.getRangeByName('O8:O9').merge();
    sheet.getRangeByName('P8:P9').merge();
  }

  void _setTrainInfo(Worksheet sheet, TrainEntity train) {
    //Train name
    sheet.getRangeByName('A1').setText(train.trainName);
    sheet.getRangeByName('A1').cellStyle.fontSize = 12;
    sheet.getRangeByName('A1').cellStyle.hAlign = HAlignType.left;
    sheet.getRangeByName('A1').cellStyle.vAlign = VAlignType.center;
    sheet.getRangeByName('A1').cellStyle.fontName = 'Arial';
    sheet.getRangeByName('A1').cellStyle.bold = true;

    //Train info
    //sheet.getRangeByName('A2').setText('5 августа. Воскресенье. 12:03-13:45');
    sheet.getRangeByName('A2').setText(
      DateFormat('dd MMMM, EEEE, HH:mm', 'ru').format(train.startTime),
    );
    sheet.getRangeByName('A2').cellStyle.fontSize = 18;
    sheet.getRangeByName('A2').cellStyle.hAlign = HAlignType.left;
    sheet.getRangeByName('A2').cellStyle.vAlign = VAlignType.center;
    sheet.getRangeByName('A2').cellStyle.fontName = 'Arial';
    sheet.getRangeByName('A2').cellStyle.bold = true;
    sheet.getRangeByName('A2').cellStyle.fontColor = '#F59723';

    // //Train description
    // sheet.getRangeByName('A4').setText(train.trainDescription);
    // sheet.getRangeByName('A4').cellStyle.fontSize = 11;
    // sheet.getRangeByName('A4').cellStyle.hAlign = HAlignType.left;
    // sheet.getRangeByName('A4').cellStyle.vAlign = VAlignType.center;
    // sheet.getRangeByName('A4').cellStyle.fontName = 'Arial Narrow';
    // sheet.getRangeByName('A4').cellStyle.bold = false;

    //Train date
    final trainDuration = train.endTime!.difference(train.startTime);
    sheet.getRangeByName('A6').setText(
        'Время тренировки: ${trainDuration.inHours.remainder(24)} час ${trainDuration.inMinutes.remainder(60)} мин ${trainDuration.inSeconds.remainder(60)} сек');
    sheet.getRangeByName('A6').cellStyle.fontSize = 12;
    sheet.getRangeByName('A6').cellStyle.hAlign = HAlignType.left;
    sheet.getRangeByName('A6').cellStyle.vAlign = VAlignType.center;
    sheet.getRangeByName('A6').cellStyle.fontName = 'Arial';
    sheet.getRangeByName('A6').cellStyle.bold = true;
  }

  void _buildTableTitle(
      Worksheet sheet,
      ) {
    //Styling table titles
    sheet.getRangeByName('A8:P9').cellStyle.backColor = '#FED292';

    var range = sheet.getRangeByName('A8:A9');

    range.cellStyle.borders.top.color = '#F59723';
    range.cellStyle.borders.top.lineStyle = LineStyle.medium;
    range.cellStyle.borders.bottom.color = '#F59723';
    range.cellStyle.borders.bottom.lineStyle = LineStyle.medium;
    range.cellStyle.borders.right.color = '#F59723';
    range.cellStyle.borders.right.lineStyle = LineStyle.thin;
    range.cellStyle.borders.left.color = '#F59723';
    range.cellStyle.borders.left.lineStyle = LineStyle.thin;

    range = sheet.getRangeByName('B8:B9');
    range.cellStyle.borders.top.color = '#F59723';
    range.cellStyle.borders.top.lineStyle = LineStyle.medium;
    range.cellStyle.borders.bottom.color = '#F59723';
    range.cellStyle.borders.bottom.lineStyle = LineStyle.medium;
    range.cellStyle.borders.right.color = '#F59723';
    range.cellStyle.borders.right.lineStyle = LineStyle.thin;
    range.cellStyle.borders.left.color = '#F59723';
    range.cellStyle.borders.left.lineStyle = LineStyle.thin;

    range = sheet.getRangeByName('C8:C9');
    range.cellStyle.borders.top.color = '#F59723';
    range.cellStyle.borders.top.lineStyle = LineStyle.medium;
    range.cellStyle.borders.bottom.color = '#F59723';
    range.cellStyle.borders.bottom.lineStyle = LineStyle.medium;
    range.cellStyle.borders.right.color = '#F59723';
    range.cellStyle.borders.right.lineStyle = LineStyle.thin;
    range.cellStyle.borders.left.color = '#F59723';
    range.cellStyle.borders.left.lineStyle = LineStyle.thin;

    range = sheet.getRangeByName('D8:D9');
    range.cellStyle.borders.top.color = '#F59723';
    range.cellStyle.borders.top.lineStyle = LineStyle.medium;
    range.cellStyle.borders.bottom.color = '#F59723';
    range.cellStyle.borders.bottom.lineStyle = LineStyle.medium;
    range.cellStyle.borders.right.color = '#F59723';
    range.cellStyle.borders.right.lineStyle = LineStyle.thin;
    range.cellStyle.borders.left.color = '#F59723';
    range.cellStyle.borders.left.lineStyle = LineStyle.thin;

    range = sheet.getRangeByName('E8:E9');
    range.cellStyle.borders.top.color = '#F59723';
    range.cellStyle.borders.top.lineStyle = LineStyle.medium;
    range.cellStyle.borders.bottom.color = '#F59723';
    range.cellStyle.borders.bottom.lineStyle = LineStyle.medium;
    range.cellStyle.borders.right.color = '#F59723';
    range.cellStyle.borders.right.lineStyle = LineStyle.thin;
    range.cellStyle.borders.left.color = '#F59723';
    range.cellStyle.borders.left.lineStyle = LineStyle.thin;

    range = sheet.getRangeByName('F8:G8');
    range.cellStyle.borders.top.color = '#F59723';
    range.cellStyle.borders.top.lineStyle = LineStyle.medium;
    range.cellStyle.borders.bottom.color = '#F59723';
    range.cellStyle.borders.bottom.lineStyle = LineStyle.thin;
    range.cellStyle.borders.right.color = '#F59723';
    range.cellStyle.borders.right.lineStyle = LineStyle.thin;
    range.cellStyle.borders.left.color = '#F59723';
    range.cellStyle.borders.left.lineStyle = LineStyle.thin;

    range = sheet.getRangeByName('F9');
    range.cellStyle.borders.top.color = '#F59723';
    range.cellStyle.borders.top.lineStyle = LineStyle.thin;
    range.cellStyle.borders.bottom.color = '#F59723';
    range.cellStyle.borders.bottom.lineStyle = LineStyle.medium;
    range.cellStyle.borders.right.color = '#F59723';
    range.cellStyle.borders.right.lineStyle = LineStyle.thin;
    range.cellStyle.borders.left.color = '#F59723';
    range.cellStyle.borders.left.lineStyle = LineStyle.thin;

    range = sheet.getRangeByName('G9');
    range.cellStyle.borders.top.color = '#F59723';
    range.cellStyle.borders.top.lineStyle = LineStyle.thin;
    range.cellStyle.borders.bottom.color = '#F59723';
    range.cellStyle.borders.bottom.lineStyle = LineStyle.medium;
    range.cellStyle.borders.right.color = '#F59723';
    range.cellStyle.borders.right.lineStyle = LineStyle.thin;
    range.cellStyle.borders.left.color = '#F59723';
    range.cellStyle.borders.left.lineStyle = LineStyle.thin;

    range = sheet.getRangeByName('H8:H9');
    range.cellStyle.borders.top.color = '#F59723';
    range.cellStyle.borders.top.lineStyle = LineStyle.medium;
    range.cellStyle.borders.bottom.color = '#F59723';
    range.cellStyle.borders.bottom.lineStyle = LineStyle.medium;
    range.cellStyle.borders.right.color = '#F59723';
    range.cellStyle.borders.right.lineStyle = LineStyle.thin;
    range.cellStyle.borders.left.color = '#F59723';
    range.cellStyle.borders.left.lineStyle = LineStyle.thin;

    range = sheet.getRangeByName('I8:K8');
    range.cellStyle.borders.top.color = '#F59723';
    range.cellStyle.borders.top.lineStyle = LineStyle.medium;
    range.cellStyle.borders.bottom.color = '#F59723';
    range.cellStyle.borders.bottom.lineStyle = LineStyle.thin;
    range.cellStyle.borders.right.color = '#F59723';
    range.cellStyle.borders.right.lineStyle = LineStyle.thin;
    range.cellStyle.borders.left.color = '#F59723';
    range.cellStyle.borders.left.lineStyle = LineStyle.thin;

    range = sheet.getRangeByName('I9');
    range.cellStyle.borders.top.color = '#F59723';
    range.cellStyle.borders.top.lineStyle = LineStyle.thin;
    range.cellStyle.borders.bottom.color = '#F59723';
    range.cellStyle.borders.bottom.lineStyle = LineStyle.medium;
    range.cellStyle.borders.right.color = '#F59723';
    range.cellStyle.borders.right.lineStyle = LineStyle.thin;
    range.cellStyle.borders.left.color = '#F59723';
    range.cellStyle.borders.left.lineStyle = LineStyle.thin;

    range = sheet.getRangeByName('J9');
    range.cellStyle.borders.top.color = '#F59723';
    range.cellStyle.borders.top.lineStyle = LineStyle.thin;
    range.cellStyle.borders.bottom.color = '#F59723';
    range.cellStyle.borders.bottom.lineStyle = LineStyle.medium;
    range.cellStyle.borders.right.color = '#F59723';
    range.cellStyle.borders.right.lineStyle = LineStyle.thin;
    range.cellStyle.borders.left.color = '#F59723';
    range.cellStyle.borders.left.lineStyle = LineStyle.thin;

    range = sheet.getRangeByName('K9');
    range.cellStyle.borders.top.color = '#F59723';
    range.cellStyle.borders.top.lineStyle = LineStyle.thin;
    range.cellStyle.borders.bottom.color = '#F59723';
    range.cellStyle.borders.bottom.lineStyle = LineStyle.medium;
    range.cellStyle.borders.right.color = '#F59723';
    range.cellStyle.borders.right.lineStyle = LineStyle.thin;
    range.cellStyle.borders.left.color = '#F59723';
    range.cellStyle.borders.left.lineStyle = LineStyle.thin;

    ///////
    range = sheet.getRangeByName('L8:N8');
    range.cellStyle.borders.top.color = '#F59723';
    range.cellStyle.borders.top.lineStyle = LineStyle.medium;
    range.cellStyle.borders.bottom.color = '#F59723';
    range.cellStyle.borders.bottom.lineStyle = LineStyle.thin;
    range.cellStyle.borders.right.color = '#F59723';
    range.cellStyle.borders.right.lineStyle = LineStyle.thin;
    range.cellStyle.borders.left.color = '#F59723';
    range.cellStyle.borders.left.lineStyle = LineStyle.thin;

    range = sheet.getRangeByName('L9');
    range.cellStyle.borders.top.color = '#F59723';
    range.cellStyle.borders.top.lineStyle = LineStyle.thin;
    range.cellStyle.borders.bottom.color = '#F59723';
    range.cellStyle.borders.bottom.lineStyle = LineStyle.medium;
    range.cellStyle.borders.right.color = '#F59723';
    range.cellStyle.borders.right.lineStyle = LineStyle.thin;
    range.cellStyle.borders.left.color = '#F59723';
    range.cellStyle.borders.left.lineStyle = LineStyle.thin;

    range = sheet.getRangeByName('M9');
    range.cellStyle.borders.top.color = '#F59723';
    range.cellStyle.borders.top.lineStyle = LineStyle.thin;
    range.cellStyle.borders.bottom.color = '#F59723';
    range.cellStyle.borders.bottom.lineStyle = LineStyle.medium;
    range.cellStyle.borders.right.color = '#F59723';
    range.cellStyle.borders.right.lineStyle = LineStyle.thin;
    range.cellStyle.borders.left.color = '#F59723';
    range.cellStyle.borders.left.lineStyle = LineStyle.thin;

    range = sheet.getRangeByName('N9');
    range.cellStyle.borders.top.color = '#F59723';
    range.cellStyle.borders.top.lineStyle = LineStyle.thin;
    range.cellStyle.borders.bottom.color = '#F59723';
    range.cellStyle.borders.bottom.lineStyle = LineStyle.medium;
    range.cellStyle.borders.right.color = '#F59723';
    range.cellStyle.borders.right.lineStyle = LineStyle.thin;
    range.cellStyle.borders.left.color = '#F59723';
    range.cellStyle.borders.left.lineStyle = LineStyle.thin;

    range = sheet.getRangeByName('O8:O9');
    range.cellStyle.borders.top.color = '#F59723';
    range.cellStyle.borders.top.lineStyle = LineStyle.medium;
    range.cellStyle.borders.bottom.color = '#F59723';
    range.cellStyle.borders.bottom.lineStyle = LineStyle.medium;
    range.cellStyle.borders.right.color = '#F59723';
    range.cellStyle.borders.right.lineStyle = LineStyle.thin;
    range.cellStyle.borders.left.color = '#F59723';
    range.cellStyle.borders.left.lineStyle = LineStyle.thin;

    range = sheet.getRangeByName('P8:P9');
    range.cellStyle.borders.top.color = '#F59723';
    range.cellStyle.borders.top.lineStyle = LineStyle.medium;
    range.cellStyle.borders.bottom.color = '#F59723';
    range.cellStyle.borders.bottom.lineStyle = LineStyle.medium;
    range.cellStyle.borders.right.color = '#F59723';
    range.cellStyle.borders.right.lineStyle = LineStyle.medium;
    range.cellStyle.borders.left.color = '#F59723';
    range.cellStyle.borders.left.lineStyle = LineStyle.thin;

    range = sheet.getRangeByName('A8');
    range.setText('№');
    range.cellStyle.wrapText = true;
    range.cellStyle.fontSize = 11;
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.fontName = 'Arial Narrow';

    range = sheet.getRangeByName('B8');
    range.setText('Игрок');
    range.cellStyle.wrapText = true;
    range.cellStyle.fontSize = 11;
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.fontName = 'Arial Narrow';

    range = sheet.getRangeByName('C8');
    range.setText('Фрагмент тренировки');
    range.cellStyle.wrapText = true;
    range.cellStyle.fontSize = 11;
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.fontName = 'Arial Narrow';

    range = sheet.getRangeByName('D8');
    range.setText('Время');
    range.cellStyle.wrapText = true;
    range.cellStyle.fontSize = 11;
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.fontName = 'Arial Narrow';

    range = sheet.getRangeByName('E8');
    range.setText('Предельный пульс (Статистика)');
    range.cellStyle.wrapText = true;
    range.cellStyle.fontSize = 11;
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.fontName = 'Arial Narrow';

    range = sheet.getRangeByName('F8');
    range.setText('ЧСС во время тренировки');
    range.cellStyle.wrapText = true;
    range.cellStyle.fontSize = 11;
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.fontName = 'Arial Narrow';

    range = sheet.getRangeByName('F9');
    range.setText('Максимальный пульс');
    range.cellStyle.wrapText = true;
    range.cellStyle.fontSize = 11;
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.fontName = 'Arial Narrow';

    range = sheet.getRangeByName('G9');
    range.setText('Средний пульс');
    range.cellStyle.wrapText = true;
    range.cellStyle.fontSize = 11;
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.fontName = 'Arial Narrow';

    range = sheet.getRangeByName('H8');
    range.setText('Интенсивность (%ЧССпредл)');
    range.cellStyle.wrapText = true;
    range.cellStyle.fontSize = 11;
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.fontName = 'Arial Narrow';

    range = sheet.getRangeByName('I8');
    range.setText('Зоны ЧСС');
    range.cellStyle.wrapText = true;
    range.cellStyle.fontSize = 11;
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.fontName = 'Arial Narrow';

    range = sheet.getRangeByName('I9');
    range.setText('70-80%');
    range.cellStyle.wrapText = true;
    range.cellStyle.fontSize = 11;
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.fontName = 'Arial Narrow';

    range = sheet.getRangeByName('J9');
    range.setText('80-90%');
    range.cellStyle.wrapText = true;
    range.cellStyle.fontSize = 11;
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.fontName = 'Arial Narrow';

    range = sheet.getRangeByName('K9');
    range.setText('90-100%');
    range.cellStyle.wrapText = true;
    range.cellStyle.fontSize = 11;
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.fontName = 'Arial Narrow';

    range = sheet.getRangeByName('L8');
    range.setText('Калории');
    range.cellStyle.wrapText = true;
    range.cellStyle.fontSize = 11;
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.fontName = 'Arial Narrow';

    range = sheet.getRangeByName('L9');
    range.setText('Всего');
    range.cellStyle.wrapText = true;
    range.cellStyle.fontSize = 11;
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.fontName = 'Arial Narrow';

    range = sheet.getRangeByName('M9');
    range.setText('Жиры');
    range.cellStyle.wrapText = true;
    range.cellStyle.fontSize = 11;
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.fontName = 'Arial Narrow';

    range = sheet.getRangeByName('N9');
    range.setText('Углеводы');
    range.cellStyle.wrapText = true;
    range.cellStyle.fontSize = 11;
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.fontName = 'Arial Narrow';

    range = sheet.getRangeByName('O8');
    range.setText('Оценка нагрузки (х/5)');
    range.cellStyle.wrapText = true;
    range.cellStyle.fontSize = 11;
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.fontName = 'Arial Narrow';

    range = sheet.getRangeByName('P8');
    range.setText('Тренировочная нагрузка (TRIMP)');
    range.cellStyle.wrapText = true;
    range.cellStyle.fontSize = 11;
    range.cellStyle.vAlign = VAlignType.center;
    range.cellStyle.hAlign = HAlignType.center;
    range.cellStyle.fontName = 'Arial Narrow';
  }

  void _addPlayers(Worksheet sheet, TrainEntity train) {
    // Для одного фрагмента

    const startIndex = 10;
    final playersCount = train.players.length;
    final defaultCellStyle = workbook.styles.add('cell');
    defaultCellStyle.fontSize = 11;
    defaultCellStyle.fontName = 'Arial Narrow';
    defaultCellStyle.hAlign = HAlignType.center;
    defaultCellStyle.vAlign = VAlignType.center;
    defaultCellStyle.borders.top.color = '#F59723';
    defaultCellStyle.borders.top.lineStyle = LineStyle.thin;
    defaultCellStyle.borders.bottom.color = '#F59723';
    defaultCellStyle.borders.bottom.lineStyle = LineStyle.thin;
    defaultCellStyle.borders.left.color = '#F59723';
    defaultCellStyle.borders.left.lineStyle = LineStyle.thin;
    defaultCellStyle.borders.right.color = '#F59723';
    defaultCellStyle.borders.right.lineStyle = LineStyle.thin;
    workbook.styles.addStyle(defaultCellStyle as CellStyle);

    for (int i = startIndex, pi = 0; pi < playersCount; i++, pi++) {
      final player = train.players[pi];
      // Номер
      var range = sheet.getRangeByIndex(i, 1);
      range.setNumber(player.number.toDouble());
      range.cellStyle = defaultCellStyle;

      // Имя игрока
      range = sheet.getRangeByIndex(i, 2);
      range.setText(player.name);
      range.cellStyle = defaultCellStyle;
      range.cellStyle.hAlign = HAlignType.left;

      // Время
      final trainDuration = train.endTime!.difference(train.startTime);
      range = sheet.getRangeByIndex(i, 4);
      range.cellStyle = defaultCellStyle;
      range.setText(
          '${trainDuration.inHours.remainder(60).toString().padLeft(2, '0')}:${trainDuration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${trainDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}');

      // Предельный пульс
      range = sheet.getRangeByIndex(i, 5);
      range.setNumber(StatsCalculator.calculatedPulseAtMaximum(player));
      range.cellStyle = defaultCellStyle;

      // Максимальный пульс
      range = sheet.getRangeByIndex(i, 6);
      range.setNumber(StatsCalculator.calculateMaxPulse(player).toDouble());
      range.cellStyle = defaultCellStyle;

      // Средний пульс
      range = sheet.getRangeByIndex(i, 7);
      range.setNumber(StatsCalculator.calculateAvgPulse(player).toDouble());
      range.cellStyle = defaultCellStyle;

      // Интенсивность
      range = sheet.getRangeByIndex(i, 8);
      range.cellStyle = defaultCellStyle;
      range.setNumber(StatsCalculator.calculatedIntensity(player) / 100.0);
      range.numberFormat = '0%';

      final hrStats = StatsCalculator.getHrStats(player.hrMeasures);
      range = sheet.getRangeByIndex(i, 9);
      range.cellStyle = defaultCellStyle;
      range.setNumber(hrStats[0]);
      range.numberFormat = '0%';

      range = sheet.getRangeByIndex(i, 10);
      range.cellStyle = defaultCellStyle;
      range.setNumber(hrStats[1]);
      range.numberFormat = '0%';

      range = sheet.getRangeByIndex(i, 11);
      range.cellStyle = defaultCellStyle;
      range.setNumber(hrStats[2]);
      range.numberFormat = '0%';

      // Всего
      range = sheet.getRangeByIndex(i, 12);
      range.setNumber(StatsCalculator.getCalories(player).toDouble());
      range.cellStyle = defaultCellStyle;

      // Жиры
      range = sheet.getRangeByIndex(i, 13);
      range.setNumber(StatsCalculator.getFats(player).toDouble());
      range.cellStyle = defaultCellStyle;

      // Углеводы
      range = sheet.getRangeByIndex(i, 14);
      range.setNumber(StatsCalculator.getProteins(player).toDouble());
      range.cellStyle = defaultCellStyle;

      // Оценка нагрузки
      range = sheet.getRangeByIndex(i, 15);
      range.setNumber(0); // rating player.rating.toDouble()
      range.cellStyle = defaultCellStyle;

      // Trimp
      range = sheet.getRangeByIndex(i, 16);
      range.setNumber(StatsCalculator.getTrimp(player).toDouble());
      range.cellStyle = defaultCellStyle;
      range.cellStyle.borders.right.lineStyle = LineStyle.medium;
    }

    final offset = startIndex + playersCount - 1;

    // Фрагмент тренировки
    sheet.getRangeByName('C$startIndex:C$offset').merge();
    sheet.getRangeByName('C$startIndex:C$offset').setText('Вся тренировка');
    sheet.getRangeByName('C$startIndex:C$offset').cellStyle = defaultCellStyle;

    // Трехцветная шкала интенсивности
    var conditionalFormats =
        sheet.getRangeByName('H$startIndex:H$offset').conditionalFormats;
    var condition = conditionalFormats.addCondition();
    condition.formatType = ExcelCFType.colorScale;
    var colorScale = condition.colorScale!;
    colorScale.setConditionCount(3);

    colorScale.criteria[0].formatColor = '#F38A0B';
    colorScale.criteria[0].type = ConditionValueType.lowestValue;
    colorScale.criteria[0].value = '0';

    colorScale.criteria[1].formatColor = '#FFFFFF';
    colorScale.criteria[1].type = ConditionValueType.percentile;
    colorScale.criteria[1].value = '50';

    colorScale.criteria[2].formatColor = '#85BD5F';
    colorScale.criteria[2].type = ConditionValueType.highestValue;
    colorScale.criteria[2].value = '0';

    // Трехцветная шкала 90 100
    conditionalFormats =
        sheet.getRangeByName('K$startIndex:K$offset').conditionalFormats;
    condition = conditionalFormats.addCondition();
    condition.formatType = ExcelCFType.colorScale;
    colorScale = condition.colorScale!;
    colorScale.setConditionCount(3);

    colorScale.criteria[0].formatColor = '#F38A0B';
    colorScale.criteria[0].type = ConditionValueType.lowestValue;
    colorScale.criteria[0].value = '0';

    colorScale.criteria[1].formatColor = '#FFFFFF';
    colorScale.criteria[1].type = ConditionValueType.percentile;
    colorScale.criteria[1].value = '50';

    colorScale.criteria[2].formatColor = '#85BD5F';
    colorScale.criteria[2].type = ConditionValueType.highestValue;
    colorScale.criteria[2].value = '0';

    // Трехцветная шкала Trimp
    conditionalFormats =
        sheet.getRangeByName('P$startIndex:P$offset').conditionalFormats;
    condition = conditionalFormats.addCondition();
    condition.formatType = ExcelCFType.colorScale;
    colorScale = condition.colorScale!;
    colorScale.setConditionCount(3);

    colorScale.criteria[0].formatColor = '#F38A0B';
    colorScale.criteria[0].type = ConditionValueType.lowestValue;
    colorScale.criteria[0].value = '0';

    colorScale.criteria[1].formatColor = '#FFFFFF';
    colorScale.criteria[1].type = ConditionValueType.percentile;
    colorScale.criteria[1].value = '50';

    colorScale.criteria[2].formatColor = '#85BD5F';
    colorScale.criteria[2].type = ConditionValueType.highestValue;
    colorScale.criteria[2].value = '0';

    // Закрашиваем низ таблицы
    for (int i = 1; i < 17; i++) {
      sheet.getRangeByIndex(offset, i).cellStyle.borders.bottom.lineStyle =
          LineStyle.medium;
    }
  }
}