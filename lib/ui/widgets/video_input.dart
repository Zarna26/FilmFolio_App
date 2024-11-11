import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class VideoInput extends StatefulWidget {
  final String showname;
  final Function(String) onVideoUploaded;

  const VideoInput({
    Key? key,
    required this.showname,
    required this.onVideoUploaded,
  }) : super(key: key);

  @override
  _VideoInputState createState() => _VideoInputState();
}

class _VideoInputState extends State<VideoInput> {
  File? _video;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  String? _videoUrl;

  Future<void> _pickVideo() async {
    final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _video = File(pickedFile.path);
      });
      await _uploadVideo(_video!);
    }
  }

  Future<void> _uploadVideo(File videoFile) async {
    setState(() {
      _isUploading = true;
    });

    try {
      String fileName = path.basename(videoFile.path);
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('filmfolio/${widget.showname}/$fileName');
      UploadTask uploadTask = ref.putFile(videoFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      _videoUrl = await taskSnapshot.ref.getDownloadURL();
      widget.onVideoUploaded(_videoUrl!);
    } catch (e) {
      print('Error uploading video: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _removeVideo() {
    setState(() {
      _video = null;
      _videoUrl = null;
    });
    widget.onVideoUploaded("");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: _isUploading ? null : _pickVideo,
          icon: const Icon(Icons.video_library),
          label: const Text('Select Trailer Video'),
        ),
        const SizedBox(height: 8),
        if (_isUploading)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        const SizedBox(height: 8),
        if (_video != null)
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.black54,
                    size: 60,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: _removeVideo,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        if (_video != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Selected video: ${path.basename(_video!.path)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
