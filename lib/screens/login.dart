import "package:flutter/material.dart";
import 'package:qreate/components/hr.dart';
import "package:sign_in_button/sign_in_button.dart";
import "package:firebase_auth/firebase_auth.dart";

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _form = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool emailError = false;
  bool passwordError = false;

  String emailErrorMessage = "";
  String passwordErrorMessage = "";

  void signInWithEmail() async {

    final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text);
    final bool passwordValid = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$").hasMatch(passwordController.text);

    // if(emailController.text.isEmpty){
    //   emailErrorMessage = "Please enter your email";
    //   emailError = true;
    // } else if(!emailValid){
    //   emailErrorMessage = "Please enter a valid email";
    //   emailError = true;
    // } else if(emailValid){
    //   emailErrorMessage = "";
    //   emailError = false;
    // }
    //
    // if(passwordController.text.isEmpty){
    //   passwordErrorMessage = "Please enter your password";
    //   passwordError = true;
    // } else if(!emailValid){
    //   passwordErrorMessage = "Your password is ";
    //   passwordError = true;
    // } else if(emailValid){
    //   passwordErrorMessage = "";
    //   passwordError = false;
    // }

    final isValid = _form.currentState!.validate();
    if(isValid) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
      } catch (e) {
        print(e.toString());
      }
    }
    setState(() {
      print("SDFPSDJF");
    });
  }

  void signInWithApple(){}

  void signInWithGoogle(){}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
        child: Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.all(25),
        height: MediaQuery.of(context).size.height - 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Form(
              key: _form,
              child:
            Column(children: [
              TextFormField(
                decoration: InputDecoration(hintText: "Email"),
                controller: emailController,
                validator: (text) {
                  if(text != null){
                    return "Please enter your email";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Password"),
                controller: passwordController,
                validator: (text){
                  if(text != null){
                    return "Please enter your password";
                  } else {
                    return null;
                  }
                },
              ),
              ElevatedButton(onPressed: signInWithEmail, child: Text("Login")),
              TextButton(
                  onPressed: () {}, child: Text("Need an account? Sign Up"))
            ]),),
            Container(
                margin: EdgeInsets.symmetric(vertical: 25),
                child: HR(text: "OR")),
            Column(children: [
              SignInButton(Buttons.apple, onPressed: () {}),
              SignInButton(Buttons.google, onPressed: () {}),
            ]),
          ],
        ),
      )),
    ));
  }
}
