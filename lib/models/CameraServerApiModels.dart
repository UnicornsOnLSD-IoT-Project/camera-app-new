import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'CameraServerApiModels.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
@HiveType(typeId: 0)
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

@HiveType(typeId: 1)
class CurrentUser {
  @HiveField(0)
  final String userId;
  CurrentUser({
    this.userId,
  });
}
