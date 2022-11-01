import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../helpers/utils.dart';
import '../../models/news.dart';

class NewsFeed extends StatefulWidget {
  const NewsFeed({Key? key}) : super(key: key);

  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {

  final List<NewsFeedArticle> feeds =[];

  @override
  void initState() {
    super.initState();

    // get all the news feed and add to the feeds array
    FirebaseFirestore.instance.collection('news').get().then((value) {

      setState(() {
        feeds.addAll(value.docs.map((e) => NewsFeedArticle.fromMap(e.data())));
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News Feeds", style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5,
        leading: null,
      ),
      body: ListView.builder(
        itemCount: feeds.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.all(6),
                  child:
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: Image.network(feeds[index].urlToImage).image,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feeds[index].author,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${feeds[index].publishedAt.toDate().day}"
                              "/${feeds[index].publishedAt.toDate().month}"
                              "/${feeds[index].publishedAt.toDate().year}"
                              " ${feeds[index].publishedAt.toDate().hour}"
                              ":${feeds[index].publishedAt.toDate().minute}",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),),
                Container(
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    feeds[index].title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                Image.network(feeds[index].urlToImage),
                const SizedBox(height: 10),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                  child: Text(
                    feeds[index].description,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              ],
            )
          );
        },
      ),
    );
  }
}