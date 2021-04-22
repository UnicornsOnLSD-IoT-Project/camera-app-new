import 'package:chopper/chopper.dart';
import 'package:hive/hive.dart';

import '../models/CameraServerApiModels.dart';
import 'CameraServerApi.dart';

class CameraServerApiHelper {
  CameraServerApi _cameraServerApi = CameraServerApi.create();
  Box<User> _usersBox = Hive.box<User>("Users");
  Box<CurrentUser> _currentUserBox = Hive.box<CurrentUser>("CurrentUser");

  /// This value is used when logging in so that the chopper client can use the new base URL
  String baseUrlTemp;

  /// Creates a new user on the camera server.
  Future<User> createUser(String username, String password) async {
    Response response = await _cameraServerApi.addUser(InsertableUser(
      username: username,
      password: password,
    ));

    if (response.isSuccessful) {
      // If the response is successful, add the user into a box and return the user
      User newUser = User.fromJson(response.body);
      await _saveUser(newUser);
      return newUser;
    } else {
      return Future.error(response);
    }
  }

  Future<User> login(String username, String password, String baseUrl,
      bool createNewUser) async {
    baseUrlTemp = baseUrl;
    Response response;

    if (createNewUser) {
      response = await _cameraServerApi.addUser(InsertableUser(
        username: username,
        password: password,
      ));
    } else {
      response = await _cameraServerApi.login(InsertableUser(
        username: username,
        password: password,
      ));
    }
    baseUrlTemp = null;

    if (response.isSuccessful) {
      AuthenticationResult authenticationResult =
          AuthenticationResult.fromJson(response.body);

      // Put the AuthenticationResult data into a User object
      User newUser = User(
          username: authenticationResult.userInfo.username,
          userId: authenticationResult.userInfo.userId,
          userToken: authenticationResult.userToken,
          baseUrl: baseUrl);

      await _saveUser(newUser);
      return newUser;
    } else {
      return Future.error(response.error);
    }
  }

  /// Returns a list of all cameras the current user has access to
  Future<List<Camera>> listCameras() async {
    Response response = await _cameraServerApi.listCameras();

    if (response.isSuccessful) {
      return List<Camera>.from(
          response.body.map((camera) => Camera.fromJson(camera)));
    } else {
      return Future.error(response.error);
    }
  }

  Future<List<String>> listImages(String cameraId) async {
    Response response = await _cameraServerApi.listImages(cameraId);

    if (response.isSuccessful) {
      // I can't be bothered to actually return types from Chopper so we convert the List<dynamic> to a List<String>.
      // This isn't an issue for other requests since they all get converted from JSON.
      List<String> stringList = response.body.cast<String>();
      return stringList;
    } else {
      return Future.error(response.error);
    }
  }

  Future<CameraToken> addCamera(String cameraName) async {
    Response response =
        await _cameraServerApi.addCamera(InsertableCamera(name: cameraName));

    if (response.isSuccessful) {
      // Note: For adding cameras, we immediately serialise this again. That isn't the most efficient way of doing things.
      return CameraToken.fromJson(response.body);
    } else {
      return Future.error(response.error);
    }
  }

  int get userCount => _usersBox.length;
  User get currentUser =>
      _usersBox.get(_currentUserBox.get("CurrentUser").userId);

  Future<Response> getImage(String cameraId, String imageId) =>
      _cameraServerApi.getImage(cameraId, imageId);

  Future<void> _saveUser(User newUser) async {
    await _usersBox.put(newUser.userId, newUser);
    await _currentUserBox.put(
        "CurrentUser", CurrentUser(userId: newUser.userId));
  }
}
