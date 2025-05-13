import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:excel/excel.dart';
import 'session_service.dart';


class ReportService {
  final SessionService _sessionService = SessionService();
 

  // Get hours worked in a date range
  Future<Map<DateTime, double>> getHoursWorkedInRange(
    DateTime start,
    DateTime end,
  ) async {
    final sessions = await _sessionService.getSessionsInRange(start, end);
    final Map<DateTime, double> result = {};

    for (final session in sessions) {
      if (session.endTime == null) continue;

      final day = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );

      if (result.containsKey(day)) {
        result[day] = result[day]! + session.durationHours;
      } else {
        result[day] = session.durationHours;
      }
    }

    return result;
  }

  // Get monthly statistics
  Future<Map<String, dynamic>> getMonthlyStats(DateTime month) async {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0);

    final sessions = await _sessionService.getSessionsInRange(
      startOfMonth,
      endOfMonth,
    );

    double totalHours = 0;
    final Set<int> workingDays = {};

    for (final session in sessions) {
      if (session.endTime == null) continue;

      totalHours += session.durationHours;
      workingDays.add(session.startTime.day);
    }

    return {
      'totalHours': totalHours,
      'workingDays': workingDays.length,
    };
  }

  // Export monthly report to Excel
  Future<String> exportMonthlyReport(DateTime month) async {
    final excel = Excel.createExcel();
    final sheet = excel['Time Tracking Report'];

    // Add title and month info
    sheet.merge(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
        CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0));

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
      ..value = TextCellValue(
          'Monthly Report: ${month.year}-${month.month.toString().padLeft(2, '0')}')
      ..cellStyle = CellStyle(
        bold: true,
        fontSize: 16,
        horizontalAlign: HorizontalAlign.Center,
      );

    // Add headers
    final headers = ['Date', 'Hours Worked'];
    for (var i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 2))
        ..value = TextCellValue(headers[i])
        ..cellStyle = CellStyle(
          bold: true,
          backgroundColorHex: ExcelColor.blue100,
        );
    }

    // Add data
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0);

    final hoursWorked = await getHoursWorkedInRange(startOfMonth, endOfMonth);

    var rowIndex = 3;
    double totalHours = 0;

    for (int day = 1; day <= endOfMonth.day; day++) {
      final date = DateTime(month.year, month.month, day);
      final formattedDate =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final hours = hoursWorked[date] ?? 0.0;

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        ..value = TextCellValue(formattedDate);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        ..value = TextCellValue(hours.toStringAsFixed(2));

      totalHours += hours;
      rowIndex++;
    }

    // Add summary
    rowIndex += 1;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
      ..value = TextCellValue('Total')
      ..cellStyle = CellStyle(bold: true);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
      ..value = TextCellValue(totalHours.toStringAsFixed(2))
      ..cellStyle = CellStyle(bold: true);

    // Save file
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'time_tracking_report_${month.year}_${month.month}.xlsx';
    final filePath = '${directory.path}/$fileName';

    final file = File(filePath);
    await file.writeAsBytes(excel.encode()!);

    return filePath;
  }

  // Share monthly report
  Future<void> shareMonthlyReport(DateTime month) async {
    final filePath = await exportMonthlyReport(month);
    final file = XFile(filePath);
    await Share.shareXFiles(
      [file],
      text: 'Time Tracking Report for ${month.year}-${month.month}',
    );
  }
}
