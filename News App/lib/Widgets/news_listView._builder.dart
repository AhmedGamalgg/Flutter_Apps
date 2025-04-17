import 'package:app/Models/article_model.dart';
import 'package:app/Services/APi_Request.dart';
import 'package:app/Widgets/Centered_sliver_child.dart';
import 'package:app/Widgets/Error_message_widget.dart';
import 'package:app/Widgets/news_listView.dart';
import 'package:flutter/material.dart';

class NewsGenerator extends StatefulWidget {
  const NewsGenerator({super.key, required this.category});
  final String category;
  @override
  State<NewsGenerator> createState() => _NewsGeneratorState();
}

class _NewsGeneratorState extends State<NewsGenerator> {
  var future;

  @override
  void initState() {
    super.initState();
    future = ApiRequest().GetTopNews( category:widget.category );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArticleModel>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return NewsListView(news: snapshot.data!);
          } else if (snapshot.hasError) {
            return const CenteredSliverChild(child: ErrorMessageWidget());
          } else {
            return const CenteredSliverChild(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

//-----------------------------------------------------------------------------------------//
// class NewsGenerator extends StatefulWidget {
//   const NewsGenerator({super.key});

//   @override
//   State<NewsGenerator> createState() => _NewsGeneratorState();
// }

// class _NewsGeneratorState extends State<NewsGenerator> {
//   List<ArticleModel> news = [];

//   bool isloading = true;

//   @override
//   void initState() {
//     super.initState();
//     generalNews(); // ignore all the function until it recives the request the rebuild it.
//   }

//   Future<void> generalNews() async {
//     news = await ApiRequest().GetNews();
//     isloading = false;
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isloading
//         ? SliverToBoxAdapter(
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height *
//                   0.5, // Adjust height to center it properly
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//           )
//         : news.isEmpty
//             ? SliverToBoxAdapter(
//                 child: SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.5,
//                     child: Center(
//                         child: Text(
//                       'Oops, There was an error try again later!',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ))),
//               )
//             : NewsListView(news: news);
//   }
// }
