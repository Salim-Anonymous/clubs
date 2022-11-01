import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/club.dart';
import 'ClubActivityView.dart';
import 'ClubView.dart';

// create a view to display the clubs

class Clubs extends StatefulWidget {
  const Clubs({Key? key}) : super(key: key);

  @override
  State<Clubs> createState() => _ClubsState();
}

class _ClubsState extends State<Clubs> {
  List<Club> clubs = [];
   //check is user is admin
  bool isAdmin = false;

  @override
  initState(){
    super.initState();
    //get the clubs from the database
    if(FirebaseAuth.instance.currentUser ==null ) return;
    var users = FirebaseFirestore.instance.collection('users');
    users.doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      if (value.data()!['isAdmin']) {
        setState(() {
          print('is admin');
          isAdmin = true;
        });
      }
    });

    //get all the clubs the user is a member of
    FirebaseFirestore.instance.collection('clubs').where('members', arrayContains: FirebaseAuth.instance.currentUser!.email).get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          clubs.add(Club.fromMap(element.id,element.data()));
        });
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    print(isAdmin);
    print(clubs);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Clubs",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5,
        leading: null,
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: FirebaseAuth.instance.currentUser==null?Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Please login to view your clubs'),
            const SizedBox(height: 20,),
            ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/profile');
                },
                child: const Text('Login/Register'))
          ],
        ):clubs.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Text(
                      "You are not a member of any clubs",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Join a club to see it here",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: clubs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)
                              => ClubActivityView(
                                cid: clubs[index].cid,
                              ),
                          ),
                        );
                      },
                      child: Card(
                          margin: const EdgeInsets.all(10),
                          elevation: 5,
                          color: Colors.black,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            height: 100,
                            child: Row(
                              children: [
                                Container(
                                    margin: const EdgeInsets.all(10),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          Image.network(clubs[index].urlToImage).image,
                                      backgroundColor: Colors.white,
                                    )),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        clubs[index].name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                      )
                  );
                },
              ),
      ),
      floatingActionButton: isAdmin?FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/clubs/add');
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add_circle),
      ):const Text(""),
    );
  }
}
