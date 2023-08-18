import 'package:browser_app/utils/browser/browser_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';

import '../../../core/constants/color.dart';
import '../../../core/event_tracker/event_tracker.dart';
import '../../../data/local/search_quick_links.dart';
import '../../../utils/text_utils.dart';
import '../../widgets/search/search_quick_links.dart';
import '../../widgets/search/search_suggestions_dialog.dart';
import '../webview/webview_screen.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search-screen';

  final bool focusTextfield;

  const SearchScreen({
    Key? key,
    this.focusTextfield = true,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _showSuggestions = false;
  final FocusNode _focusNode = FocusNode();
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _init() async {
    await eventTracker.screen("search-screen");
  }

  void _showKeyboard(BuildContext context) {
    if (widget.focusTextfield == true) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    _showKeyboard(context);

    return Scaffold(
      appBar: searchScreenAppBar(_textEditingController),
      body: searchScreenBody(),
    );
  }

  SingleChildScrollView searchScreenBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _showSuggestions
              ? ShowSuggestionsDialog(
                  value: _textEditingController.text,
                )
              : const SizedBox(),
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

  AppBar searchScreenAppBar(TextEditingController _textEditingController) {
    void _onChanged(String value) {
      if (value.isEmpty) {
        setState(() {
          _showSuggestions = false;
        });
        return;
      }
      setState(() {
        _showSuggestions = true;
      });
    }

    void _onSubmitted(String prompt) {
      FocusScope.of(context).unfocus();

      // Url
      if (textUtils.promptIsUrl(prompt)) {
        appRouter.push(WebviewScreen(
          url: browserUtils.addHttpToDomain(prompt),
          prompt: "",
        ));
        return;
      }

      // Query
      prompt = textUtils.replaceSpaces(prompt);

      appRouter.push(WebviewScreen(
        url: browserUtils.addQueryToGoogle(prompt),
        prompt: prompt,
      ));
    }

    void _onTap() {
      if (_showSuggestions) {
        _textEditingController.clear();
        setState(() {
          _showSuggestions = false;
        });
      }
    }

    return AppBar(
      elevation: 0,
      leadingWidth: 30,
      toolbarHeight: 80,
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: colors.white,
      title: TextField(
        focusNode: _focusNode,
        onChanged: _onChanged,
        onSubmitted: _onSubmitted,
        controller: _textEditingController,
        decoration: InputDecoration(
          filled: true,
          hintMaxLines: 1,
          fillColor: colors.homeTextFieldColor,
          hintText: 'Search or type Web address',
          contentPadding:
              const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
          suffixIcon: InkWell(
            onTap: _onTap,
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
