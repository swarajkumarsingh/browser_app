import '../../domain/models/home/home.dart';
import '../../domain/repository/home_repository.dart';
import '../../utils/network/network.dart';
import '../data_source/online/home_data_source.dart';
import '../remote/remote_response.dart';

final homeRepositoryImpl = HomeRepositoryImpl(homeDataSource);

class HomeRepositoryImpl extends HomeRepository {
  final HomeDataSource _homeDataSource;
  HomeRepositoryImpl(this._homeDataSource);

  @override
  Future<RemoteResponse<Home>> getHomeData() async {
    if (!await isNetworkAvailable) {
      return RemoteResponse.internetConnectionError();
    }
    return await _homeDataSource.getHomeData();
  }
}
