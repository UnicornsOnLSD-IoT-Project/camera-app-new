import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/CameraServerApiHelper.dart';

class LatestImage extends StatelessWidget {
  const LatestImage({Key key, @required this.cameraId}) : super(key: key);

  final String cameraId;

  @override
  Widget build(BuildContext context) {
    CameraServerApiHelper cameraServerApiHelper =
        GetIt.instance<CameraServerApiHelper>();

    return Image.network(
      "${cameraServerApiHelper.currentUser.baseUrl}/Cameras/$cameraId/LatestImage",
      headers: {"user_token": cameraServerApiHelper.currentUser.userToken},
      errorBuilder: (_, __, ___) => Icon(
        Icons.image_not_supported,
        size: 64,
        color: Colors.grey,
      ),
      fit: BoxFit.cover,
    );
  }
}
