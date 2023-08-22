// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:browser_app/core/dio/api.dart';
import 'package:browser_app/domain/models/download/download_request_model.dart';
import 'package:browser_app/domain/repository/webview_repository.dart';
import 'package:browser_app/utils/browser/browser_constants.dart';
import 'package:browser_app/utils/clipboard.dart';
import 'package:browser_app/utils/text_utils.dart';

import '../../core/common/snackbar/show_snackbar.dart';
import '../../core/common/widgets/toast.dart';
import '../../domain/models/webview/url_data_model.dart';
import '../../presentation/widgets/webview/download_dialog.dart';
import '../download/downloader.dart';
import '../download/downloader_constants.dart';

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

  Future<NavigationDecision> onNavigationRequest({
    required NavigationRequest request,
    required BuildContext context,
    required TextEditingController fileNameController,
    required bool mounted,
  }) async {
    await clipBoard.setData(request.url);
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
      fileSize: "0",
      context: context,
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

  Future<UrlData> getUrlData(String url) async {
    try {
      final res = await webviewRepository.getUrlData(url: url);

      if (!res.successBool ||
          textUtils.isEmpty(res.data!.contentType) ||
          textUtils.isEmpty(res.data!.size)) {
        return UrlData(success: false, url: "", size: "", contentType: "");
      }

      return UrlData(
        success: res.successBool,
        url: url,
        size: res.data!.size,
        contentType: res.data!.contentType,
      );
    } catch (e) {
      return UrlData(success: false, url: "", size: "", contentType: "");
    }
  }

  String getImageSizeInMB(String value) {
    try {
      final int number = int.parse(value);
      final double result = number / 1048576;
      final String formattedResult = result.toStringAsFixed(2);
      return formattedResult;
    } catch (_) {
      return "0";
    }
  }

  String getImageSizeInKB(String value) {
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
    final a = newUri.toString().replaceAll("?", "");
    return a;
  }

  DownloadedRequestModel _checkUrlEndsWithAnyExtension(
      String url, List<String> extensions) {
    for (final extension in extensions) {
      if (url.contains(extension)) {
        final _ = extension.replaceAll(".", "");
        return DownloadedRequestModel(
            isDownloadRequest: true, fileExtension: _);
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
      final response = await Api().head(url);

      final contentType = response.headers.value("content-type") ?? "";

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
