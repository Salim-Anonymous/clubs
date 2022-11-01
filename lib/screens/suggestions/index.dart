import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helpers/utils.dart';
import '../../models/club.dart';

class Recommendation extends StatefulWidget {
  const Recommendation({Key? key}) : super(key: key);

  @override
  State<Recommendation> createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  List<Club> clubs = [];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('clubs').get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          clubs.add(Club.fromMap(element.id,element.data()));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(children: const [
            Text(
              "Clubs You may Like",
              style: TextStyle(color: Colors.black),
              softWrap: true,
            ),
            Icon(Icons.arrow_forward, color: Colors.black)
          ],),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 5,
          leading: null,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(20),
          scrollDirection: Axis.horizontal,
          itemCount: clubs.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.grey[200],
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
              child: Container(
                width: 280,
                padding: const EdgeInsets.all(6),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(children: [
                      const SizedBox(
                        height: 80
                      ),
                      CircleAvatar(
                        radius: 80,
                        backgroundImage:
                        Image.network(clubs[index].urlToImage).image,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        clubs[index].name,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'members: ${clubs[index].noOfMembers} / ${clubs[index].maxMembers}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                        ),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        clubs[index].description,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                        ),
                        maxLines: 5,
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ],),
                    const SizedBox(height: 50),
                    InkWell(
                      onTap: () {
                        FirebaseFirestore.instance
                            .collection('clubs')
                            .doc(clubs[index].cid)
                            .collection('requests')
                            .add(
                          {
                            'uid': FirebaseAuth.instance.currentUser!.uid,
                            'name': FirebaseAuth.instance.currentUser!.displayName,
                            'email': FirebaseAuth.instance.currentUser!.email,
                            'urlToImage': FirebaseAuth.instance.currentUser!.photoURL,
                            'timestamp': DateTime.now().millisecondsSinceEpoch,
                          },
                        ).catchError(
                          (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ),
                            );
                          },
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Request Sent'),
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            clubs[index].hasJoined?"Joined":"Join",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
