import 'package:camera/camera.dart';
import 'package:device_permission/camera_acces_denied.dart';
import 'package:device_permission/camera_provider.dart';
import 'package:device_permission/camera_screen.dart';
import 'package:device_permission/display_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

late List<CameraDescription> cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(
    ChangeNotifierProvider(
      create: (context) => CameraProvider(),
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Consumer<CameraProvider>(
        builder: (context, provider, child) => MyHomePage(provider: provider),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.provider});

  final CameraProvider provider;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  late PermissionStatus cameraPermissionStatus;
  late CameraController cameraController;
  late Future<void> initializeController;

  Future<Widget> checkCameraPermissionStatus() async {
    if (await Permission.camera.status.isGranted) {
      // widget.provider.cameraAccessStatus(true);
      return CameraScreen(provider: widget.provider);
    } else {
      await Permission.camera.request();
      if (await Permission.camera.status.isGranted) {
        // widget.provider.cameraAccessStatus(true);
        return CameraScreen(provider: widget.provider);
      } else {
        await Permission.camera.request();
        if (await Permission.camera.status.isGranted) {
          // widget.provider.cameraAccessStatus(true);
          return CameraScreen(
            provider: widget.provider,
          );
        } else {
          return const CameraAccessDenied();
        }
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      checkCameraPermissionStatus();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Device Permissions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Take a Photo"),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.height / 1.1,
              child: FutureBuilder<Widget>(
                future: checkCameraPermissionStatus(),
                builder: (context, snapshot) {
                  try {
                    if (widget.provider.isImageCaptured) {
                      return DisplayScreen(
                          imagePath: widget.provider.image.path);
                    } else if (snapshot.hasData) {
                      return snapshot.data!;
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error} ------- Error -------");
                    }
                  } catch (e) {
                    print("Failed to Load the camera");
                  }
                  return Container(
                    color: Colors.grey,
                    child: const Icon(Icons.camera_alt_rounded),
                  );
                },
              ),
            ),
            // ElevatedButton(
          ],
        ),
      ),
    );
  }
}
