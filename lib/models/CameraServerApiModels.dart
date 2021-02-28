import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'CameraServerApiModels.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
@HiveType(typeId: 0)

/// Class for holding users.
/// Unlike other classes, this doesn't match up with the User class on the server.
/// This class is purely used for the app, which is why some of the other User classes may not make sense.
class User {
  User({
    this.username,
    this.userId,
    this.userToken,
    this.baseUrl,
  });

  @HiveField(0)
  final String username;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String userToken;
  @HiveField(3)
  @JsonKey(ignore: true)
  final String baseUrl;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class InsertableUser {
  InsertableUser({
    this.username,
    this.password,
  });

  final String username;
  final String password;

  factory InsertableUser.fromJson(Map<String, dynamic> json) =>
      _$InsertableUserFromJson(json);
  Map<String, dynamic> toJson() => _$InsertableUserToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class UserInfo {
  UserInfo({
    this.username,
    this.userId,
  });

  final String username;
  final String userId;

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

@HiveType(typeId: 1)
class CurrentUser {
  @HiveField(0)
  final String userId;
  CurrentUser({
    this.userId,
  });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class AuthenticationResult {
  AuthenticationResult({
    this.userInfo,
    this.userToken,
  });

  final UserInfo userInfo;
  final String userToken;

  factory AuthenticationResult.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResultFromJson(json);
  Map<String, dynamic> toJson() => _$AuthenticationResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Camera {
  Camera({
    this.name,
    this.cameraId,
  });

  final String name;
  final String cameraId;

  factory Camera.fromJson(Map<String, dynamic> json) => _$CameraFromJson(json);
  Map<String, dynamic> toJson() => _$CameraToJson(this);
}

/// This class is used for creating cameras with /AddCameras.
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class InsertableCamera {
  InsertableCamera({
    this.name,
  });

  final String name;

  factory InsertableCamera.fromJson(Map<String, dynamic> json) =>
      _$InsertableCameraFromJson(json);
  Map<String, dynamic> toJson() => _$InsertableCameraToJson(this);
}

/// This class is returned from /AddCameras
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CameraToken {
  CameraToken({
    this.cameraToken,
    this.cameraId,
  });

  final String cameraToken;
  final String cameraId;

  factory CameraToken.fromJson(Map<String, dynamic> json) =>
      _$CameraTokenFromJson(json);
  Map<String, dynamic> toJson() => _$CameraTokenToJson(this);
}
