import '../../../../dio/remote_response.dart';
import '../../domain/repository/home_repository.dart';
import '../../domain/models/home.dart';
import '../../data/repositories/home_repository_impl.dart';

final homeService = HomeService(homeRepositoryImpl);

class HomeService {
  HomeService(this._homeRepository);
  final HomeRepository _homeRepository;

  Future<RemoteResponse<Home>> getData() async {
    return await _homeRepository.getHomeData();
  }
}
