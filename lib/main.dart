import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qreate/components/create_new.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qreate/screens/login.dart';
import 'package:qreate/screens/register.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qreate',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Qreate'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> codes = ["asdf", "asdf", "adsf"];

  void connectToFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    connectToFirebase();

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(margin: EdgeInsets.only(top: 15), child: Text("Create new QR code", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 68, 93, 133)),)),
              SizedBox(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: const CreateNew(),
              ),
              const Divider(
                thickness: 1.5,
              ),
              FirebaseAuth.instance.currentUser != null
                  ? ListView(
                      shrinkWrap: true,
                      children: codes.map((e) => const Text("Test")).toList(),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height - 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(margin: EdgeInsets.only(bottom: 25), child: Text("To save QR codes", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 68, 93, 133)),)),

                          Column(
                              children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (t) => Login()));
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(150, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)
                                )
                              ),
                              child: Text(
                                "Login",
                                style: TextStyle(fontSize: 24),
                              )),
                          Container(height: 25,),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (t) => Register()));
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(150, 50),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(width: 2, color: Theme.of(context).primaryColor)
                                )
                              ),
                              child: Text(
                                "Register",
                                style: TextStyle(fontSize: 24, color: Theme.of(context).primaryColor),
                              )),])
                        ],
                      )),
            ],
          ),
        ));
  }
}
