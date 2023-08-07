import 'package:flutter/material.dart';

import '../utils/context.dart';
import 'generic_data_provider.dart';

class GenericDataProviderImpl extends GenericDataProvider {
  @override
  String getBaseUrl() {
    return const String.fromEnvironment("BASE_URL");
  }

  @override
  BuildContext? getContext() {
    return contextUtils.getContext();
  }

  @override
  Future<String> getToken() {
    // TODO: implement getToken
    throw UnimplementedError();
  }

  @override
  Future<String> getUserData() {
    // TODO: implement getUserData
    throw UnimplementedError();
  }

  @override
  Future<bool?> putToken(String token) {
    // TODO: implement putToken
    throw UnimplementedError();
  }

  @override
  Future<bool?> putUserData(String token) {
    // TODO: implement putUserData
    throw UnimplementedError();
  }
}
