
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class StudentProvider extends ChangeNotifier {

  final Box<Map> studentBox;

  StudentProvider(this.studentBox);

  // GET ALL STUDENTS
  List<Map> get students {
    return studentBox.values.toList();
  }

  // ADD STUDENT
  Future<void> addStudent(Map student) async {
    await studentBox.add(student);
    notifyListeners();
  }

  // UPDATE STUDENT
  Future<void> updateStudent(int index, Map student) async {
    await studentBox.putAt(index, student);
    notifyListeners();
  }

  // DELETE STUDENT
  Future<void> deleteStudent(int index) async {
    await studentBox.deleteAt(index);
    notifyListeners();
  }

  // GET STUDENT COUNT
  int get studentCount => studentBox.length;
}
