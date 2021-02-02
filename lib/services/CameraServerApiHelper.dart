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

  Future<User> login(String username, String password, String baseUrl) async {
    baseUrlTemp = baseUrl;
    Response response = await _cameraServerApi.login(InsertableUser(
      username: username,
      password: password,
    ));
    baseUrlTemp = null;

    if (response.isSuccessful) {
      User newUser = User.fromJson(response.body);
      await _saveUser(newUser);
      return newUser;
    } else {
      return Future.error(response.error);
    }
  }

  Future<void> _saveUser(User newUser) async {
    await _usersBox.put(newUser.userId, newUser);
    await _currentUserBox.put(
        "CurrentUser", CurrentUser(userId: newUser.userId));
  }

  int get userCount => _usersBox.length;
  User get currentUser => _usersBox.get(_currentUserBox.get("CurrentUser"));
}
