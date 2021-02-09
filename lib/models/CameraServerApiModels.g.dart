// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CameraServerApiModels.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      username: fields[0] as String,
      userId: fields[1] as String,
      userToken: fields[2] as String,
      baseUrl: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.userToken)
      ..writeByte(3)
      ..write(obj.baseUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CurrentUserAdapter extends TypeAdapter<CurrentUser> {
  @override
  final int typeId = 1;

  @override
  CurrentUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentUser(
      userId: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CurrentUser obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    username: json['username'] as String,
    userId: json['user_id'] as String,
    userToken: json['user_token'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'user_id': instance.userId,
      'user_token': instance.userToken,
    };

InsertableUser _$InsertableUserFromJson(Map<String, dynamic> json) {
  return InsertableUser(
    username: json['username'] as String,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$InsertableUserToJson(InsertableUser instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo(
    username: json['username'] as String,
    userId: json['user_id'] as String,
  );
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'username': instance.username,
      'user_id': instance.userId,
    };

AuthenticationResult _$AuthenticationResultFromJson(Map<String, dynamic> json) {
  return AuthenticationResult(
    userInfo: json['user_info'] == null
        ? null
        : UserInfo.fromJson(json['user_info'] as Map<String, dynamic>),
    userToken: json['user_token'] as String,
  );
}

Map<String, dynamic> _$AuthenticationResultToJson(
        AuthenticationResult instance) =>
    <String, dynamic>{
      'user_info': instance.userInfo?.toJson(),
      'user_token': instance.userToken,
    };

Camera _$CameraFromJson(Map<String, dynamic> json) {
  return Camera(
    name: json['name'] as String,
    cameraId: json['camera_id'] as String,
  );
}

Map<String, dynamic> _$CameraToJson(Camera instance) => <String, dynamic>{
      'name': instance.name,
      'camera_id': instance.cameraId,
    };

InsertableCamera _$InsertableCameraFromJson(Map<String, dynamic> json) {
  return InsertableCamera(
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$InsertableCameraToJson(InsertableCamera instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

CameraToken _$CameraTokenFromJson(Map<String, dynamic> json) {
  return CameraToken(
    cameraToken: json['camera_token'] as String,
    cameraId: json['camera_id'] as String,
  );
}

Map<String, dynamic> _$CameraTokenToJson(CameraToken instance) =>
    <String, dynamic>{
      'camera_token': instance.cameraToken,
      'camera_id': instance.cameraId,
    };
