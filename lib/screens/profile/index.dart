import 'package:clubs/helpers/auth.dart';
import 'package:clubs/screens/Auth/sign_in.dart';
import 'package:clubs/screens/profile/user_details.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AuthenticationHelper().user!=null?const UserView():const SignIn(),
    );
  }
}