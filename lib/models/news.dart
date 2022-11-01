import 'package:cloud_firestore/cloud_firestore.dart';

class NewsFeedArticle{
  String title;
  String author;
  String description;
  String url;
  String urlToImage;
  Timestamp publishedAt;
  String content;
  NewsFeedArticle({
    required this.title,
    required this.author,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content
  });

  factory NewsFeedArticle.fromJson(Map<String, dynamic> json) {
    return NewsFeedArticle(
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      urlToImage: json['urlToImage'] as String,
      publishedAt: json['publishedAt'] as Timestamp,
      content: json['content'] as String,
      author: json['author'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'url': url,
    'urlToImage': urlToImage,
    'publishedAt': publishedAt,
    'content': content,
    'author': author,
  };

  static fromMap(Map<String, dynamic> data) {
    return NewsFeedArticle(
      title: data['title'],
      description: data['description'],
      url: data['url'],
      urlToImage: data['urlToImage'],
      publishedAt: data['publishedAt'],
      content: data['content'],
      author: data['author'],
    );
  }

  Map<String, dynamic> toMap() {

    return {
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
      'author': author,
    };
  }
}