import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleViewPage extends StatefulWidget {
  final String articleUrl;

  const ArticleViewPage({
    super.key,
    required this.articleUrl,
  });

  @override
  State<ArticleViewPage> createState() => _ArticleViewPageState();
}

class _ArticleViewPageState extends State<ArticleViewPage> {
  late WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.articleUrl));
  }

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
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Add share functionality here
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
