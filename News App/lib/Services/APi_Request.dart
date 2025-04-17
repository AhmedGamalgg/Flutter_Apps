import 'package:app/Models/article_model.dart';
import 'package:dio/dio.dart';

class ApiRequest {
  final dio = Dio();

  Future<List<ArticleModel>> GetTopNews({required String category}) async {
    try {
      final Response response = await dio.get(
          'https://newsapi.org/v2/top-headlines?category=$category&apiKey=cce4d2697ec742d69cdba4c56d449377');
      final Map<String, dynamic> jsonData = response.data;
      final List<dynamic> articles = jsonData['articles'];
      final List<ArticleModel> articleList = [];
      for (var article in articles) {
        ArticleModel articleModel = ArticleModel(
            image: article['urlToImage'],
            title: article['title'],
            subtitle: article['description']);
        articleList.add(articleModel);
      }
      return articleList;
    } catch (e) {
      throw Exception();
    }
  }
}
