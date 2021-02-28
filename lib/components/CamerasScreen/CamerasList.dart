import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/CameraServerApiHelper.dart';
import '../../models/CameraServerApiModels.dart';
import '../errorSnackBar.dart';
import 'NoCamerasMessage.dart';
import 'CamerasListCard.dart';

class CamerasList extends StatefulWidget {
  const CamerasList({Key key}) : super(key: key);

  @override
  _CamerasListState createState() => _CamerasListState();
}

class _CamerasListState extends State<CamerasList> {
  CameraServerApiHelper cameraServerApiHelper =
      GetIt.instance<CameraServerApiHelper>();

  Future camerasListFuture;

  @override
  void initState() {
    super.initState();
    camerasListFuture = cameraServerApiHelper.listCameras();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Camera>>(
      future: camerasListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // We need this condition because when the future is reset, hasData and hasError aren't reset for some reason
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: () {
              setState(() {
                camerasListFuture = cameraServerApiHelper.listCameras();
              });
              return camerasListFuture;
            },
            child: snapshot.data.length == 0
                // If there are no cameras, return some text telling the user to add some cameras.
                ? NoCamerasMessage()
                : Scrollbar(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        // Aspect ratio taken from https://material.io/components/cards#specs
                        childAspectRatio: 172 / 191,
                      ),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return CamerasListCard(
                          camera: snapshot.data[index],
                        );
                      },
                    ),
                  ),
          );
        } else if (snapshot.hasError) {
          errorSnackBar(snapshot.error, context);
          return Center(
            child: Text("An error has occured!"),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
