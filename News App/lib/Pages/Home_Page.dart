import 'package:app/Pages/business_page.dart';
import 'package:app/Pages/entertainment_page.dart';
import 'package:app/Pages/health_page.dart';
import 'package:app/Pages/science_page.dart';
import 'package:app/Pages/sports_page.dart';
import 'package:app/Pages/technology_page.dart';
import 'package:app/Widgets/category_Listview.dart';
import 'package:app/Models/category_model.dart';
import 'package:app/Widgets/news_listView._builder.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String category;
  final List<CategoryModel> item = [
    CategoryModel(
        name: 'Business',
        image: 'assets/business.png',
        page: () => BusinessPage()),
    CategoryModel(
        name: 'Entertainment',
        image: 'assets/entertaiment.png',
        page: () => EntertainmentPage()),
    CategoryModel(
        name: 'Health', image: 'assets/health.png', page: () => HealthPage()),
    CategoryModel(
        name: 'Science',
        image: 'assets/science.png',
        page: () => SciencePage()),
    CategoryModel(
        name: 'Sports', image: 'assets/sports.png', page: () => SportsPage()),
    CategoryModel(
        name: 'Technology',
        image: 'assets/technology.jpeg',
        page: () => TechnologyPage()),
    CategoryModel(
        name: 'General', image: 'assets/general.png', page: () => HomePage(category: "general",)),
  ];
  HomePage({super.key, required this.category});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'News',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Cloud',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: CategoryListview(itemList: item)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
            NewsGenerator(
              category: category,
            ),
          ],
        ),
      ),
    );
  }
}
