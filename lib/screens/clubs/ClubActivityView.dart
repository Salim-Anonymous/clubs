import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubs/screens/clubs/add_feed.dart';
import 'package:clubs/screens/clubs/member_requests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/activity.dart';
import '../../models/club.dart';
import 'add_activity.dart';

class ClubActivityView extends StatefulWidget {
  final String cid;
  const ClubActivityView({Key? key, required this.cid}) : super(key: key);

  @override
  State<ClubActivityView> createState() => _ClubActivityViewState();
}

class _ClubActivityViewState extends State<ClubActivityView> {

  Club club = Club(
      name: '',
      description: '',
      urlToImage: '',
    moderators: [],
    hasJoined: false,
    cid: '',
    createdAt: Timestamp.now(),
    maxMembers: 0,
    noOfMembers: 0,
  );
  List<dynamic> activities = [];

  @override
  void initState() {
    super.initState();
    //get the club from the database
    FirebaseFirestore.instance
        .collection('clubs')
        .doc(widget.cid)
        .get()
        .then((value) {
      setState(() {
        club = Club.fromMap(widget.cid, value.data()!);
      });
    });

    //get the activities from the database and add them to the list
    FirebaseFirestore.instance
        .collection('clubs')
        .doc(widget.cid)
        .collection('activities')
        .get()
        .then((value) {
      setState(() {
        activities = value.docs.map((e) => ClubActivity.fromMap(e.data())).toList();
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(club.moderators.contains(FirebaseAuth.instance.currentUser!.email));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(club.name, style:const TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5,
        leading: InkWell(
          highlightColor: Colors.black12,
          radius: 20,
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: activities.length,
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
                          backgroundImage: Image.network(activities[index].image).image,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activities[index].author,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
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
                      activities[index].title,
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
                  Image.network(activities[index].image),
                  const SizedBox(height: 10),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                    child: Text(
                      activities[index].description,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                      child:
                      Text(
                        "Scheduled on: ${activities[index].date.toDate().day}"
                        "/${activities[index].date.toDate().month}"
                        "/${activities[index].date.toDate().year}"
                        "/${activities[index].date.toDate().hour}"
                        "/${activities[index].date.toDate().minute}",
                        style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                    ),
                  ),),
                ],
              )
          );
        },
      ),
      floatingActionButton: club.moderators.contains(FirebaseAuth.instance.currentUser!.email) ? Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddActivity(cid: widget.cid, clubName: club.name,),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MemberRequests(cid: club.cid),
                ),
              );
            },
            child: const Icon(Icons.person_add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddFeed(cid: club.cid,)));
          },
            child: const Icon(Icons.featured_play_list),
          ),
        ],
      ): Container()
    );
  }
}