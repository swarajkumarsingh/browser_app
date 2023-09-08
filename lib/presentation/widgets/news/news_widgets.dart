import 'package:flutter/material.dart';

import '../../view/news/news_details_screen.dart';

class NewsImageWidget extends StatelessWidget {
  const NewsImageWidget({
    super.key,
    required this.widget,
  });

  final NewsDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Image.network(widget.image),
    );
  }
}

class NewsTitleWidget extends StatelessWidget {
  const NewsTitleWidget({
    super.key,
    required this.widget,
  });

  final NewsDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.title,
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class NewsPublishedAtWidget extends StatelessWidget {
  const NewsPublishedAtWidget({
    super.key,
    required this.widget,
  });

  final NewsDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return Text(
      "Date: ${widget.publishedAt}",
      style:
          const TextStyle(color: Color.fromARGB(255, 81, 81, 81), fontSize: 15),
    );
  }
}

class NewsAuthorWidget extends StatelessWidget {
  const NewsAuthorWidget({
    super.key,
    required this.widget,
  });

  final NewsDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return Text(
      "Author: ${widget.author}",
      style:
          const TextStyle(color: Color.fromARGB(255, 81, 81, 81), fontSize: 15),
    );
  }
}

class NewsDescWidget extends StatelessWidget {
  const NewsDescWidget({
    super.key,
    required this.widget,
  });

  final NewsDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.description,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class MoreOnThisNewsWidget extends StatelessWidget {
  const MoreOnThisNewsWidget({
    super.key,
    required this.widget,
  });

  final NewsDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // TODO
      // onTap: () => urlLauncher.launchURL(widget.link),
      child: RichText(
        text: TextSpan(
          text: 'More on this news: ',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: widget.link,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
