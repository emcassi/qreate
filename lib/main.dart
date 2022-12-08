import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qreate/components/code_item.dart';
import 'package:qreate/components/create_new.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qreate/models/qr_code.dart';
import 'package:qreate/screens/login.dart';
import 'package:qreate/screens/register.dart';
import 'package:qreate/screens/settings.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

final RouteObserver<MaterialPageRoute> routeObserver =
    RouteObserver<MaterialPageRoute>();


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void connectToFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    connectToFirebase();
    return MaterialApp(
      title: 'Qreate',
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
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

class _MyHomePageState extends State<MyHomePage> with RouteAware {
  List<QRCode> codes = [];
    Future<List?> getCodes() async {
    List<QRCode> temp = [];
    if(FirebaseAuth.instance.currentUser != null){
    var getDocs = FirebaseFirestore.instance
        .collection("codes")
        .where("user", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy("timestamp", descending: true)
        .get();
    await getDocs.then((snapshot) {
    for (var doc in snapshot.docs) {
    Map<String, dynamic> data = doc.data();
    temp.add(QRCode(data["id"], data["name"], data["type"], data["user"], data["value"],
    data["imageURL"]));
    }
    });
    setState(() {
    codes = temp;
    });
    }
    return codes;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getCodes();
      routeObserver.subscribe(
          this, ModalRoute.of(context) as MaterialPageRoute);
    });
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context) as MaterialPageRoute);
    super.didChangeDependencies();
  }


  @override
  void didPopNext() {
    getCodes();
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {

    Widget authView = SizedBox(
        height: MediaQuery.of(context).size.height - 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.only(bottom: 25),
                child: const Text(
                  "To save QR codes",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 68, 93, 133)),
                )),
            Column(children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (t) => const Login()));
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(25))),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 24),
                  )),
              Container(
                height: 25,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (t) => const Register()));
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 50),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(
                              width: 2,
                              color: Theme.of(context)
                                  .primaryColor))),
                  child: Text(
                    "Register",
                    style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).primaryColor),
                  )),
            ])
          ],
        ));

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          leading: FirebaseAuth.instance.currentUser == null ? Container() : IconButton(
            icon: const Icon(CommunityMaterialIcons.cog),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: const Text(
                    "Create new QR code",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 68, 93, 133)),
                  )),
              SizedBox(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: const CreateNew(),
              ),
              const Divider(
                thickness: 1.5,
              ),
              StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    if(codes.isEmpty){
                      return Container(height: 300, child: const Center(child: Text("No codes saved. Create one now")));
                    } else {
                      return ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        children:
                        codes.map((code) => CodeItem(code: code, getCodes: getCodes)).toList(),
                      );
                    }
                  } else {
                    return authView;
                  }
                },
              ),
            ],
          ),
        ));
  }
}

abstract class RouteAwareState<T extends StatefulWidget> extends State<T>
    with RouteAware {
  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context) as MaterialPageRoute);
    super.didChangeDependencies();
  }

  @override
  void didPush() {
    print('didPush $widget');
  }

  @override
  void didPopNext() {
    print('didPopNext $widget');
  }

  @override
  void didPop() {
    print('didPop $widget');
  }

  @override
  void didPushNext() {
    print('didPushNext $widget');
  }

  @override
  void dispose() {
    print("dispose $widget");
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
