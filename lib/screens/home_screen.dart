import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../widgets/student_dialog.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  // ADD / UPDATE DIALOG
  void showStudentDialog(
      BuildContext context, {
        int? index,
        Map? student,
      }) {

    showDialog(
      context: context,
      builder: (context) {

        return StudentDialog(
          index: index,
          student: student,
        );
      },
    );
  }

  // DELETE STUDENT
  void deleteStudent(BuildContext context, int index) {

    Provider.of<StudentProvider>(
      context,
      listen: false,
    ).deleteStudent(index);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Student Manager'),
        centerTitle: true,
      ),

      body: Consumer<StudentProvider>(

        builder: (context, provider, child) {

          final students = provider.students;

          if (students.isEmpty) {
            return const Center(
              child: Text('No students found'),
            );
          }

          return Column(
            children: [

              // TOTAL STUDENTS
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Total Students: ${provider.studentCount}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // STUDENT LIST
              Expanded(
                child: ListView.builder(

                  itemCount: students.length,

                  itemBuilder: (context, index) {

                    final student = students[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      child: ListTile(

                        leading: CircleAvatar(
                          child: Text(
                            student['name'].toString()[0].toUpperCase(),
                          ),
                        ),

                        title: Text(student['name']),

                        subtitle: Text(
                          '${student['email']}\n'
                              '${student['department']}',
                        ),

                        isThreeLine: true,

                        trailing: PopupMenuButton(

                          onSelected: (value) {

                            if (value == 'edit') {

                              showStudentDialog(
                                context,
                                index: index,
                                student: student,
                              );
                            }

                            if (value == 'delete') {

                              deleteStudent(context, index);
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
                ),
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showStudentDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
