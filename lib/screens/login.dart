import "package:flutter/material.dart";
import 'package:qreate/components/ErrorDialog.dart';
import 'package:qreate/components/hr.dart';
import 'package:qreate/screens/register.dart';
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

  @override
  Widget build(BuildContext context) {

    void signInWithEmail() async {

      final isValid = _form.currentState!.validate();
      if(isValid) {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
        } on FirebaseAuthException catch (e) {
          print(e.code);
          switch(e.code){
            case "user-not-found":
              setState(() {
                ErrorDialog errorDialog = const ErrorDialog(errorMessage: "There is no user corresponding to this email. Please create an account.");
                showDialog(context: context, builder: (context) => errorDialog);
              });
              break;
              case "wrong-password":
              setState(() {
                ErrorDialog errorDialog = const ErrorDialog(errorMessage: "Incorrect email or password. Please check and try again");
                showDialog(context: context, builder: (context) => errorDialog);
              });
              break;
          }
        }
      }
      setState(() {});
    }

    void signInWithApple(){}

    void signInWithGoogle(){}

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
                  if(text == null || text == ""){
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
                  if(text == null || text == ""){
                    return "Please enter your password";
                  } else {
                    return null;
                  }
                },
              ),
              ElevatedButton(onPressed: signInWithEmail, child: Text("Login")),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (t) => Register()));
                  }, child: Text("Need an account? Sign Up"))
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
