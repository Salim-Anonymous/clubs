import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddActivity extends StatefulWidget {
  final String clubName;
  final String cid;
  const AddActivity({Key? key, required this.clubName, required this.cid}) : super(key: key);

  @override
  State<AddActivity> createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {

  final _activityTitleController = TextEditingController();
  final _activityDescriptionController = TextEditingController();
  final _activityLocationController = TextEditingController();
  final _activityAuthorController = TextEditingController();
  DateTime _activityDate = DateTime.now();
  TimeOfDay _activityTime = TimeOfDay.now();
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
          "Add Activity",
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
              const SizedBox(height: 20,),
              TextField(
                controller: _activityTitleController,
                decoration: const InputDecoration(
                  hintText: "Activity Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: _activityDescriptionController,
                decoration: const InputDecoration(
                  hintText: "Activity Description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: _activityLocationController,
                decoration: const InputDecoration(
                  hintText: "Activity Location",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: _activityAuthorController,
                decoration: const InputDecoration(
                  hintText: "Activity Author",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  showDatePicker(context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365))).then((value) {
                    setState(() {
                      _activityDate = value!;
                    });
                    }
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Activity Date"),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              //field to get time
              InkWell(
                onTap: (){
                  showTimePicker(context: context, initialTime: TimeOfDay.now())
                      .then((value) {
                    setState(() {
                      _activityTime = value!;
                    });
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(_activityTime == null ? "Select Time" : "${_activityTime.hour}:${_activityTime.minute}"),
                ),
              ),
              const SizedBox(height: 20,),
              InkWell(
                onTap: () async {
                  setState(() {
                    adding = true;
                  });

                  if(_activityTitleController.text.isNotEmpty && _activityDescriptionController.text.isNotEmpty && _activityLocationController.text.isNotEmpty && _activityAuthorController.text.isNotEmpty && _image != null){
                    String fileName = basename(_image!.path);
                    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('activity_images/$fileName');
                    UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
                    TaskSnapshot taskSnapshot = await uploadTask;

                    DateTime time = DateTime(_activityDate.year, _activityDate.month, _activityDate.day, _activityTime.hour, _activityTime.minute);

                    taskSnapshot.ref.getDownloadURL().then(
                          (value) => FirebaseFirestore.instance.collection('clubs').doc(widget.cid).collection('activities').add({
                        'title': _activityTitleController.text,
                        'description': _activityDescriptionController.text,
                        'location': _activityLocationController.text,
                        'author': _activityAuthorController.text,
                        'image': value,
                        'date': Timestamp.fromDate(time),
                      }).then((value) => Navigator.pop(context)).catchError(
                            (error) => print("Failed to add activity: $error"),
                          ),
                    );

                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all the fields"),
                      ),
                    );
                  }
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
                      adding?"Adding":"Add Activity",
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
      ),
    );
  }
}
