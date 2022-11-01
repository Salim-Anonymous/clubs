import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubs/helpers/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

//creating a signin page

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  late String url;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  void signUp(context) async {
    setState(() {
      _isLoading = true;
    });
    if(_passwordController.text == _confirmPasswordController.text){
      try{
        FirebaseFirestore firestore;
        await AuthenticationHelper()
            .signUpWithEmailAndPassword(_emailController.text, _passwordController.text)
            .then((value) async => {
          if (value == null)
            {
              setState(() {
                _isLoading = false;
              }),
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Something Went Wrong!"),
                ),
              )
            }
          else
            {
              url = await uploadFile(),
              firestore = FirebaseFirestore.instance,
              firestore.collection("users").doc(value.uid).set({
                "uid": value.uid,
                "name": _nameController.text,
                "email": _emailController.text,
                "phone": _phoneController.text,
                "profile_pic": url,
              }),
              setState(() {
                _isLoading = false;
              }),
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Signed Up"),
                ),
              ),
              Navigator.pushReplacementNamed(context, '/profile')
            }
        });
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
      }
    }
    else{
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
        ),
      );
    }
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  Future<String> uploadFile() async {
    final fileName = basename(_image!.path);
    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_image!);
      final urlStr = await ref.getDownloadURL();
      return urlStr;
    } catch (e) {
      print('error occured');
    }
    throw Exception('error occured');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading? const Center( child: CircularProgressIndicator(
          color: Colors.black,
          strokeWidth: 2,
        )):Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child:Column(
              children: [
                GestureDetector(
                  onTap: (){
                    showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomSheet(context)));
                  },
                  child:Container(
                    padding: const EdgeInsets.all(20),
                    height: 200,
                    width: 200,
                    child: _image!=null?
                      CircleAvatar(backgroundImage:Image.file(_image!).image, radius: 100,):
                      const Icon(
                      Icons.linked_camera_rounded,
                      color: Colors.redAccent,
                      size: 100,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value){
                      if(value != _passwordController.text){
                        return "Passwords do not match";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Confirm Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: "Username",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      hintText: "Phone Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: ()=>signUp(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Sign In"),
                    ),
                  ],
                ),
              ],
            ),),
        )
    );
  }

  bottomSheet(context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text(
            "Choose Profile Photo",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  imgFromCamera();
                },
                icon: const Icon(Icons.camera),
                label: const Text("Camera"),
              ),
              TextButton.icon(
                onPressed: () {
                  imgFromGallery();
                },
                icon: const Icon(Icons.image),
                label: const Text("Gallery"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}