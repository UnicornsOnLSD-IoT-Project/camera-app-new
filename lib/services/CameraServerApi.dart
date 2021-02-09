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

  @Get(path: "/ListCameras")
  Future<Response> listCameras();

  static CameraServerApi create() {
    final client = ChopperClient(
        services: [_$CameraServerApi()],
        converter: JsonConverter(),
        interceptors: [
          /// Puts the base url in the request. If we're logging in, the variable baseUrlTemp will be set, so we use that. If not, we use the base url from the current user.
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

          /// Sets the user token header, used for authentication.
          (Request request) {
            CameraServerApiHelper cameraServerApiHelper =
                GetIt.instance<CameraServerApiHelper>();

            // String userToken = cameraServerApiHelper.currentUser.userToken;
            // TODO: make this readable
            if (cameraServerApiHelper.baseUrlTemp == null) {
              return request.copyWith(headers: {
                "user_token": cameraServerApiHelper.currentUser.userToken,
              });
            } else {
              return request;
            }
          },
          HttpLoggingInterceptor(),
        ]);

    return _$CameraServerApi(client);
  }
}
