import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../services/CameraServerApiHelper.dart';
import '../../models/CameraServerApiModels.dart';
import '../errorSnackBar.dart';

class NewCameraQr extends StatefulWidget {
  NewCameraQr({Key key, @required this.cameraName}) : super(key: key);

  final String cameraName;

  @override
  _NewCameraQrState createState() => _NewCameraQrState();
}

class _NewCameraQrState extends State<NewCameraQr> {
  CameraServerApiHelper cameraServerApiHelper =
      GetIt.instance<CameraServerApiHelper>();

  Future newCameraQrFuture;

  @override
  void initState() {
    super.initState();
    newCameraQrFuture = cameraServerApiHelper.addCamera(widget.cameraName);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CameraToken>(
      future: newCameraQrFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: QrImage(
                  // errorCorrectionLevel: QrErrorCorrectLevel.M,
                  data: qrText(
                    cameraServerApiHelper.currentUser.baseUrl,
                    snapshot.data.cameraToken,
                  ),
                ),
              ),
              Text(
                "Hold this QR code 20-30cm in front of the camera and click \"FINISH\" once the camera scans the QR code.",
                textAlign: TextAlign.center,
              )
            ],
          );
        } else if (snapshot.hasError) {
          errorSnackBar(snapshot.error, context);
          return Center(child: Text("Something went wrong!"));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

/// Generates the string that is encoded into a QR code.
/// It's basically just the base url and the camera token with the dashes removed.
String qrText(String baseUrl, String cameraToken) =>
    baseUrl + "," + cameraToken.replaceAll("-", "");
