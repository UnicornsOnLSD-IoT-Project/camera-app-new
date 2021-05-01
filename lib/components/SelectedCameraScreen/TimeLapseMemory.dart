import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

import '../../services/CameraServerApiHelper.dart';
import 'ExportDialog.dart';

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

  List<Widget> images = [];

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
    return FutureBuilder<List<Response>>(
      future: Future.wait(timeLapseMemoryFutures),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          void _setTimer(Duration duration) {
            timer.cancel();
            setState(() {
              timerDuration = duration;
              timer = Timer.periodic(duration, (timer) {
                setState(() {
                  if (index >= timeLapseMemoryFutures.length - 1) {
                    index = -1;
                  }
                  index++;
                  images.add(Image.memory(snapshot.data[index].bodyBytes));
                  print(images.length);
                  if (images.length > 2) {
                    print("Remove");
                    images.removeAt(0);
                  }
                });
              });
            });
          }

          if (timer == null) {
            timer = Timer.periodic(timerDuration, (timer) {
              setState(() {
                if (index >= timeLapseMemoryFutures.length - 1) {
                  index = -1;
                }
                index++;
                images.add(Image.memory(snapshot.data[index].bodyBytes));
                print(images.length);
                if (images.length > 2) {
                  print("Remove");
                  images.removeAt(0);
                }
              });
            });
          }
          return Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: AspectRatio(
                  aspectRatio: 4056 / 3040,
                  child: Stack(
                    children: images,
                  ),
                ),
              ),
              Text(
                "Refresh Interval",
                style: Theme.of(context).textTheme.headline6,
              ),
              Slider(
                value: timerDuration.inMilliseconds.toDouble(),
                min: 100,
                max: 1000,
                onChanged: (value) =>
                    _setTimer(Duration(milliseconds: (value).toInt())),
              ),
              ElevatedButton(
                child: Text("EXPORT"),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => ExportDialog(
                      frameTime: timerDuration,
                      images: snapshot.data.map((e) => e.bodyBytes).toList()),
                ),
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
