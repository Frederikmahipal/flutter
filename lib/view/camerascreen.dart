import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  List<CameraDescription>? cameras;
  late String imagePath;
  int _cameraindex = 0;

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras![0], ResolutionPreset.ultraHigh,
        imageFormatGroup: ImageFormatGroup.jpeg);
    await _controller.initialize();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      final imagepath = path.join(
        (await getExternalStorageDirectory())!.path,
        '${DateTime.now()}.jpg',
      );

      XFile picture = await _controller.takePicture();
      await GallerySaver.saveImage(picture.path);
      setState(() {
        imagePath = imagepath;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _toggleCamera() async {
    if (cameras != null && cameras!.isNotEmpty) {
      _cameraindex = (_cameraindex + 1) % cameras!.length;
      await _controller.dispose();
      _controller = CameraController(
          cameras![_cameraindex], ResolutionPreset.ultraHigh,
          imageFormatGroup: ImageFormatGroup.jpeg);
      await _controller.initialize();
      setState(() {});
    }
  }

  Widget _buildCameraPreview() {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    final previewRatio = _controller.value.previewSize!.height /
        _controller.value.previewSize!.width;
    final aspectRatio = deviceRatio < previewRatio
        ? previewRatio / deviceRatio
        : deviceRatio / previewRatio;
    return Transform.scale(
      scale: aspectRatio,
      child: Center(
        child: AspectRatio(
          aspectRatio: 1 / _controller.value.aspectRatio,
          child: CameraPreview(_controller),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
      ),
      body: cameras == null
          ? Center(child: CircularProgressIndicator())
          : _buildCameraPreview(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(Icons.switch_camera),
            onPressed: _toggleCamera,
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            child: Icon(Icons.camera_alt),
            onPressed: _takePicture,
          ),
        ],
      ),
    );
  }
}
