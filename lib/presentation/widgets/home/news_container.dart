import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/models/news_model.dart';
import '../../../utils/text_utils.dart';
import '../../view/news/news_details_screen.dart';
import '../../viewModel/home_screen_view_model.dart';
import '../../viewModel/news_screen_view_model.dart';
import 'news_widget.dart';

class NewsContainer extends StatelessWidget {
  const NewsContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<News?>(
      future: newsViewModel.getNews(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError || textUtils.isEmpty(snapshot.data.toString())) {
          homeViewModel.reportNewsFetchError(snapshot.error);
          return const Center(child: Text("No News Data"));
        }
        if (snapshot.hasData) {
          return NewsListView(
            snapshot: snapshot,
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class NewsListView extends StatelessWidget {
  const NewsListView({
    super.key,
    required this.snapshot,
  });

  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final News news = snapshot.data as News;
    return ListView.separated(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: news.articles.length,
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemBuilder: (context, index) {
        return NewsTreeWidget(
          index: index,
          news: news,
        );
      },
    );
  }
}

class NewsTreeWidget extends StatelessWidget {
  const NewsTreeWidget({
    super.key,
    required this.index,
    required this.news,
  });

  final int index;
  final News news;

  void pushToDetailNewsScreen(
      {String? title,
      String? description,
      String? link,
      String? image,
      String? content,
      String? author,
      String? publishedAt}) {
    appRouter.push(
      NewsDetailsScreen(
        title: title!,
        image: image!,
        content: content!,
        author: author!,
        publishedAt: publishedAt!,
        link: link!,
        description: description!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String link = news.articles[index].url;
    final String author = news.articles[index].author ?? "Unknown";
    final String content =
        news.articles[index].content ?? "No content provider";
    final String description =
        news.articles[index].description ?? "No description provider";
    final String day = news.articles[index].publishedAt.day.toString();
    final String month = news.articles[index].publishedAt.month.toString();
    final String year = news.articles[index].publishedAt.year.toString();
    final String publishedAt = "$day/$month/$year";
    final String title = news.articles[index].title;
    final String image = news.articles[index].urlToImage ?? newsImageStatic;

    return GestureDetector(
      onTap: () => pushToDetailNewsScreen(
        link: link,
        title: title,
        image: image,
        author: author,
        content: content,
        publishedAt: publishedAt,
        description: description,
      ),
      child: NewsWidget(
        newsImage: image,
        newsTitle: title,
      ),
    );
  }
}
