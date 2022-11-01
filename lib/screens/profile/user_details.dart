import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubs/helpers/auth.dart';
import 'package:flutter/material.dart';

class UserView extends StatefulWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {

  String uid = AuthenticationHelper().user.uid;
  String name = "";
  String email = "";
  String phone = "";
  String photoUrl = "";

  Future<void> getUserData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    setState(() {
      name = documentSnapshot.get("name");
      email = documentSnapshot.get("email");
      phone = documentSnapshot.get("phone");
      photoUrl = documentSnapshot.get("profile_pic");
    });
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    getUserData();
    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: null,
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: ()=>{
              setState(() {
                _isLoading = true;
              }),
              AuthenticationHelper().signOut().then((value) => {
                Navigator.pushReplacementNamed(context, '/profile')
              }),
              setState(() {
                _isLoading = false;
              })
            },
            child:
              const Icon(Icons.logout,color: Colors.black45,)
          )
        ],
        actionsIconTheme: const IconThemeData(color: Colors.black45),
      ),
      body:_isLoading?const CircularProgressIndicator(
        backgroundColor: Colors.white,
        color: Colors.black,
      ):Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                height: 200,
                width:200,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(photoUrl),
                  radius: 100,
                ),
              ),
              const SizedBox(height: 20),
              //show details
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text("Name: ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                        Text(name,style: const TextStyle(fontSize: 12),),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text("Email: ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                        Text(email,style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text("Phone: ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                        Text(phone,style: const TextStyle(fontSize: 12),),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}