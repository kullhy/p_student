
class StudentInfo{
  String name = "";
  String nameClass = "";
  String school = "";
  int studentNumber = 0;
  String? uid;

  StudentInfo({
    required this.name,
    required this.school,
    required this.nameClass,
    required this.studentNumber,
    this.uid 
  });

 factory StudentInfo.fromMap(Map<String, dynamic> map) {
  return StudentInfo(
    name: map['name']['stringValue'] ?? '',
    school: map['school']['stringValue'] ?? '',
    nameClass: map['nameClass']['stringValue'] ?? '',
    studentNumber: int.parse(map['studentNumber']['integerValue']),
  );
}
}

