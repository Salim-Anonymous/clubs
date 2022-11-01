import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/club.dart';

Future<bool> createClub(Club newClub) {
  final db = FirebaseFirestore.instance;

  db
  .collection("clubs")
  .add({
    "name": newClub.name,
    "description": newClub.description,
    "image": newClub.urlToImage,
    "createdAt": Timestamp.now(),
    "maxMembers": newClub.maxMembers,
    "moderators": newClub.moderators,
  }).catchError((error) => print("Failed to add club: $error"));
  return Future.value(true);
}