import 'dart:io';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qreate/components/hr.dart';
import 'package:qreate/screens/login.dart';
import "package:sign_in_button/sign_in_button.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _form = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool emailError = false;
  bool passwordError = false;

  String emailErrorMessage = "";
  String passwordErrorMessage = "";

  bool obscureText = true;

  void hideKeyboard(){
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }


  void createUserWithEmail() async {

    final isValid = _form.currentState!.validate();
    if (isValid) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text).then((value) => Navigator.pop(context), onError: (error) =>
        {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  titlePadding: const EdgeInsets.all(0),
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text("Error"),
                  content: Text(error.toString())
              );
            },
          )
        });
      } catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
          return AlertDialog(
              titlePadding: const EdgeInsets.all(0),
              contentPadding: const EdgeInsets.all(0),
              title: const Text("Error"),
              content: Text(e.toString())
          );
        });
      }
    }

    hideKeyboard();
  }

  Future<UserCredential?> createUserWithApple() async {

    try {
      final AuthorizationResult appleResult = await TheAppleSignIn
          .performRequests([
        const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      if (appleResult.error != null) {
        // handle errors from Apple here
      }

      if (appleResult.credential != null) {
        Iterable<int> authCode = appleResult.credential!.authorizationCode ??
            [];
        Iterable<int> idToken = appleResult.credential!.identityToken ?? [];

        final AuthCredential credential = OAuthProvider("apple.com").credential(
          accessToken: String.fromCharCodes(authCode),
          idToken: String.fromCharCodes(idToken),
        );
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);
        Navigator.pop(context);
        return userCredential;
      }
    } catch(e){
      print(e);
    }
  }

  Future<UserCredential> createUserWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.pop(context);
    return userCredential;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          hideKeyboard();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Register"),
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
                  child: Column(children: [
                    TextFormField(
                      decoration: InputDecoration(hintText: "Email", errorMaxLines: 3),
                      controller: emailController,
                      validator: (text) {
                        final bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(emailController.text);

                        if (text == null || text == "") {
                          return "Please enter your email";
                        } else if (!emailValid) {
                          return "Please enter a valid email";
                        } else if (emailValid) {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      obscureText: obscureText,
                      decoration: InputDecoration(hintText: "Password", errorMaxLines: 3, suffixIcon: IconButton(icon: Icon(obscureText ? CommunityMaterialIcons.eye : CommunityMaterialIcons.eye_off), onPressed: (){
                        setState(() {
                          obscureText = !obscureText;
                        });
                      }),),
                      controller: passwordController,
                      validator: (text) {
                        if (text == null || text == "") {
                          return "Please enter your password";
                        } else {
                          final bool passwordValid = RegExp(
                                  r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
                              .hasMatch(passwordController.text);
                          if (!passwordValid) {
                            return "Your password must be at least 8 characters long and include a lowercase, uppercase, number, and special character";
                          } else if (passwordValid) {
                            return null;
                          }
                        }
                      },
                    ),
                    ElevatedButton(
                        onPressed: createUserWithEmail, child: Text("Login")),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (t) => Login()));
                        },
                        child: Text("Already have an account? Sign in"))
                  ]),
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 25),
                    child: HR(text: "OR")),
                Column(children: [
                  Platform.isIOS ? SignInButton(Buttons.apple, text: "Sign up with Apple", onPressed: createUserWithApple) : Container(),
                  SignInButton(Buttons.google, text: "Sign up with Google", onPressed: createUserWithGoogle),
                ]),
              ],
            ),
          )),
        ));
  }
}
