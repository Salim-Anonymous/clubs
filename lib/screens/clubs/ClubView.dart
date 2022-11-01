import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/club.dart';

class ClubView extends StatefulWidget {
  final String cid;
  const ClubView({Key? key, required this.cid}) : super(key: key);

  @override
  State<ClubView> createState() => _ClubViewState();
}

class _ClubViewState extends State<ClubView> {

  late Club club;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          club.name,
          style: TextStyle(color: Colors.black),
        ),
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
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //club logo on a image background
              CircleAvatar(
                radius: 90,
                backgroundImage: NetworkImage(club.urlToImage),
              ),
              const SizedBox(
                height: 20,
              ),
              //club name
              Text(
                club.name,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //club description
              Text(
                club.description,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //club members
              Text(
                'Members: ${club.noOfMembers}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //club moderators
              Text(
                'Moderators: ${club.moderators.length}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //club created at
              Text(
                'Created At: ${DateTime.fromMicrosecondsSinceEpoch(club.createdAt.microsecondsSinceEpoch).day}/${DateTime.fromMicrosecondsSinceEpoch(club.createdAt.microsecondsSinceEpoch).month}/${DateTime.fromMicrosecondsSinceEpoch(club.createdAt.microsecondsSinceEpoch).year}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}