import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/models/newsArticle.dart';
import 'package:flutter_ready_prod/utils/constants.dart';
import 'package:flutter_ready_prod/webservice/Webservice2.dart';

class NewsList extends StatefulWidget {

  @override
  createState() => NewsListState(); 
}

class NewsListState extends State<NewsList> {

  // ignore: deprecated_member_use
  List<NewsArticle> _newsArticles = List<NewsArticle>(); 

  @override
  void initState() {
    super.initState();
    _populateNewsArticles(); 
  }

  void _populateNewsArticles() {
   
    Webservice2().load(NewsArticle.getArticles('bla')).then((newsArticles) => {
      setState(() => {
        _newsArticles = newsArticles
      })
    });

  }

  ListTile _buildItemsForListView(BuildContext context, int index) {
      return ListTile(
        title: _newsArticles[index].urlToImage == null ? Image.asset(Constants.NEWS_PLACEHOLDER_IMAGE_ASSET_URL) : Image.network(_newsArticles[index].urlToImage), 
        subtitle: Text(_newsArticles[index].title, style: TextStyle(fontSize: 18)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('News'),
        ),
        body: ListView.builder(
          itemCount: _newsArticles.length,
          itemBuilder: _buildItemsForListView,
        )
      );
  }
}