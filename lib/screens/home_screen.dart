import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/student_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Access Hive Box
  final Box<Map> studentBox = Hive.box<Map>('students');

  // Add / Update Student Dialog
  void showStudentDialog({int? index}) {

    Map? student;

    // If editing, get existing data
    if (index != null) {
      student = studentBox.getAt(index);
    }

    showDialog(
      context: context,
      builder: (context) {
        return StudentDialog(
          student: student,

          onSave: (data) {

            if (index == null) {

              // CREATE
              studentBox.add(data);

            } else {

              // UPDATE
              studentBox.putAt(index, data);
            }

          },
        );
      },
    );
  }

  // DELETE Student
  void deleteStudent(int index) {
    studentBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Student Manager'),
        centerTitle: true,
      ),

      body: ValueListenableBuilder(
        valueListenable: studentBox.listenable(),

        builder: (context, box, child) {

          if (box.isEmpty) {
            return const Center(
              child: Text('No students found'),
            );
          }

          return ListView.builder(
            itemCount: box.length,

            itemBuilder: (context, index) {

              final student = box.getAt(index)!;

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                child: ListTile(

                  leading: CircleAvatar(
                    child: Text(
                      student['name'].toString().isNotEmpty
                          ? student['name'][0].toUpperCase()
                          : '?',
                    ),
                  ),

                  title: Text(student['name']),

                  subtitle: Text(
                    '${student['email']}\n${student['department']}',
                  ),

                  isThreeLine: true,

                  trailing: PopupMenuButton(
                    onSelected: (value) {

                      if (value == 'edit') {
                        showStudentDialog(index: index);
                      }

                      if (value == 'delete') {
                        deleteStudent(index);
                      }
                    },

                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),

                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => showStudentDialog(),

        child: const Icon(Icons.add),
      ),
    );
  }
}
