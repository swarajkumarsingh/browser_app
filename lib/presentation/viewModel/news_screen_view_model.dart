import 'package:share_plus/share_plus.dart';

import '../../core/common/snackbar/show_snackbar.dart';
import '../../core/event_tracker/event_tracker.dart';
import '../../domain/models/news_model.dart';
import '../../domain/repository/news_repository.dart';

final newsViewModel = _NewsViewModel();
class _NewsViewModel {
  Future<void> logScreen() async {
    await eventTracker.screen("news-screen");
  }

   Future<News?> getNews() async {
    final model = await newsRepository.getNewsUrl();
    if (!model.successBool) {
      return null;
    }
    return model.data!;
  }

    Future<void> shareApp() async {
    try {
      const url = "https://github.com/swarajkumarsingh/browser_app";
      await Share.share("Share this app $url");
    } catch (e) {
      showSnackBar("Unable to share, Please try again later.");
    }
  }
}
