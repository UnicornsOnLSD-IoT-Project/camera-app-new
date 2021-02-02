import 'package:chopper/chopper.dart';
import 'package:get_it/get_it.dart';

import '../models/CameraServerApiModels.dart';
import 'CameraServerApiHelper.dart';

part 'CameraServerApi.chopper.dart';

@ChopperApi()
abstract class CameraServerApi extends ChopperService {
  @Post(path: "/AddUser")
  Future<Response> addUser(@Body() InsertableUser newUser);

  @Post(path: "/Login")
  Future<Response> login(@Body() InsertableUser newUser);

  static CameraServerApi create() {
    final client = ChopperClient(
        services: [_$CameraServerApi()],
        converter: JsonConverter(),
        interceptors: [
          (Request request) {
            CameraServerApiHelper cameraServerApiHelper =
                GetIt.instance<CameraServerApiHelper>();
            if (cameraServerApiHelper.baseUrlTemp != null) {
              return request.copyWith(
                  baseUrl: cameraServerApiHelper.baseUrlTemp);
            } else {
              return request.copyWith(
                  baseUrl: cameraServerApiHelper.currentUser.baseUrl);
            }
          },
          HttpLoggingInterceptor(),
        ]);

    return _$CameraServerApi(client);
  }
}
