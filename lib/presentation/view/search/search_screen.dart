// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';

import 'package:browser_app/data/local/search_quick_links.dart';

import '../../../core/constants/color.dart';
import '../../widgets/search/search_quick_links.dart';

class SearchScreen extends StatefulWidget {
  final bool? focusTextfield;
  const SearchScreen({
    Key? key,
    this.focusTextfield = true,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _focusNode = FocusNode();
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.focusTextfield == true) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
    return Scaffold(
      appBar: searchScreenAppBar(_textEditingController),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchScreenQuickLinks(
                tag: "Most Visited", quickLinks: fakeRecentQuickLinks),
            SearchScreenQuickLinks(
                tag: "Shopping", quickLinks: fakeRecentQuickLinks),
            SearchScreenQuickLinks(
                tag: "News", quickLinks: fakeRecentQuickLinks),
          ],
        ),
      ),
    );
  }

  AppBar searchScreenAppBar(TextEditingController _textEditingController) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 80,
      scrolledUnderElevation: 0,
      backgroundColor: colors.white,
      // systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: colors.grey),
      title: TextField(
        focusNode: _focusNode,
        controller: _textEditingController,
        decoration: InputDecoration(
          filled: true,
          hintMaxLines: 1,
          fillColor: colors.homeTextFieldColor,
          hintText: 'Search or type Web address',
          contentPadding:
              const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
          suffixIcon: InkWell(
              onTap: () => logger.info("Mic button pressed"),
              child: const Icon(Icons.mic)),
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
