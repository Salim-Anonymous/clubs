import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/news.dart';

Future<bool> addNews(NewsFeedArticle article){
  final feed = article;
  final db = FirebaseFirestore.instance;

  db
    .collection("news")
    .add({
      "author": feed.author,
      "content": feed.content,
      "description": feed.description,
      "publishedAt": feed.publishedAt,
      "title": feed.title,
      "url": feed.url,
      "urlToImage": feed.urlToImage,
    }).catchError((e) => print(e));

  return Future.value(true);
}

Future<List<NewsFeedArticle>> getNews() async{
  final db = FirebaseFirestore.instance;
  final news = await db.collection("news").get();
  final List<NewsFeedArticle> newsList = [];
  for (var element in news.docs) {
    newsList.add(NewsFeedArticle(
        author: element.data()["author"],
        content: element.data()["content"],
        description: element.data()["description"],
        publishedAt: element.data()["publishedAt"],
        title: element.data()["title"],
        url: element.data()["url"],
        urlToImage: element.data()["urlToImage"],
    ));
  }
  return newsList;
}

Future<bool> deleteNews(String id) async{
  final db = FirebaseFirestore.instance;
  await db.collection("news").doc(id).delete();
  return Future.value(true);
}