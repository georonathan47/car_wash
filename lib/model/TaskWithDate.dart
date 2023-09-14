
import 'package:carwash/model/Task.dart';

class TaskWithDate {
  String? date;
  List<Task>? tasks;

  TaskWithDate({this.date, this.tasks});

  TaskWithDate.fromJson(Map<String, dynamic> json) {
    date = json['date'] as String;
    tasks = json['tasks'] as List<Task>;
  }

}
