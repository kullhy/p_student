import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:p_student/models/student_time.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeVM extends ChangeNotifier {
  bool isLoading = false;
  List<Map<String, List<StudentTime>>> schools = [];
  String todayDate = DateFormat('dd/MM/yyyy').format(DateTime.now());


  Future<void> getAllClass() async {
    isLoading = true;
    // notifyListeners();
    final response = await http.get(
      Uri.parse('https://p-care-e73a4-default-rtdb.firebaseio.com/BYT.json'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = json.decode(response.body);
      if (data != null) {
        data.forEach(
          (key, value) {
            final classData = value as Map<String, dynamic>;
            final studentsData = classData['students'] as Map<String, dynamic>;
            final studentLate = studentsData.entries
                .map((entry) => StudentTime.fromJson(entry.value))
                .where((student) =>
                    DateFormat('dd/MM/yyyy')
                        .format(DateTime.parse(student.day)) ==
                    todayDate)
                .toList();
            log(studentLate.length.toString());
            isLoading = false;
            notifyListeners();
            if(studentLate.isNotEmpty){
              schools.add({key:studentLate},);
            }
          },
        );
        log(schools.toString());
      }
    }
  }

  Future<void> openGGSheet() async {
  if (!await launchUrl(Uri.parse("https://docs.google.com/spreadsheets/d/1EQ3I9pc8zkdtKRBMEddajqEt9E0rd2N4eH5YzTOAbOo/edit#gid=0"))) {
    throw Exception('Could not launch ');
  }
}

  Future<void> exportExcel() async {
   final SharedPreferences prefs =
        await SharedPreferences.getInstance(); // Tạo một đối tượng Excel
    Excel excel = Excel.createExcel();
    String? path = prefs.getString("schools");
    Sheet sheet;

    String pathSave = "";

    if (path == null) {
      // Lần đầu tiên lưu
      final Directory appDocumentsDir =
          await getApplicationDocumentsDirectory();
      String selectedDirectory =
          await FilePicker.platform.getDirectoryPath() ?? appDocumentsDir.path;
      pathSave = '$selectedDirectory\\byt.xlsx';
      // Tạo một sheet mới với tên ngày tháng hiện tại
      sheet = excel[convertDateFormat(todayDate)];
    } else {
      File file = File(path);
      if (file.existsSync()) {
        // Đọc file excel đã có
        var bytes = file.readAsBytesSync();
         excel = Excel.decodeBytes(bytes);
        // Tạo một sheet mới với tên ngày tháng hiện tại
        sheet = excel[convertDateFormat(todayDate)];
        pathSave = path;
      } else {
        // File không tồn tại
        final Directory appDocumentsDir =
            await getApplicationDocumentsDirectory();
        String selectedDirectory =
            await FilePicker.platform.getDirectoryPath() ??
                appDocumentsDir.path;
        pathSave = '$selectedDirectory\\school.xlsx';
        // Tạo một sheet mới với tên ngày tháng hiện tại
        sheet = excel[convertDateFormat(todayDate)];
      }
    }
// Đặt tên cho các cột
    sheet.cell(CellIndex.indexByString('A1')).value = 'STT';
    sheet.cell(CellIndex.indexByString('B1')).value = 'Họ và tên';
    sheet.cell(CellIndex.indexByString('C1')).value = 'Thời gian';
    sheet.cell(CellIndex.indexByString('D1')).value = 'Ngày';
    sheet.cell(CellIndex.indexByString('E1')).value = 'Lớp';
int x =0;
// Đặt giá trị cho từng ô
  for (var classname in schools) {
    
    for (var i = 0; i < classname.values.first.length; i++) {
      StudentTime student = classname.values.first[i];
      x = x+1;
      sheet.cell(CellIndex.indexByString('A${x + 2}')).value =
          student.stt.toDouble();
      sheet.cell(CellIndex.indexByString('B${x + 2}')).value =
          student.name;
      sheet.cell(CellIndex.indexByString('C${x + 2}')).value =
          student.time;
      sheet.cell(CellIndex.indexByString('D${x + 2}')).value =
          student.day;
      sheet.cell(CellIndex.indexByString('E${x + 2}')).value = classname.keys.first;
    }
   }

// Lưu và mở file excel
    final File file = File(pathSave);
    await file.writeAsBytes(excel.encode()!, flush: true);
    OpenFile.open(pathSave);
    prefs.setString("schools", pathSave);
  }

  String convertDateFormat(String inputDate) {
    List<String> dateParts = inputDate.split('/');
    String formattedDate = dateParts.join('_');
    return formattedDate;
  }
}
