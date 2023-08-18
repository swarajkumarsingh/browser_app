import 'package:browser_app/utils/browser/browser_constants.dart';
import 'package:dio/dio.dart';

final browserUtils = _BrowserUtils();

class _BrowserUtils {
  String addHttpToDomain(String domain) {
    if (domain.contains("https://")) {
      return domain;
    }
    return "http://${domain.toLowerCase()}";
  }

  String addQueryToGoogle(String prompt) {
    return "https://www.google.com/search?q=$prompt";
  }

  String addQueryToBing(String prompt) {
    return "https://www.bing.com/search?q=$prompt";
  }

  bool isDataURL(String keyword) {
    return keyword.startsWith("data:image");
  }

  Future<bool> isDownloadRequest(String url) async {
    bool result =
        _checkUrlEndsWithAnyExtension(url, browserConstants.fileExtensions);
    if (result) return result;

    // check if the url contains specific keyword
    result = _checkForKeywordsInUrl(url);
    if (result) return result;

    // check the headers of the url
    result = await _checkIfUrlContainsDownloadableHeader(url);
    if (result) return result;

    return false;
  }

  String removeQueryFromUrl(String url) {
    final Uri uri = Uri.parse(url);
    final Uri newUri = uri.replace(queryParameters: {});
    final a = newUri.toString().replaceAll("?", "");
    return a;
  }

  bool _checkUrlEndsWithAnyExtension(String url, List<String> extensions) {
    return hashSearch(searchItem: removeQueryFromUrl(url), sortedList: extensions);
  }

  bool isSaveAbleUrl(String url) {
    return !(url.startsWith("intent:") ||
        url.startsWith("about:") ||
        url.startsWith("data:") ||
        url.startsWith("mailto:") ||
        url.startsWith("file:"));
  }

  bool hashSearch(
      {required String searchItem, required List<String> sortedList}) {
    final Set<int> itemHashes = sortedList.map((item) => item.hashCode).toSet();
    final int urlHash =
        searchItem.substring(searchItem.lastIndexOf(".")).hashCode;
    return itemHashes.contains(urlHash);
  }

  bool _checkForKeywordsInUrl(String url) {
    return hashSearch(searchItem: url, sortedList: browserConstants.keywords);
  }

  bool containsBlockedSites(String url) {
    for (final site in browserConstants.blockedSites) {
      return url.startsWith(site);
    }
    return false;
  }

  Future<bool> _checkIfUrlContainsDownloadableHeader(String url) async {
    final dio = Dio();

    try {
      final response = await dio.head(
        url,
        options: Options(
          responseType: ResponseType.bytes, // Set the responseType to bytes
        ),
      );

      // Check if the Content-Disposition header exists
      final contentDisposition = response.headers.value('content-disposition');
      if (contentDisposition != null) {
        if (contentDisposition.contains('attachment')) {
          return true;
        }
      }
    } catch (error) {
      return false;
    }
    return false;
  }

  bool isGoogleAdUrl(String dataString) {
    try {
      final host = Uri.parse(dataString).host;
      (host == "googleadservices.com" ||
          host == "www.googleadservices.com" ||
          host == "adclick.g.doubleclick.net" ||
          host == "www.adclick.g.doubleclick.net" ||
          host == "googleads.g.doubleclick.net" ||
          host == "www.googleads.g.doubleclick.net");
    } catch (e) {
      false;
    }
    return false;
  }
}


//           fun getDefaultBookMarkList() = arrayListOf(
//             Site("Google", R.drawable.site_google, null, "https://google.com", TopSitesViewPager.VIEW_TYPE_SPEED_DIAL ),
//             Site("Amazon", R.drawable.ic_site_amazon_icon, null, "https://amzn.to/3mQp384", TopSitesViewPager.VIEW_TYPE_SPEED_DIAL ),
//             Site("FlipKart", R.drawable.flipcart_sale_icon, null, "https://ww55.siteplug.com/sssdomweb?enk=ff4496bc59b25659cac2a55d00c1ee86d6c36a84e523c17b951b103acbf5f1a7ef2c530cc0fe75dcee32f77628e1480a3acec33b49c3549d2eb2f663d65f3654&di={device_identifier}&subid={subid}", TopSitesViewPager.VIEW_TYPE_SPEED_DIAL ),
//             Site("Facebook", R.drawable.facebook_home_slider, null, "https://m.facebook.com", TopSitesViewPager.VIEW_TYPE_SPEED_DIAL ),
//             Site("YouTube", R.drawable.youtube_home_slider,  null, "https://m.youtube.com", TopSitesViewPager.VIEW_TYPE_SPEED_DIAL ),
//             Site("Play Games", R.drawable.ic_game_home,  null, "https://magtapp.game.com", TopSitesViewPager.VIEW_TYPE_SPEED_DIAL ),
//             Site("Viral Videos",null,"https://mtapp-resources.s3.ap-south-1.amazonaws.com/android-images/browser/viral_video.webp", "https://fw.tv/magtapp/top-viral-videos.html", TopSitesViewPager.VIEW_TYPE_MAGTAPP_SITE),
//             Site("News Videos",null,"https://mtapp-resources.s3.ap-south-1.amazonaws.com/android-images/browser/viral_news.webp", "https://fw.tv/magtapp/news.html", TopSitesViewPager.VIEW_TYPE_MAGTAPP_SITE),
// //            Site("Times of India",null,"https://magtapp.com/wp_mt_media_uploads/2020/10/times_of_india_VvI9e0xgrK.jpeg", "https://timesofindia.indiatimes.com/", TopSitesViewPager.VIEW_TYPE_MAGTAPP_SITE),
// //            Site("Hindustan Times",null,"https://magtapp.com/wp_mt_media_uploads/2020/10/hindustan_ODZ_jtPRS.png", "https://www.hindustantimes.com/", TopSitesViewPager.VIEW_TYPE_MAGTAPP_SITE),
//             Site("The Hindu",null,"https://magtapp.com/wp_mt_media_uploads/2020/10/the_hindu_LLCzqF1qw.jpg", "https://www.thehindu.com/", TopSitesViewPager.VIEW_TYPE_MAGTAPP_SITE),
//             Site("Speed Test",null,"https://magtapp.com/wp_mt_media_uploads/2020/10/fast_speed_test_-k_3Ih_oC.png", "https://fast.com/", TopSitesViewPager.VIEW_TYPE_MAGTAPP_SITE),
//             Site("DailyHunt",null,"https://magtapp.com/wp_mt_media_uploads/2020/10/dailyhunt_hY6GOUnd6S.png", "https://m.dailyhunt.in/news/india/english", TopSitesViewPager.VIEW_TYPE_MAGTAPP_SITE),
//             Site("Jagran Josh",null,"https://magtapp.com/wp_mt_media_uploads/2020/10/jagran-min_j_7czi__H.jpg", "https://www.jagranjosh.com/", TopSitesViewPager.VIEW_TYPE_MAGTAPP_SITE)
//         )