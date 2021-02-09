// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CameraServerApi.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$CameraServerApi extends CameraServerApi {
  _$CameraServerApi([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = CameraServerApi;

  @override
  Future<Response<dynamic>> addUser(InsertableUser newUser) {
    final $url = '/AddUser';
    final $body = newUser;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> login(InsertableUser newUser) {
    final $url = '/Login';
    final $body = newUser;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> addCamera(InsertableCamera insertableCamera) {
    final $url = '/AddCamera';
    final $body = insertableCamera;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> listCameras() {
    final $url = '/ListCameras';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
