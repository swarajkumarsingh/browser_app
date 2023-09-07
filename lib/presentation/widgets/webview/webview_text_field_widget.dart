import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/constants/color.dart';
import '../../view/search/search_screen_webview.dart';

class WebviewTextfieldWidget extends StatelessWidget {
  const WebviewTextfieldWidget({
    super.key,
    required this.searchTextController,
    required this.controller,
    required this.query,
    required this.url,
  });

  final String query;
  final String url;
  final TextEditingController searchTextController;
  final WebViewController? controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        appRouter.push(
          SearchScreenWebview(
            prompt: query == "" ? Uri.parse(url).host : query,
            url: url,
          ),
        );
      },
      child: TextField(
        enabled: false,
        autocorrect: true,
        onChanged: (value) {},
        canRequestFocus: false,
        controller: searchTextController,
        keyboardType: TextInputType.none,
        decoration: InputDecoration(
          filled: true,
          hintMaxLines: 1,
          iconColor: colors.black,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? const Color.fromARGB(255, 83, 32, 172)
              : colors.homeTextFieldColor,
          hintText: 'Search or type Web address',
          contentPadding:
              const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
          prefixIcon: const Icon(Icons.privacy_tip_outlined),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
