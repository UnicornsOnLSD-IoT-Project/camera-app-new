import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/CameraServerApiHelper.dart';

class TimeLapseMemory extends StatefulWidget {
  TimeLapseMemory({Key key, @required this.cameraId, @required this.imageIds})
      : super(key: key);

  final String cameraId;
  final List<String> imageIds;

  @override
  _TimeLapseMemoryState createState() => _TimeLapseMemoryState();
}

class _TimeLapseMemoryState extends State<TimeLapseMemory> {
  CameraServerApiHelper cameraServerApiHelper =
      GetIt.instance<CameraServerApiHelper>();
  List<Future<Response>> timeLapseMemoryFutures;
  Timer timer;
  int index = 0;

  @override
  void initState() {
    super.initState();
    widget.imageIds.forEach((element) {
      timeLapseMemoryFutures
          .add((cameraServerApiHelper.getImage(widget.cameraId, element)));
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Response>>(
      future: Future.wait(timeLapseMemoryFutures),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          timer = Timer.periodic(Duration(seconds: 1), (timer) {
            setState(() {
              if (index == timeLapseMemoryFutures.length) {
                index = 0;
              } else {
                index++;
              }
            });
          });
          return Image.memory(snapshot.data[index].body);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
