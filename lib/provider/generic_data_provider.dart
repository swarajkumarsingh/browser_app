import 'package:flutter/material.dart';

import 'generic_data_provider_impl.dart';

final genericDataProvider = GenericDataProviderImpl();

abstract class GenericDataProvider {
  // Getting the Base URL of API
  String getBaseUrl();

  // Get Context
  BuildContext? getContext();

  // Put token in device
  Future<bool?> putToken(String token);

  // Get token in device
  Future<String> getToken();

  // Put token in device
  Future<bool?> putUserData(String token);

  // Get token in device
  Future<String> getUserData();
}
