import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:wrench/features/requests/presentation/screens/camera_screen.dart';

class MainSettingsScreen extends StatefulWidget {
  const MainSettingsScreen({super.key});

  @override
  State<MainSettingsScreen> createState() => _MainSettingsScreenState();
}

class _MainSettingsScreenState extends State<MainSettingsScreen> {
  Future<CameraDescription> _getMainCameraDescription() async {
    final cameras = await availableCameras();
    return cameras.first;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getMainCameraDescription(),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          return CameraScreen(camera: asyncSnapshot.data!);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
