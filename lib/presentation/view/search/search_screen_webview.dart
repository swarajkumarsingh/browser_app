import 'package:browser_app/core/common/snackbar/show_snackbar.dart';
import 'package:browser_app/utils/browser/browser_utils.dart';
import 'package:browser_app/utils/clipboard.dart';
import 'package:browser_app/utils/extensions/string_extension.dart';
import 'package:browser_app/utils/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/constants/color.dart';
import '../../../core/event_tracker/event_tracker.dart';
import '../../widgets/search/search_suggestions_dialog.dart';
import '../webview/webview_screen.dart';

class SearchScreenWebview extends StatefulWidget {
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
  State<SearchScreenWebview> createState() => _SearchScreenWebviewState();
}

class _SearchScreenWebviewState extends State<SearchScreenWebview> {
  bool _showSuggestions = false;
  String copiedUrl = "";

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
    _textEditingController.text = widget.url;

    final _copiedUrl = await clipBoard.getData();
    setState(() {
      copiedUrl = _copiedUrl;
    });
    await eventTracker.screen("search-screen-webview", {
      "url": widget.url,
      "prompt": widget.prompt,
    });
  }

  void showKeyboard(BuildContext context) {
    if (widget.focusTextfield == true) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    showKeyboard(context);

    return Scaffold(
      appBar: searchScreenAppBar(),
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
    return ListTile(
      onTap: () => appRouter.push(WebviewScreen(url: copiedUrl)),
      leading: const Icon(FontAwesomeIcons.globe, size: 20),
      contentPadding: const EdgeInsets.only(left: 12, right: 10),
      title: const Text(
        "Link you copied",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
      
      subtitle: Text(
        textUtils.isEmpty(copiedUrl) ? widget.url : copiedUrl,
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
      title: Text(
        "${widget.prompt.capitalize} - Google Search",
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
            IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
            IconButton(
              onPressed: () async {
                await clipBoard.setData(widget.url);
                setState(() {
                  copiedUrl = widget.url;
                });
                showSnackBar("Copied to Clipboard");
              },
              icon: const Icon(Icons.copy),
            ),
            IconButton(
              onPressed: () {
                showKeyboard(context);
              },
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }

  AppBar searchScreenAppBar() {
    void _onChanged(String value) {
      if (textUtils.isEmpty(value)) {
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
      }
    }

    return AppBar(
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 80,
      leadingWidth: 30,
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
