
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/student_provider.dart';

class StudentDialog extends StatefulWidget {

  final Map? student;
  final int? index;

  const StudentDialog({
    super.key,
    this.student,
    this.index,
  });

  @override
  State<StudentDialog> createState() => _StudentDialogState();
}

class _StudentDialogState extends State<StudentDialog> {

  // Form Key
  final formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final departmentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Load existing data for editing
    if (widget.student != null) {

      nameController.text = widget.student!['name'];
      emailController.text = widget.student!['email'];
      departmentController.text =
      widget.student!['department'];
    }
  }

  // SAVE STUDENT
  Future<void> saveStudent() async {

    // Check validation
    if (formKey.currentState!.validate()) {

      final studentData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'department': departmentController.text.trim(),
      };

      final provider = Provider.of<StudentProvider>(
        context,
        listen: false,
      );

      if (widget.index == null) {

        // CREATE
        await provider.addStudent(studentData);

      } else {

        // UPDATE
        await provider.updateStudent(
          widget.index!,
          studentData,
        );
      }

      if (!mounted) return;

      Navigator.pop(context);
    }
  }

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

      content: Form(
        key: formKey,

        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // NAME
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Student Name',
                  prefixIcon: Icon(Icons.person),
                ),

                validator: (value) {

                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter student name';
                  }

                  if (value.trim().length < 3) {
                    return 'Name must be at least 3 characters';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 12),

              // EMAIL
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),

                validator: (value) {

                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter email';
                  }

                  final emailPattern =
                  RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                  if (!emailPattern.hasMatch(value.trim())) {
                    return 'Enter a valid email address';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 12),

              // DEPARTMENT
              TextFormField(
                controller: departmentController,
                decoration: const InputDecoration(
                  labelText: 'Department',
                  prefixIcon: Icon(Icons.school),
                ),

                validator: (value) {

                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter department';
                  }

                  return null;
                },
              ),

            ],
          ),
        ),
      ),

      actions: [

        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed: saveStudent,
          child: Text(
            widget.student == null ? 'Save' : 'Update',
          ),
        ),

      ],
    );
  }
}
