import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraAccessDenied extends StatelessWidget {
  const CameraAccessDenied({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Camera access is required for functioning of this application.",
      ),
      actions: [
        Center(
          child: IconButton(
            onPressed: () async {
              await openAppSettings();
            },
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Icon(Icons.settings),
                // SizedBox(width: 10),
                // Text("Open System Settings"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
