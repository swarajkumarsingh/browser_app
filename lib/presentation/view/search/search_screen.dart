import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/search_quick_links.dart';
import '../../../data/provider/state_providers.dart';
import '../../viewModel/search_screen_view_model.dart';
import '../../widgets/search/search_quick_links.dart';
import '../../widgets/search/search_text_field.dart';

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
      appBar: appBar(),
      body: body(),
    );
  }

  SingleChildScrollView body() {
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

  AppBar appBar() {
    final listening = ref.watch(toggleMicIconProvider);
    return AppBar(
      elevation: 0,
      leadingWidth: 30,
      toolbarHeight: 80,
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        MicIconWidget(ref: ref, listening: listening),
      ],
      title: SearchScreenTextFieldWidget(
        ref: ref,
        context: context,
        textEditingController: _textEditingController,
      ),
    );
  }
}

class MicIconWidget extends StatelessWidget {
  const MicIconWidget({
    super.key,
    required this.ref,
    required this.listening,
  });

  final WidgetRef ref;
  final bool listening;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(!listening ? Icons.mic_rounded : Icons.stop_circle_rounded),
      onPressed: () async => searchScreenViewModel.onTap(ref: ref),
    );
  }
}
