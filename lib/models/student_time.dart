
class StudentTime {
  String day = "";
  String name = "";
  int stt = 0;
  String time = "";

  StudentTime({
    required this.day,
    required this.name,
    required this.stt,
    required this.time,
  });

  StudentTime.fromJson(Map<String, dynamic> json) {
    day = json['Day'] ?? "";
    name = json['Name'] ?? "";
    stt = json['STT'] ?? 0;
    time = json['Time'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Day'] = day;
    data['Name'] = name;
    data['STT'] = stt;
    data['Time'] = time;

    return data;
  }

  String getDateTime() {
    return day.split(',')[1].trim();
  }
}
