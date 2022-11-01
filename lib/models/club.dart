import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Club{
  String cid;
  String name;
  String description;
  String urlToImage;
  Timestamp createdAt;
  int noOfMembers;
  int maxMembers;
  List<dynamic> moderators;
  bool hasJoined;
  Club({
    required this.cid,
    required this.name,
    required this.description,
    required this.urlToImage,
    required this.createdAt,
    required this.noOfMembers,
    required this.maxMembers,
    required this.moderators,
    required this.hasJoined,
  });

  factory Club.fromJson(Map<String, dynamic> json){
    return Club(
      cid: json['cid'],
      name: json['name'],
      description: json['description'],
      urlToImage: json['urlToImage'],
      createdAt: json['createdAt'],
      noOfMembers: json['noOfMembers'],
      maxMembers: json['maxMembers'],
      moderators: json['moderators'],
      hasJoined: json['hasJoined'],
    );
  }

  factory Club.fromMap(String id,Map<String, dynamic> map){
    return Club(
      cid: id,
      name: map['name'],
      description: map['description'],
      urlToImage: map['image'],
      createdAt: map['createdAt'],
      noOfMembers: map['members'].length,
      maxMembers: map['maxMembers'],
      moderators: map['moderators'],
      hasJoined: map['members'].contains(FirebaseAuth.instance.currentUser?.email),
    );
  }
}