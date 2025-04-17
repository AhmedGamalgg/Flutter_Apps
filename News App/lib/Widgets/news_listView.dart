import 'package:app/Models/article_model.dart';
import 'package:app/Widgets/news_list_item.dart';
import 'package:flutter/material.dart';

class NewsListView extends StatelessWidget {
  List<ArticleModel> news = [];
  NewsListView({super.key,required this.news});


  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: news.length,
        (context, index) {
          return NewsListItem(
            articleModel: news[index],
          );
        },
      ),
    );
    
  }
}
