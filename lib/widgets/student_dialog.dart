
import 'package:flutter/material.dart';

class StudentDialog extends StatefulWidget {

  final Map? student;
  final Function(Map) onSave;

  const StudentDialog({
    super.key,
    this.student,
    required this.onSave,
  });

  @override
  State<StudentDialog> createState() => _StudentDialogState();
}

class _StudentDialogState extends State<StudentDialog> {

  // Text Editing Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final departmentController = TextEditingController();

  // Load existing data when editing
  @override
  void initState() {
    super.initState();

    if (widget.student != null) {
      nameController.text = widget.student!['name'];
      emailController.text = widget.student!['email'];
      departmentController.text = widget.student!['department'];
    }
  }

  // Dispose controllers
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    departmentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      title: Text(
        widget.student == null
            ? 'Add Student'
            : 'Update Student',
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Student Name',
            ),
          ),

          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),

          TextField(
            controller: departmentController,
            decoration: const InputDecoration(
              labelText: 'Department',
            ),
          ),
        ],
      ),

      actions: [

        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed: () {

            // Collect student information
            final studentData = {
              'name': nameController.text.trim(),
              'email': emailController.text.trim(),
              'department': departmentController.text.trim(),
            };

            // Send data to HomeScreen
            widget.onSave(studentData);

            Navigator.pop(context);
          },

          child: Text(
            widget.student == null ? 'Save' : 'Update',
          ),
        ),
      ],
    );
  }
}
