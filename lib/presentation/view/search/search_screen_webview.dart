import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/constants/color.dart';
import '../../../data/provider/state_providers.dart';
import '../../../utils/functions/functions.dart';
import '../../../utils/text_utils.dart';
import '../../viewModel/search_screen_view_model.dart';
import '../../viewModel/search_screen_webview_view_model.dart';
import '../../widgets/search/search_text_field_widget.dart';

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
      title: SearchScreenTextfieldWidget(
          textEditingController: _textEditingController,
          ref: ref,
          context: context,
          mounted: mounted),
    );
  }
}
