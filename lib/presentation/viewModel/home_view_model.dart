import 'package:flutter_approuter/flutter_approuter.dart';

import '../../core/event_tracker/event_tracker.dart';
import '../view/history/history_screen.dart';
import '../view/search/search_screen.dart';

final homeViewModel = _HomeViewModel();

class _HomeViewModel {
  Future<void> logScreen() async {
    await eventTracker.screen("home-screen");
  }

  void navigateToHistoryScreen() {
    appRouter.push(const HistoryScreen());
  }

  void navigateToSearchScreen() {
    appRouter.push(const SearchScreen());
  }
}
