import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddClub extends StatefulWidget {
  const AddClub({Key? key}) : super(key: key);

  @override
  State<AddClub> createState() => _AddClubState();
}

class _AddClubState extends State<AddClub> {

  final _clubNameController = TextEditingController();
  final _clubDescriptionController = TextEditingController();
  final _clubModeratorEmail = TextEditingController();
  final _clubMaxMembers = TextEditingController();

  bool adding = false;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Club",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5,
        leading: null,
      ),
      body: SingleChildScrollView(
        child:Container(
          padding: const EdgeInsets.all(20),
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                imageFromGallery();
              },
              child:Center(
                child: _image == null
                    ? const CircleAvatar(radius: 50, child:Icon(Icons.add_a_photo, size: 50,),)
                    : CircleAvatar(radius:80,
                  backgroundImage: FileImage(_image!),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _clubNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Club Name',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _clubDescriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Club Description',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _clubModeratorEmail,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Club Moderator Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _clubMaxMembers,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Club Max Members',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                adding = true;
                if(_clubNameController.text.isEmpty || _clubDescriptionController.text.isEmpty || _clubModeratorEmail.text.isEmpty || _clubMaxMembers.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all the fields')));
                  adding = false;
                  return;
                }
                final fileName = basename(_image!.path);
                final destination = 'clubs/$fileName';
                final ref = FirebaseStorage.instance.ref(destination);
                await ref.putFile(_image!);
                final url = await ref.getDownloadURL();
                late String clubModeratorId;
                FirebaseFirestore.instance.collection('users').where('email', isEqualTo: _clubModeratorEmail.text).get().then((value) async {
                  if(value.docs.isNotEmpty){
                    clubModeratorId = value.docs.first.id;
                    await FirebaseFirestore.instance.collection('clubs').add({
                      'name': _clubNameController.text,
                      'description': _clubDescriptionController.text,
                      'image': url,
                      'createdAt': Timestamp.now(),
                      'maxMembers': int.parse(_clubMaxMembers.text),
                    }).catchError(
                            (error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add club: $error'))));
                    //add the moderator to the club's moderators array
                    await FirebaseFirestore.instance.collection('clubs').where('name', isEqualTo: _clubNameController.text).get().then((value) async {
                      await FirebaseFirestore.instance.collection('clubs').doc(value.docs.first.id).update({
                        'moderators': FieldValue.arrayUnion([_clubModeratorEmail.text])
                      });
                    });
                    //add the club to the user's club list
                    await FirebaseFirestore.instance.collection('users').doc(clubModeratorId).update({
                      'clubs': FieldValue.arrayUnion([_clubNameController.text])
                    }).catchError(
                            (error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add club to user: $error'))));

                    String clubId = '';

                    await FirebaseFirestore.instance.collection('clubs').where('name', isEqualTo: _clubNameController.text).get().then((value) {
                      clubId = value.docs.first.id;
                    }).catchError(
                            (error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to get club id: $error'))));
                    // add the user as the member to the club
                    await FirebaseFirestore.instance.collection('clubs').doc(clubId).update({
                      'members': FieldValue.arrayUnion([_clubModeratorEmail.text])
                    }).catchError(
                            (error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add user to club: $error'))));

                    // add the club to user's moderatorOf list
                    await FirebaseFirestore.instance.collection('users').doc(clubModeratorId).update({
                      'moderatorOf': FieldValue.arrayUnion([_clubNameController.text])
                    }).catchError(
                            (error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add club to moderator: $error'))));
                    adding = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Club Added')),
                    );
                    Navigator.pushReplacementNamed(context, '/clubs');
                  }else{
                    adding = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Moderator email not found'),
                      ),
                    );
                  }
                }).catchError(
                  (error) {
                    adding = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error adding club'),
                      ),
                    );
                  },
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
                    adding?"Adding":"Add Club",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
    );
  }
}
