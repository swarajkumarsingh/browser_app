import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml/xml.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/constants/color.dart';
import '../../../data/provider/state_providers.dart';
import '../../../utils/functions/functions.dart';
import '../../../utils/text_utils.dart';
import '../../viewModel/search_screen_view_model.dart';
import '../../viewModel/search_screen_webview_view_model.dart';
import '../../widgets/search/search_suggestions_dialog.dart';

class SearchScreenWebview extends ConsumerStatefulWidget {
  static const String routeName = '/search-screen-webview';

  final String url;
  final String prompt;
  final bool focusTextfield;

  const SearchScreenWebview({
    Key? key,
    this.focusTextfield = true,
    required this.prompt,
    required this.url,
  }) : super(key: key);

  @override
  ConsumerState<SearchScreenWebview> createState() =>
      _SearchScreenWebviewState();
}

class _SearchScreenWebviewState extends ConsumerState<SearchScreenWebview> {
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _init() async {
    _textEditingController.text = widget.url;

    await Future(() async {
      ref.read(clipBoardProvider.notifier).update((state) => "");
    });

    await searchScreenWebviewViewModel.logScreen(widget.url, widget.prompt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchScreenAppBar2(),
      body: searchScreenBody(),
    );
  }

  SingleChildScrollView searchScreenBody() {
    final _showSuggestions =
        ref.watch(searchScreenWebviewShowSuggestionsProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          if (_showSuggestions)
            ShowSuggestionsDialog(
              value: _textEditingController.text,
            ),
          Column(
            children: [
              recentSearchListTile(),
              const Divider(),
              copiedTextListTile(),
            ],
          ),
        ],
      ),
    );
  }

  ListTile copiedTextListTile() {
    final clipBoardText = ref.watch(clipBoardProvider);
    return ListTile(
      onTap: () {
        functions.navigateToWebviewScreen(
          ref: ref,
          url: clipBoardText,
          mounted: true,
        );
      },
      leading: const Icon(FontAwesomeIcons.globe, size: 20),
      contentPadding: const EdgeInsets.only(left: 12, right: 10),
      title: const Text(
        "Link you copied",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
      subtitle: Text(
        textUtils.isEmpty(clipBoardText) ? widget.url : clipBoardText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
    );
  }

  ListTile recentSearchListTile() {
    return ListTile(
      leading: const Icon(FontAwesomeIcons.google, size: 20),
      contentPadding: const EdgeInsets.only(left: 12, right: 10),
      onTap: () => appRouter.pop(),
      title: Text(
        "${widget.prompt} - Google Search",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
      subtitle: Text(
        widget.url,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
      trailing: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () async =>
                    searchScreenWebviewViewModel.shareUrl(widget.url),
                icon: const Icon(Icons.share)),
            IconButton(
              onPressed: () => searchScreenWebviewViewModel
                  .updateClipBoardState(ref, widget.url),
              icon: const Icon(Icons.copy),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }

   AppBar searchScreenAppBar2() {
    final listening = ref.watch(toggleMicIconProvider);

    return AppBar(
      elevation: 0,
      leadingWidth: 30,
      toolbarHeight: 80,
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: colors.white,
      actions: [
        IconButton(
            icon: Icon(
                !listening ? Icons.mic_rounded : Icons.stop_circle_rounded),
            onPressed: () async =>
                searchScreenViewModel.onTap(ref: ref, context: context)),
      ],
      title: TypeAheadField<String>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: _textEditingController,
          onChanged: (value) {},
          onSubmitted: (String _) => functions.popToWebviewScreen(
              ref: ref, context: context, url: _, mounted: mounted),
          decoration: InputDecoration(
            filled: true,
            hintMaxLines: 1,
            fillColor: colors.homeTextFieldColor,
            hintText: 'Search or type Web address',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
            suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () async =>
                    searchScreenViewModel.onTap(ref: ref, context: context)),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
        ),
        suggestionsCallback: (keyword) async {
          if (textUtils.isEmpty(keyword)) {
            return [];
          }
          return await fetchSuggestions(keyword);
        },
        onSuggestionSelected: (String value) =>
            searchScreenViewModel.onSubmitted(ref, value),
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
      ),
    );
  }

  
  Future<List<String>> fetchSuggestions(String keyword) async {
    final response = await Dio().get(
        "http://google.com/complete/search?q=$keyword&output=toolbar",
        options: Options(contentType: "text/xml"));

    if (response.statusCode == 200) {
      final responseBody = response.data;
      final xmlDocument = XmlDocument.parse(responseBody);

      logger.success(xmlDocument);

      final suggestions = xmlDocument.findAllElements('suggestion');
      return suggestions
          .map((element) => element.getAttribute('data') ?? '')
          .toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  AppBar searchScreenAppBar() {
    final _showSuggestions =
        ref.watch(searchScreenWebviewShowSuggestionsProvider);

    return AppBar(
      elevation: 0,
      leadingWidth: 30,
      toolbarHeight: 80,
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: colors.white,
      title: TextField(
        autofocus: false,
        controller: _textEditingController,
        onChanged: (String _) => searchScreenWebviewViewModel.onChanged(ref, _),
        onSubmitted: (String _) => functions.popToWebviewScreen(ref: ref, context: context, url: _, mounted: mounted),
        decoration: InputDecoration(
          filled: true,
          hintMaxLines: 1,
          fillColor: colors.homeTextFieldColor,
          hintText: 'Search or type Web address',
          contentPadding:
              const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
          suffixIcon: InkWell(
            onTap: () => searchScreenWebviewViewModel.onTap(
                ref, context, _showSuggestions, _textEditingController),
            child: Icon(!_showSuggestions ? Icons.mic : Icons.clear_outlined),
          ),
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
