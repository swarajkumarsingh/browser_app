// ignore_for_file: depend_on_referenced_packages

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xml/xml.dart';

import '../../../core/constants/color.dart';
import '../../../data/local/search_quick_links.dart';
import '../../../data/provider/state_providers.dart';
import '../../../utils/text_utils.dart';
import '../../viewModel/search_screen_view_model.dart';
import '../../widgets/search/search_quick_links.dart';

class SearchScreen extends ConsumerStatefulWidget {
  static const String routeName = '/search-screen';

  final bool focusTextfield;

  const SearchScreen({
    Key? key,
    this.focusTextfield = true,
  }) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    searchScreenViewModel.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    await searchScreenViewModel.init();
    await searchScreenViewModel.logScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchScreenAppBar(),
      body: searchScreenBody(),
    );
  }

  SingleChildScrollView searchScreenBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              SearchScreenQuickLinks(
                  tag: "Most Visited", quickLinks: fakeRecentQuickLinks),
              SearchScreenQuickLinks(
                  tag: "Shopping", quickLinks: fakeRecentQuickLinks),
              SearchScreenQuickLinks(
                  tag: "News", quickLinks: fakeRecentQuickLinks),
            ],
          ),
        ],
      ),
    );
  }

   AppBar searchScreenAppBar() {
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
          onSubmitted: (value) => searchScreenViewModel.onSubmitted(ref, value),
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
}
      // title: TextField(
      //   autofocus: false,
      //   controller: _textEditingController,
      //   onSubmitted: searchScreenViewModel.onSubmitted,
      //   onChanged: (String _) => searchScreenViewModel.onChanged(ref, _),
      //   decoration: InputDecoration(
      //     filled: true,
      //     hintMaxLines: 1,
      //     fillColor: colors.homeTextFieldColor,
      //     hintText: 'Search or type Web address',
      //     contentPadding:
      //         const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
      //     suffixIcon: IconButton(
      //         icon: Icon(
      //             !listening ? Icons.mic_rounded : Icons.stop_circle_rounded),
      //         onPressed: () async =>
      //             searchScreenViewModel.onTap(ref: ref, context: context)),
      //     border: const OutlineInputBorder(
      //       borderSide: BorderSide.none,
      //       borderRadius: BorderRadius.all(
      //         Radius.circular(8),
      //       ),
      //     ),
      //   ),
      // ),
//     );
//   }
// }
