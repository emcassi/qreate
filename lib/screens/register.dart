import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:qreate/components/hr.dart';
import "package:sign_in_button/sign_in_button.dart";
import "package:firebase_auth/firebase_auth.dart";

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

  void signInWithEmail() async {

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
                  title: Text("Error"),
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
              title: Text("Error"),
              content: Text(e.toString())
          );
        });
      }
    }
  }

  void signInWithApple() {}

  void signInWithGoogle() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
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
                  child: Column(children: [
                    TextFormField(
                      decoration: InputDecoration(hintText: "Email"),
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
                      decoration: InputDecoration(hintText: "Password"),
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
                        onPressed: signInWithEmail, child: Text("Login")),
                    TextButton(
                        onPressed: () {},
                        child: Text("Need an account? Sign Up"))
                  ]),
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 25),
                    child: HR(text: "OR")),
                Column(children: [
                  SignInButton(Buttons.apple, text: "Sign up with Apple", onPressed: () {}),
                  SignInButton(Buttons.google, text: "Sign up with Google", onPressed: () {}),
                ]),
              ],
            ),
          )),
        ));
  }
}
