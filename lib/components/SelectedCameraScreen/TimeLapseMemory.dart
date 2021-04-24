import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

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
  List<Future<Response>> timeLapseMemoryFutures = [];
  Timer timer;
  Duration timerDuration = Duration(milliseconds: 1000);
  int index = 0;

  @override
  void initState() {
    super.initState();
    widget.imageIds.forEach((element) {
      timeLapseMemoryFutures.add(get(
        Uri.parse(
            "${cameraServerApiHelper.currentUser.baseUrl}/Cameras/${widget.cameraId}/Image/$element"),
        headers: {"user_token": cameraServerApiHelper.currentUser.userToken},
      ));
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _setTimer(Duration duration) {
      timer.cancel();
      setState(() {
        timerDuration = duration;
        timer = Timer.periodic(duration, (timer) {
          setState(() {
            if (index >= timeLapseMemoryFutures.length - 1) {
              index = 0;
            } else {
              index++;
            }
          });
        });
      });
    }

    return FutureBuilder<List<Response>>(
      future: Future.wait(timeLapseMemoryFutures),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (timer == null) {
            timer = Timer.periodic(timerDuration, (timer) {
              setState(() {
                if (index >= timeLapseMemoryFutures.length - 1) {
                  index = 0;
                } else {
                  index++;
                }
              });
            });
          }
          return Column(
            children: [
              Image.memory(snapshot.data[index].bodyBytes),
              Slider(
                value: timerDuration.inMilliseconds.toDouble(),
                min: 100,
                max: 1000,
                onChanged: (value) =>
                    _setTimer(Duration(milliseconds: (value).toInt())),
              )
            ],
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
