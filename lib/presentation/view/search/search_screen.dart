// ignore_for_file: unused_element, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../core/constants/color.dart';
import '../../../data/local/search_quick_links.dart';
import '../../viewModel/search_view_model.dart';
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
  String _lastWords = '';
  bool listening = false;
  final _speechToText = SpeechToText();

  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _lastWords = "";
    listening = false;
    _speechToText.stop();
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    await _speechToText.initialize();
    await searchScreenViewModel.initSpeechText(ref);
    await searchScreenViewModel.logScreen();
  }

  Future<void> _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {});
    logger.success(_lastWords);
    await searchScreenViewModel.onSubmitted(_lastWords);
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  void toggle() {
    if (listening == true) {
      setState(() {
        listening = false;
      });
      return;
    }
    setState(() {
      listening = true;
    });
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
          contentPadding:
              const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
          suffixIcon: IconButton(
              icon: Icon(
                  !listening ? Icons.mic_rounded : Icons.stop_circle_rounded),
              onPressed: () async {
                if (await _speechToText.hasPermission &&
                    _speechToText.isAvailable &&
                    _speechToText.isNotListening) {
                  await _startListening();
                  toggle();
                } else if (_speechToText.isListening) {
                  await _stopListening();
                  toggle();
                } else {
                  await _speechToText.initialize();
                }
              }),
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
