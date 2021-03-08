import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import '../models/CameraServerApiModels.dart';
import 'CameraServerApiHelper.dart';

class ImageDownloader {
  CameraServerApiHelper _cameraServerApiHelper =
      GetIt.instance<CameraServerApiHelper>();

  Future<void> syncImages(String cameraId) async {}
}
