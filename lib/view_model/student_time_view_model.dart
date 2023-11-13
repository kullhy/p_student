import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:p_student/models/student_time.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class StudentTimeViewModel extends ChangeNotifier {
  List<StudentTime> studentTimes = [];
  List<StudentTime> studentLate = [];
  List<StudentTime> studentOnTime = [];
  List<StudentTime> notAttendedStudents = [];
  List<StudentTime> forgoCard = [];

  List<StudentTime> filterStudents = [];
  String todayDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  Future<void> processStudentData(String className) async {
    final response = await http.get(
      Uri.parse('https://p-care-e73a4-default-rtdb.firebaseio.com/BYT.json'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = json.decode(response.body);
      if (data != null && data.containsKey(className)) {
        final Map<String, dynamic> idRfidData =
            data[className]['id_rfid'] as Map<String, dynamic>;
        final List<dynamic> idKeyData =
            data[className]['id_key'] as List<dynamic>;
        idRfidData.forEach(
          (key, studentData) {
            if (studentData != null) {
              StudentTime student = StudentTime.fromJson(studentData);
              String studentDateTime = student.getDateTime();
              if (studentDateTime == todayDate) {
                if (DateFormat("HH:mm:ss")
                    .parse(student.time)
                    .isBefore(DateFormat("HH:mm:ss").parse('08:00:00'))) {
                  student.status = "onTime";
                  studentOnTime.add(student);
                } else {
                  student.status = "late";
                  studentLate.add(student);
                }
              } else {
                // Kiểm tra trong id_key
                bool foundInIdKey = false;
                for (final keyData in idKeyData) {
                  if (keyData != null && keyData['STT'] == student.stt) {
                    StudentTime keyStudent = StudentTime.fromJson(keyData);
                    String keyStudentDateTime = keyStudent.getDateTime();
                    if (keyStudentDateTime == todayDate) {
                      if (DateFormat("HH:mm:ss")
                          .parse(keyStudent.time)
                          .isBefore(DateFormat("HH:mm:ss").parse('08:00:00'))) {
                        keyStudent.status = "onTime";
                        student = keyStudent;
                        forgoCard.add(keyStudent);
                        studentOnTime.add(keyStudent);
                      } else {
                        keyStudent.status = "late";
                        student = keyStudent;
                        forgoCard.add(keyStudent);
                        studentLate.add(keyStudent);
                      }
                    } else {
                      student.status = "no";
                    }
                    foundInIdKey = true;
                    break;
                  }
                }

                if (!foundInIdKey) {
                  student.status = "no";
                }
              }
              studentTimes.add(student);
            }
          },
        );
      }
    }
    filterStudents = studentTimes;
    notifyListeners();
  }

  void filter(String filter) {
    if (filter == "all") {
      filterStudents = studentTimes;
    } else if (filter == "late") {
      filterStudents = studentLate;
    } else if (filter == "onTime") {
      filterStudents = studentOnTime;
    } else if (filter == "card") {
      filterStudents = forgoCard;
    }
    notifyListeners();
  }

  Future<void> exportToExcel(String className) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Workbook workbook = Workbook();
    String? path = prefs.getString(className);

    Worksheet sheet;

    String pathSave = "";

    if (path == null) {
      // Lần đầu tiên lưu
      final Directory appDocumentsDir =
          await getApplicationDocumentsDirectory();
      String selectedDirectory =
          await FilePicker.platform.getDirectoryPath() ?? appDocumentsDir.path;
      pathSave = '$selectedDirectory\\$className.xlsx';
      sheet = workbook.worksheets.addWithName(convertDateFormat(todayDate));
    } else {
      File file = File(path);
      if (file.existsSync()) {
        sheet = workbook.worksheets.addWithName(convertDateFormat(todayDate));
        pathSave = path;
      } else {
        // File không tồn tại
        final Directory appDocumentsDir =
            await getApplicationDocumentsDirectory();
        String selectedDirectory =
            await FilePicker.platform.getDirectoryPath() ??
                appDocumentsDir.path;
        pathSave = '$selectedDirectory\\$className.xlsx';
        sheet = workbook.worksheets.addWithName(convertDateFormat(todayDate));
      }
    }
    // Đặt tên cho các cột
    sheet.getRangeByName('A1').setText('STT');
    sheet.getRangeByName('B1').setText('Họ và tên');
    sheet.getRangeByName('C1').setText('Thời gian');
    sheet.getRangeByName('D1').setText('Ngày');
    sheet.getRangeByName('E1').setText('Trạng thái');

    // Đặt giá trị cho từng ô
    for (var i = 0; i < studentTimes.length; i++) {
      sheet
          .getRangeByName('A${i + 2}')
          .setNumber(studentTimes[i].stt.toDouble());
      sheet.getRangeByName('B${i + 2}').setText(studentTimes[i].name);
      sheet.getRangeByName('C${i + 2}').setText(studentTimes[i].time);
      sheet.getRangeByName('D${i + 2}').setText(studentTimes[i].day);
      sheet.getRangeByName('E${i + 2}').setText(
            studentTimes[i].status == "no"
                ? "Chưa đi học"
                : studentTimes[i].status == "onTime"
                    ? "Đúng giờ"
                    : "Đi muộn",
          );
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    if (path == null) {
      final File file = File(pathSave);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(pathSave);
      prefs.setString(className, pathSave);
    } else {
      File file = File(path);
      if (file.existsSync()) {
        File(pathSave).writeAsBytes(bytes);
        OpenFile.open(pathSave);
      } else {
        final File file = File(pathSave);
        await file.writeAsBytes(bytes, flush: true);
        OpenFile.open(pathSave);
        prefs.setString(className, pathSave);
      }
    }
  }

  String convertDateFormat(String inputDate) {
    List<String> dateParts = inputDate.split('/');
    String formattedDate = dateParts.join('_');
    return formattedDate;
  }
}
