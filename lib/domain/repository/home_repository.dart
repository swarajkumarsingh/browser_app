import '../../data/data_source/online/home_data_source.dart';
import '../../data/remote/remote_response.dart';
import '../../data/repository/home_repository_impl.dart';
import '../models/home.dart';

final HomeRepository homeRepository = HomeRepositoryImpl(homeDataSource);

abstract class HomeRepository {
  Future<RemoteResponse<Home>> getHomeData();
}
