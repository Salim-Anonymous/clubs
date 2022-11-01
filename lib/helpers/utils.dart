import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubs/models/news.dart';

import '../models/club.dart';

class Utils {

  static List<NewsFeedArticle> parseNews(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<NewsFeedArticle>((json) => NewsFeedArticle.fromJson(json))
        .toList();
  }

  static String encodeNewsFeedArticle(NewsFeedArticle news) {
    return json.encode(news.toJson());
  }

  static List<NewsFeedArticle> getNewsFeedArticles() {
    List<NewsFeedArticle> newsFeedArticles = [];
    newsFeedArticles.addAll([
      NewsFeedArticle(
          author: "Mark Zuckerberg",
          title: "Metaverse",
          description: "",
          url: "/1",
          urlToImage:
              "https://w7.pngwing.com/pngs/295/423/png-transparent-mark-zuckerberg-facebook-founder-harvard-university-chief-executive-mark-zuckerberg-tshirt-celebrities-face.png",
          publishedAt: Timestamp.now(),
          content:
              "In futurism and science fiction, the metaverse is a hypothetical iteration of the Internet as a single, universal and immersive virtual world that is facilitated by the use of virtual reality and augmented reality headsets. In colloquial use, a metaverse is a network of 3D virtual worlds focused on social connection."),
      NewsFeedArticle(
          author: "Elon Musk",
          title: "SpaceX",
          description: "",
          url: "/2",
          urlToImage:
              "https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Elon_Musk_Royal_Society_%28crop1%29.jpg/1200px-Elon_Musk_Royal_Society_%28crop1%29.jpg",
          publishedAt: Timestamp.now(),
          content:
              "SpaceX designs, manufactures and launches advanced rockets and spacecraft. The company was founded in 2002 to revolutionize space technology, with the ultimate goal of enabling people to live on other planets."),
    ]);

    return newsFeedArticles;
  }

  static List<Club> getClubs(){
    List<Club> clubs = [];

    clubs.addAll([
      Club(
        moderators: ["1", "2"],
        name: "RUB ACM Chapter",
        description: "CAMS is the best club in the world",
        urlToImage: "assets/logo/logo-no-background.png",
        createdAt: Timestamp.now(),
        cid: '1',
        hasJoined: true,
        noOfMembers: 0,
        maxMembers: 10,
      ),
      Club(
        moderators: [],
        name: "Bhutan Kidney Foundation",
        description: "CAMS is the best club in the world",
        urlToImage: "assets/logo/logo-no-background.png",
        createdAt: Timestamp.now(),
        cid: '1',
        hasJoined: false,
        noOfMembers: 0,
        maxMembers: 10,
      ),
    ]);
    return clubs;
  }
}
