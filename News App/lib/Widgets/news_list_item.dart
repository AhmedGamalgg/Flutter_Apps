import 'package:app/Models/article_model.dart';
import 'package:flutter/material.dart';

class NewsListItem extends StatelessWidget {
  const NewsListItem({super.key, required this.articleModel});
  final ArticleModel articleModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child:articleModel.image != null ? Image.network(
              articleModel.image!,
              height: 200,
              width: double.infinity,
            ) : Image.network('https://www.vipspatel.com/wp-content/uploads/2017/04/no_image_available_300x300.jpg'),
          ),
          SizedBox(height: 8),
          Text(
            articleModel.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            articleModel.subtitle??'',
            style: TextStyle(color: Colors.grey, fontSize: 10),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
