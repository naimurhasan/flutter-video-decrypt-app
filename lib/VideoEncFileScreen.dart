import 'dart:io';

import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as Enc;

class VideoEncFileScreen extends StatefulWidget {
  final String filePath;

  const VideoEncFileScreen({Key key, this.filePath}) : super(key: key);

  @override
  _VideoEncFileScreenState createState() => _VideoEncFileScreenState();
}

class _VideoEncFileScreenState extends State<VideoEncFileScreen> {
  VideoPlayerController _controller;

  void decryptAndPlay() async {
    File protected_file = File(widget.filePath);
    final b64key = Enc.Key.fromUtf8('12345678901234567890123456789012');
    final fernet = Enc.Fernet(b64key);
    final encrypter = Enc.Encrypter(fernet);

    final encrypted = Enc.Encrypted(
        Uint8List.fromList(base64Decode(await protected_file.readAsString())));
    File decFile = File('/storage/emulated/0/Android/protected_video.mp4');
    await decFile.writeAsBytes(encrypter.decryptBytes(encrypted));

    _controller = VideoPlayerController.file(decFile)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(""));
    // _controller = VideoPlayerController.file(
    //     File('/storage/emulated/0/Android/protected_video.mp4'))
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });

    decryptAndPlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.initialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
