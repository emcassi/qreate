import 'package:community_material_icon/community_material_icon.dart';
import "package:flutter/material.dart";
import 'package:google_sign_in/google_sign_in.dart';
import "dart:io";
import 'package:qreate/components/ErrorDialog.dart';
import 'package:qreate/components/hr.dart';
import 'package:qreate/screens/register.dart';
import "package:sign_in_button/sign_in_button.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

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

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    void hideKeyboard() {
      FocusScopeNode currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    void signInWithEmail() async {
      final isValid = _form.currentState!.validate();
      if (isValid) {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((userCred) {
              if(userCred.user != null){
                Navigator.pop(context);
              }
        }, onError: (error) {
          if (error is FirebaseAuthException) {
            switch (error.code) {
              case "user-not-found":
                setState(() {
                  ErrorDialog errorDialog = const ErrorDialog(
                      errorMessage:
                          "There is no user corresponding to this email. Please create an account.");
                  showDialog(
                      context: context, builder: (context) => errorDialog);
                });
                break;
              case "wrong-password":
                setState(() {
                  ErrorDialog errorDialog = const ErrorDialog(
                      errorMessage:
                          "Incorrect email or password. Please check and try again");
                  showDialog(
                      context: context, builder: (context) => errorDialog);
                });
                break;
            }
          }
        });
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
        } on FirebaseAuthException catch (e) {
          switch (e.code) {
            case "user-not-found":
              setState(() {
                ErrorDialog errorDialog = const ErrorDialog(
                    errorMessage:
                        "There is no user corresponding to this email. Please create an account.");
                showDialog(context: context, builder: (context) => errorDialog);
              });
              break;
            case "wrong-password":
              setState(() {
                ErrorDialog errorDialog = const ErrorDialog(
                    errorMessage:
                        "Incorrect email or password. Please check and try again");
                showDialog(context: context, builder: (context) => errorDialog);
              });
              break;
          }
        }
      }
      hideKeyboard();
      setState(() {});
    }

    Future<UserCredential?> signInWithApple() async {

      try {
        final AuthorizationResult appleResult = await TheAppleSignIn.performRequests([
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

    Future<UserCredential> signInWithGoogle() async {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pop(context);
      return userCredential;
    }

    return GestureDetector(
        onTap: () {
          hideKeyboard();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Login"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.all(25),
            height: MediaQuery.of(context).size.height - 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Form(
                  key: _form,
                  child: Column(children: [
                    TextFormField(
                      decoration: const InputDecoration(hintText: "Email"),
                      controller: emailController,
                      validator: (text) {
                        if (text == null || text == "") {
                          return "Please enter your email";
                        } else  {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        hintText: "Password",
                        errorMaxLines: 3,
                        suffixIcon: IconButton(
                            icon: Icon(obscureText
                                ? CommunityMaterialIcons.eye
                                : CommunityMaterialIcons.eye_off),
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            }),
                      ),
                      controller: passwordController,
                      validator: (text) {
                        if (text == null || text == "") {
                          return "Please enter your password";
                        } else {
                          return null;
                        }
                      },
                    ),
                    Container(margin: const EdgeInsets.only(top: 25), child: ElevatedButton(
                        onPressed: signInWithEmail, child: const Text("Login"))),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (t) => const Register()));
                        },
                        child: const Text("Need an account? Sign Up"))
                  ]),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 25),
                    child: const HR(text: "OR")),
                Column(children: [
                  Platform.isIOS ? SignInButton(Buttons.apple, text: "Sign up with Apple", onPressed: signInWithApple) : Container(),
                  SignInButton(Buttons.google, onPressed: signInWithGoogle),
                ]),
              ],
            ),
          )),
        ));
  }
}
