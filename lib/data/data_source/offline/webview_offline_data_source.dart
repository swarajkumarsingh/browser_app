import '../../remote/remote_response.dart';

class WebviewOfflineDataSource {
  Future<RemoteResponse<List<String>>> getSuggestions(
      {required String keyword}) async {
    return RemoteResponse.success([]);
  }
}
