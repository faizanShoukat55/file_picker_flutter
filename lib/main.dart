import 'package:first_flutter_project/pdf_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

void main() {
   runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'File Picker',
      debugShowCheckedModeBanner: false,
      home: FilePickerScreen(),
    );
  }

}

