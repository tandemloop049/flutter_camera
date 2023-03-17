import 'dart:io';
import 'package:flutter/material.dart';

class DisplayScreen extends StatelessWidget {
  const DisplayScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("This is the picture"),
          Image.file(
            File(imagePath),
          ),
        ],
      ),
    );
  }
}
