import '../../domain/models/home.dart';
import '../../domain/repository/home_repository.dart';
import '../../utils/network/network.dart';
import '../data_source/online/home_online_data_source.dart';
import '../remote/remote_response.dart';

final homeRepositoryImpl = HomeRepositoryImpl();

class HomeRepositoryImpl extends HomeRepository {
  HomeRepositoryImpl();

  @override
  Future<RemoteResponse<Home>> getHomeData() async {
    if (!await isNetworkAvailable) {
      return RemoteResponse.internetConnectionError();
    }
    return await HomeOnlineDataSource().getHomeData();
  }
}
