import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebViewModel {
  final String url;
  final int tabIndex;
  final String title;
  final bool isIncognitoMode;
  final Uint8List? screenshot;
  WebViewModel({
    required this.url,
    required this.tabIndex,
    required this.title,
    required this.isIncognitoMode,
    required this.screenshot,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'tabIndex': tabIndex,
      'title': title,
      'isIncognitoMode': isIncognitoMode,
      'screenshot': screenshot,
    };
  }

  factory WebViewModel.fromMap(Map<String, dynamic> map) {
    return WebViewModel(
      url: map['url'] as String,
      tabIndex: map['tabIndex'] as int,
      title: map['title'] as String,
      isIncognitoMode: map['isIncognitoMode'] as bool,
      screenshot: map['screenshot'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WebViewModel.fromJson(String source) =>
      WebViewModel.fromMap(json.decode(source) as Map<String, dynamic>);

  WebViewModel copyWith({
    String? url,
    int? tabIndex,
    String? title,
    bool? isIncognitoMode,
    Uint8List? screenshot,
  }) {
    return WebViewModel(
      url: url ?? this.url,
      tabIndex: tabIndex ?? this.tabIndex,
      title: title ?? this.title,
      isIncognitoMode: isIncognitoMode ?? this.isIncognitoMode,
      screenshot: screenshot ?? this.screenshot,
    );
  }
}

class WebviewModelNotifier extends StateNotifier<WebViewModel> {
  WebviewModelNotifier(super._state);

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateScreenshot(Uint8List? screenshot) {
    state = state.copyWith(screenshot: screenshot);
  }

  void updateTitleUrlImageScreenshot(
      {required String url,
      required String title,
      required Uint8List? screenshot}) {
    state = state.copyWith(url: url, title: title, screenshot: screenshot);
  }

  void updateIsIncognitoMode(bool b) {
    state = state.copyWith(isIncognitoMode: b);
  }
}
