import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../models/news.dart';

class AddFeed extends StatefulWidget {

  final String cid;

  const AddFeed({super.key, required this.cid});

  @override
  _AddFeedState createState() => _AddFeedState();
}

class _AddFeedState extends State<AddFeed> {

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _image;
  final picker = ImagePicker();

  Future imageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Feed'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Description',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  imageFromGallery();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _image == null
                      ? const Center(
                          child: Text('No Image Selected'),
                        )
                      : Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_titleController.text.isEmpty ||
                      _descriptionController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all the fields'),
                      ),
                    );
                    return;
                  }
                  if (_image == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select an image'),
                      ),
                    );
                    return;
                  }
                  var news = NewsFeedArticle(
                      title: _titleController.text,
                      author: FirebaseAuth.instance.currentUser!.email as String,
                      description: _descriptionController.text,
                      url: '',
                      urlToImage:'',
                      publishedAt: Timestamp.now(),
                      content: ''
                  );
                  var newsRef = FirebaseFirestore.instance.collection('news');
                  var doc = await newsRef.add(news.toMap());
                  var ref = FirebaseStorage.instance
                      .ref()
                      .child('news/${doc.id}/${basename(_image!.path)}');
                  await ref.putFile(_image!);
                  var url = await ref.getDownloadURL();
                  await doc.update({'urlToImage': url});
                  Navigator.pop(context);
                },
                child: const Text('Add Feed'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}