import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color.dart';
import '../../../data/local/search_quick_links.dart';
import '../../../data/provider/state_providers.dart';
import '../../viewModel/search_view_model.dart';
import '../../widgets/search/search_quick_links.dart';
import '../../widgets/search/search_suggestions_dialog.dart';

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
    super.dispose();
  }

  void _init() async {
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
    final _showSuggestions = ref.watch(searchScreenShowSuggestionsProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          if (_showSuggestions)
            ShowSuggestionsDialog(
              value: _textEditingController.text,
            ),
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
    final _showSuggestions = ref.watch(searchScreenShowSuggestionsProvider);

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
        onSubmitted: searchScreenViewModel.onSubmitted,
        onChanged: (String _) => searchScreenViewModel.onChanged(ref, _),
        decoration: InputDecoration(
          filled: true,
          hintMaxLines: 1,
          fillColor: colors.homeTextFieldColor,
          hintText: 'Search or type Web address',
          contentPadding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
          suffixIcon: InkWell(
            onTap: () => searchScreenViewModel.onTap(
                ref: ref,
                showSuggestions: _showSuggestions,
                textEditingController: _textEditingController),
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
