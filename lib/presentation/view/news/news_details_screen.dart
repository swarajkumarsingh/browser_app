import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/common/snackbar/show_snackbar.dart';
import '../../../core/common/widgets/drop_menu.dart';
import '../../../domain/enums/tts_status_enums.dart';
import '../../../utils/tts.dart';
import '../../widgets/news/news_widgets.dart';

class NewsDetailsScreen extends StatefulWidget {
  const NewsDetailsScreen(
      {super.key,
      required this.image,
      required this.title,
      required this.description,
      required this.link,
      required this.author,
      required this.publishedAt,
      required this.content});

  final String author;
  final String content;
  final String description;
  final String image;
  final String link;
  final String publishedAt;
  final String title;

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}


class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  PlayStatus _status = PlayStatus.paused;

  @override
  void initState() {
    tts.init();
    super.initState();
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  IconData _getIcon() {
    switch (_status) {
      case PlayStatus.playing:
        return Icons.pause;
      case PlayStatus.paused:
      default:
        return Icons.play_arrow;
    }
  }

  Future<void> shareApp() async {
    try {
      const url = "https://github.com/swarajkumarsingh/browser_app";
      await Share.share("Share this app $url");
    } catch (e) {
      showSnackBar("Unable to share, Please try again later.");
    }
  }

  void _toggleStatus() {
    setState(() {
      _status = _status == PlayStatus.playing
          ? PlayStatus.paused
          : PlayStatus.playing;
    });
  }

  Future<void> _toggleIconWhenAudioCompleted() async {
    tts.getTTS.setCompletionHandler(() async {
      await tts.stop();
      _toggleStatus();
    });
  }

  Future<void> _startNewsAudioImpl() async {
    final String content =
        "${widget.title}.  ${widget.description} news reported by ${widget.author} more on this news click the link below";

    _toggleStatus();
    await tts.speak(content);
  }

  Future<void> _startNewsAudio() async {
    if (_status == PlayStatus.playing) {
      await tts.pause();
      return _toggleStatus();
    }

    await _toggleIconWhenAudioCompleted();

    await _startNewsAudioImpl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black),
        ),
        leading: InkWell(
          onTap: () => appRouter.pop(),
          child: const Icon(
            Icons.keyboard_backspace_outlined,
            size: 30,
            color: Colors.black,
          ),
        ),
        actions: [
          InkWell(
            onTap: () async => await shareApp(),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              child: const Icon(
                Icons.share_outlined,
                size: 25,
                color: Colors.black,
              ),
            ),
          ),
          const DropMenu(),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NewsImageWidget(widget: widget),
              const SizedBox(height: 20),
              NewsTitleWidget(widget: widget),
              const SizedBox(height: 20),
              NewsPublishedAtWidget(widget: widget),
              NewsAuthorWidget(widget: widget),
              const SizedBox(height: 20),
              NewsDescWidget(widget: widget),
              const Divider(),
              MoreOnThisNewsWidget(widget: widget)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Speak"),
        tooltip: "Speak",
        backgroundColor: const Color.fromARGB(255, 198, 197, 197),
        onPressed: () async => _startNewsAudio(),
        icon: Icon(_getIcon(), color: Colors.black),
      ),
    );
  }
}
