import '../../../../dio/remote_response.dart';
import '../../../../utils/network/network.dart';
import '../../domain/models/home.dart';
import '../../domain/repository/home_repository.dart';
import '../data_source/home_data_source.dart';

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
