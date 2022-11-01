import 'package:cloud_firestore/cloud_firestore.dart';

class ClubActivity{
  final String title;
  final String description;
  final String author;
  final String image;
  final String location;
  final Timestamp date;

  ClubActivity({
    required this.title,
    required this.description,
    required this.author,
    required this.image,
    required this.location,
    required this.date,
  });

  static fromMap(Map<String, dynamic> data) {
    return ClubActivity(
        title: data['title'],
        description: data['description'],
        author: data['author'],
        image: data['image'],
        location: data['location'],
        date: data['date'],
    );
  }


}