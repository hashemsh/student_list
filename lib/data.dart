import 'package:dio/dio.dart';

class StudentData {
  final int id;
  final String firstName;
  final String lastName;
  final String course;
  final int score;
  final String createdAt;
  final String updateAt;

  StudentData(this.id, this.firstName, this.lastName, this.course, this.score,
      this.createdAt, this.updateAt);

  StudentData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        course = json['course'],
        score = json['score'],
        createdAt = json['created_at'],
        updateAt = json['updated_at'];
}

class HttpClient {
  static Dio instance = Dio(
    BaseOptions(
      baseUrl: 'http://expertdevelopers.ir/api/v1/',
    ),
  );
}

Future<List<StudentData>> getStudents() async {
  final responce = await HttpClient.instance.get('experts/student');
  print(responce.data);
  final List<StudentData> students = [];
  if (responce.data is List<dynamic>) {
    (responce.data as List<dynamic>).forEach((element) {
      students.add(StudentData.fromJson(element));
    });
  }
  print(students.toString());
  return students;
}
