import 'dart:convert';
import 'package:flutter_ready_prod/utils/constants.dart';
import 'package:flutter_ready_prod/webservice/Resource2.dart';

class NewsArticle {
  
  final String title; 
  final String descrption; 
  final String urlToImage; 

  NewsArticle({this.title, this.descrption, this.urlToImage});

  factory NewsArticle.fromJson(Map<String,dynamic> json) {
    return NewsArticle(
      title: json['title'], 
      descrption: json['description'], 
      urlToImage: json['urlToImage'] ?? Constants.NEWS_PLACEHOLDER_IMAGE_ASSET_URL
    );
  
}

  static Resource2<List<NewsArticle>> getArticles(bla) {
  
  //static Resource2<List<NewsArticle>> get getArticles {
    
    print("BLA $bla");
    
    return Resource2(
      url: Constants.HEADLINE_NEWS_URL,
      parse: (response) {
        final result = json.decode(response.body); 
        Iterable list = result['articles'];
        return list.map((model) => NewsArticle.fromJson(model)).toList();
      }
    );

  }

}