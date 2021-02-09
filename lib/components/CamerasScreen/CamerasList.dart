import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/CameraServerApiHelper.dart';
import '../../models/CameraServerApiModels.dart';
import '../errorSnackBar.dart';

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
            child: Scrollbar(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Text(snapshot.data[index].name),
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
