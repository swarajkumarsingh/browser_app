import '../data_source/offline/home_offline_data_source.dart';
import '../../domain/models/news_model.dart';

import '../../core/dio/api.dart';
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

  @override
  Future<RemoteResponse<News>> getNewsData(String url) async {
    if (!await isNetworkAvailable) {
      return HomeOfflineDataSource().getNewsData();
    }
    // return await HomeOnlineDataSource().getNewsData(url);
    final response = await Api().get(url);

    // if (response.statusCode == 200) {
    //   return ;
    // }

    return RemoteResponse.success(News.fromJson(response.data));
  }
}
