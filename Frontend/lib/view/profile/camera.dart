import 'dart:async';
import 'dart:io';
import 'package:main/client/UserClient.dart';
import 'package:main/entity/user.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:main/view/profile/edit.dart';

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  Future<void>? _initializeCameraFuture;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    intializeCamera();
  }

  Future<void> intializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeCameraFuture = _cameraController.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initializeCameraFuture == null || _cameraController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Take a picture'),
        backgroundColor: Color.fromARGB(255, 33, 61, 41),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<void>(
        future: _initializeCameraFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeCameraFuture;

            final image = await _cameraController.takePicture();

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return DisplayPictureScreen(
                    imagePath: image.path,
                  );
                },
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  Future<void> _updateUserFoto(BuildContext context) async {
    try {
      int count = 0;
      User user = await UserClient.fetchCurrentUser();

      print('User: ${user.nama}, ${user.email}');

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User tidak ditemukan"),
          ),
        );
        return;
      }

      await UserClient.updateFoto(File(imagePath));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Foto berhasil diperbarui!"),
          backgroundColor: Colors.green,
        ),
      );

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => EditPage()),
      // );


      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => EditPage()),
        (Route<dynamic> route) {
          return count++ >= 3; // Mempertahankan dua rute pertama
        },
      );

      
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal memperbarui foto: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display the Picture'),
        backgroundColor: Color.fromARGB(255, 33, 61, 41),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.file(File(imagePath)),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                await _updateUserFoto(context);
              },
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
