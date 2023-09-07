// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/common/snackbar/show_snackbar.dart';
import '../../core/common/widgets/toast.dart';
import '../../domain/models/download_request_model.dart';
import '../../domain/repository/webview_repository.dart';
import '../../presentation/widgets/webview/webview_download_dialog.dart';
import '../download/downloader.dart';
import '../download/downloader_constants.dart';
import '../text_utils.dart';
import 'browser_constants.dart';

final browserUtils = _BrowserUtils();

class _BrowserUtils {
  String addHttpToDomain(String domain) {
    if (domain.contains("https://")) {
      return domain;
    }
    return "http://${domain.toLowerCase()}";
  }

  bool urlIsSecure(Uri url) {
    return (url.scheme == "https") || isLocalizedContent(url);
  }

  bool isAndroid() {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  }

  bool isIOS() {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  }

  bool isLocalizedContent(Uri url) {
    return (url.scheme == "file" ||
        url.scheme == "chrome" ||
        url.scheme == "data" ||
        url.scheme == "javascript" ||
        url.scheme == "about");
  }

  String addQueryToGoogle(String prompt) {
    return "https://www.google.com/search?q=$prompt";
  }

  String addQueryToBing(String prompt) {
    return "https://www.bing.com/search?q=$prompt";
  }

  bool isDataURL(String keyword) {
    return keyword.contains("data:image");
  }

  bool containsBlockedUrl(String url) {
    for (final site in browserConstants.blockedSites) {
      return url == site;
    }
    return false;
  }

  Future<NavigationDecision> onNavigationRequest({
    required NavigationRequest request,
    required TextEditingController fileNameController,
    required bool mounted,
  }) async {
    if (containsBlockedUrl(request.url)) {
      showSnackBar("Site blocked my admin");
      return NavigationDecision.prevent;
    }

    final downloadRequest = await browserUtils.isDownloadRequest(request.url);

    if (!downloadRequest.isDownloadRequest) {
      return NavigationDecision.navigate;
    }

    if (textUtils.isEmpty(downloadRequest.fileExtension)) {
      logger.error("Unable to download the file");
      return NavigationDecision.prevent;
    }

    final downloadDir = await downloaderConstants.getDownloadDir();

    showDownloadDialog(
      fileSize: 0,
      controller: fileNameController,
      fileType: downloadRequest.fileExtension!,
      storageLocation: downloadDir,
      function: () async {
        final res = await downloader.downloadFile(
          url: request.url,
          imageContentType: downloadRequest.fileExtension!,
          savedDir: downloadDir,
          fileName: fileNameController.text,
        );

        if (!res.success) {
          showSnackBar(res.message);
          return;
        }

        showToast(res.message);

        if (mounted) appRouter.pop();
        return;
      },
    );
    return NavigationDecision.prevent;
  }

  String calculateImageSizeInMB(String value) {
    try {
      final int number = int.parse(value);
      final double result = number / 1048576;
      final String formattedResult = result.toStringAsFixed(2);
      return formattedResult;
    } catch (_) {
      return "0";
    }
  }

  Future<String> imageSizeInMb(String url) async {
    final res = await webviewRepository.getUrlSize(url: url);
    return "$res MB";
  }

  String calculateImageSizeInKB(String value) {
    try {
      final int number = int.parse(value);
      final double result = number / 1024;
      final String formattedResult = result.toStringAsFixed(2);
      return formattedResult;
    } catch (_) {
      return "0";
    }
  }

  Future<DownloadedRequestModel> isDownloadRequest(String url) async {
    DownloadedRequestModel result =
        _checkUrlEndsWithAnyExtension(url, browserConstants.fileExtensions);
    if (result.isDownloadRequest) {
      return DownloadedRequestModel(
          isDownloadRequest: true, fileExtension: result.fileExtension);
    }

    // check if the url contains specific keyword
    result = _checkForKeywordsInUrl(url);
    if (result.isDownloadRequest) {
      return DownloadedRequestModel(
          isDownloadRequest: true, fileExtension: result.fileExtension);
    }

    // check the headers of the url
    result = await checkIfUrlContainsDownloadableHeader(url);
    if (result.isDownloadRequest) {
      return DownloadedRequestModel(
          isDownloadRequest: true, fileExtension: result.fileExtension);
    }

    return DownloadedRequestModel(
        isDownloadRequest: false, fileExtension: null);
  }

  String removeQueryFromUrl(String url) {
    final Uri uri = Uri.parse(url);
    final Uri newUri = uri.replace(queryParameters: {});
    final value = textUtils.replaceQuestionMarkWithSpace(newUri.toString());
    return value;
  }

  DownloadedRequestModel _checkUrlEndsWithAnyExtension(
      String url, List<String> extensions) {
    for (final extension in extensions) {
      if (url.contains(extension)) {
        final fileExtension = textUtils.replaceDotWithSpace(extension);
        return DownloadedRequestModel(
            isDownloadRequest: true, fileExtension: fileExtension);
      }
    }
    return DownloadedRequestModel(
        isDownloadRequest: false, fileExtension: null);
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

  DownloadedRequestModel _checkForKeywordsInUrl(String url) {
    final found =
        hashSearch(searchItem: url, sortedList: browserConstants.keywords);
    if (!found) {
      return DownloadedRequestModel(
          isDownloadRequest: false, fileExtension: null);
    }
    final extension = _getExtensionFromGoogleImageProvider(url);
    return DownloadedRequestModel(
        isDownloadRequest: true, fileExtension: extension);
  }

  String _getExtensionFromGoogleImageProvider(String url) {
    final List<String> parts = url.split(',');
    final String mimeType = parts[0].split(':')[1];
    final String extensionWithBase = mimeType.split('/')[1];
    final String extension = extensionWithBase.replaceAll(";base64", "");
    return extension;
  }

  bool containsBlockedSites(String url) {
    for (final site in browserConstants.blockedSites) {
      return url.startsWith(site);
    }
    return false;
  }

  Future<DownloadedRequestModel> checkIfUrlContainsDownloadableHeader(
      String url) async {
    try {
      final response = await webviewRepository.getUrlData(url: url);

      if (!response.successBool) {
        return DownloadedRequestModel(
            isDownloadRequest: false, fileExtension: null);
      }

      final contentType = response.data!.headers.value("content-type") ?? "";

      for (final key in browserConstants.fileExtensionWithContentType.keys) {
        if (contentType == key) {
          return DownloadedRequestModel(
            isDownloadRequest: true,
            fileExtension: browserConstants.fileExtensionWithContentType[key],
          );
        }
      }

      return DownloadedRequestModel(
          isDownloadRequest: false, fileExtension: null);
    } catch (error) {
      return DownloadedRequestModel(
          isDownloadRequest: false, fileExtension: null);
    }
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
