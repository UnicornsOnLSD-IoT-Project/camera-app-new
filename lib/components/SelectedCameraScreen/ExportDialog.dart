import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:path_provider/path_provider.dart';

class ExportDialog extends StatefulWidget {
  ExportDialog({Key key, @required this.images, @required this.frameTime})
      : super(key: key);

  final List<Uint8List> images;
  final Duration frameTime;

  @override
  _ExportDialogState createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  Future<void> _export() async {
    Directory tempPath = await getTemporaryDirectory();

    int index = 0;
    List<Future> fileFutures = [];
    widget.images.forEach((element) {
      fileFutures
          .add(File("${tempPath.path}/$index.jpeg").writeAsBytes(element));
      index++;
    });
    await Future.wait(fileFutures);

    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

    List<FileSystemEntity> imageList = await tempPath.list().toList();

    // If this failed the last time this was run, it may still have these files. These need to be deleted or FFmpeg will fail.
    File('${tempPath.path}/inputlist.txt').delete();
    File('${tempPath.path}/output.mp4').delete();

    // This prepares the list needed for FFmpeg's concat thing (since glob only works on Linux/macos)
    String imageString = "";
    for (FileSystemEntity image in imageList) {
      imageString = imageString +
          "file '${image.path}'\nduration ${widget.frameTime.inMilliseconds / 1000}\n";
    }

    await File('${tempPath.path}/inputlist.txt').writeAsString(imageString);

    // -f concat: Way that ffmpeg reads input. Concat uses inputlist.txt, which is generated before this.
    // -safe 0: Wouldn't run without this, not really sure what it does.
    // -i ${temporaryPath.path}/inputlist.txt: Sets the input to the inputlist.txt which has all the images and how long they should be displayed.
    // -pix_fmt yuv420p: It's recommended to do this to ensure that "bad players" can still play the video.
    // -c:v libx264: Sets the video codec.
    // ${tempPath.path}/output.mp4: Output location.
    await _flutterFFmpeg.execute(
        "-f concat -safe 0 -i ${tempPath.path}/inputlist.txt -pix_fmt yuv420p -c:v libx264 ${tempPath.path}/output.mp4");

    await GallerySaver.saveVideo("${tempPath.path}/output.mp4");

    // These need to be deleted or FFmpeg will fail next time. It also saves space.
    File('${tempPath.path}/inputlist.txt').delete();
    File('${tempPath.path}/output.mp4').delete();
  }

  Future exportDialogFuture;

  @override
  void initState() {
    super.initState();
    exportDialogFuture = _export();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Exporting..."),
      content: FutureBuilder(
        future: exportDialogFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Navigator.of(context).pop();
            return Text("Done");
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return LinearProgressIndicator();
          }
        },
      ),
    );
  }
}
