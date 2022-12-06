import 'package:flutter/material.dart';
import 'package:qreate/components/create_new.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
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
        actions: [
          IconButton(onPressed: () => {}, icon: const Icon(Icons.add))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: const CreateNew(),
            ),
            const Divider(
              thickness: 1 ,
            ),
            ListView(
              shrinkWrap: true  ,
              children: codes.map((e) => const Text("Test")).toList(),
            )
          ],
        ),
      )
    );
  }
}
