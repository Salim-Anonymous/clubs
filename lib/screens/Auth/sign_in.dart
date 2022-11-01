import 'package:clubs/helpers/auth.dart';
import 'package:clubs/screens/Auth/sign_up.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//creating a signin page

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void signIn() async{
    setState(() {
      _isLoading = true;
    });
    try{
      await AuthenticationHelper()
          .signInWithEmailAndPassword(_emailController.text, _passwordController.text)
          .then((value)=>{
            if(value == null){
              setState(() {
                _isLoading = false;
              }),
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Invalid Credentials"),
                ),
              )
            }else{
              setState(() {
                _isLoading = false;
              }),
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Signed In"),
                ),
              ),
              Navigator.pushReplacementNamed(context, '/profile')
            }
      });
    }
    catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
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
            Container(
              padding: const EdgeInsets.all(20),
              height: 200,
              width: 200,
              child: Image.asset("assets/logo/logo-no-background.png"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Join the CAMS Community",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
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
            InkWell(
              onTap: signIn,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Sign In",
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
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));
                  },
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ],
        ),),
        )
    );
  }
}