import 'package:camera/camera.dart';
import 'package:device_permission/camera_provider.dart';
import 'package:device_permission/main.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, required this.provider});

  final CameraProvider provider;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController cameraController;
  late Future<void> initializeController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cameraController = CameraController(
      cameras.first,
      ResolutionPreset.low,
      enableAudio: false,
    );
    initializeController = cameraController.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.7,
            child: FutureBuilder(
              future: initializeController,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(cameraController);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                      strokeWidth: 2,
                    ),
                  );
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              XFile image;
              if (widget.provider.isCameraAccessGranted) {
                try {
                  await initializeController;
                  image = await cameraController.takePicture();
                  widget.provider.imageCaptureStatus(true);
                  widget.provider.saveImage(image);
                  print(widget.provider.image.name);
                  print(widget.provider.image.path);
                } catch (e) {
                  print("Camera Image Captured Failed - Try Again - ${e}");
                }
              }
            },
            child: const Text("Capture"),
          )
        ],
      ),
    );
  }
}
