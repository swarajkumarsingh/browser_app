import '../db/webview_db.dart';
import '../../domain/models/webview_model.dart';

List<WebViewModel> fakeTabsData = <WebViewModel>[
  WebViewModel(
    url: "https://google.com/",
    tabIndex: 1,
    title: "Google",
    isIncognitoMode: false,
    screenshot: webviewDB.getHomeScreenImageBytes(),
  ),
  WebViewModel(
    url: "https://google.com/",
    tabIndex: 1,
    title: "Google",
    isIncognitoMode: false,
    screenshot: webviewDB.getHomeScreenImageBytes(),
  )
];
