import 'package:flutter/material.dart';

import '../../models/CameraServerApiModels.dart';
import '../../screens/SelectedCameraScreen.dart';
import '../LatestImage.dart';

class CamerasListCard extends StatelessWidget {
  const CamerasListCard({Key key, @required this.camera}) : super(key: key);

  final Camera camera;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed("/camera", arguments: camera),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 507 / 380,
              child: LatestImage(
                cameraId: camera.cameraId,
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      camera.name,
                      style: Theme.of(context).textTheme.headline6,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "10 Photos",
                      style: Theme.of(context).textTheme.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
