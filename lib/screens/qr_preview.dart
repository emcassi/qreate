import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:contrast_checker/contrast_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qreate/components/ErrorDialog.dart';
import 'package:qreate/other/Behaviors.dart';
import 'package:qreate/screens/login.dart';
import 'package:qreate/screens/register.dart';
import 'package:uuid/uuid.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import "package:flutter_colorpicker/flutter_colorpicker.dart";
import "package:share_plus/share_plus.dart";
import "dart:io";

class QRPreview extends StatefulWidget {
  final String value;
  final String type;
  final Image? image;
  const QRPreview({super.key, required this.value, required this.type, this.image});

  @override
  State<QRPreview> createState() => _QRPreviewState();
}

class _QRPreviewState extends State<QRPreview> {
  WidgetsToImageController qrController = WidgetsToImageController();

  Color bgColor = Colors.white;
  Color fgColor = Colors.black;

  bool useImage = true;

  final _form = GlobalKey<FormState>();

  TextEditingController textEditingController = TextEditingController();

  bool isAdding = false;

  @override
  Widget build(BuildContext context) {
    Widget qr = QrImage(
      data: widget.value,
      version: QrVersions.auto,
      size: 250.0,
      embeddedImage: useImage
          ? widget.image != null
              ? widget.image!.image
              : null
          : null,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
    );

    AlertDialog authDialog = AlertDialog(
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          height: 300,
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Text(
                      "You must be signed in to save QR codes.",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.left,
                    )),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context, MaterialPageRoute(builder: (t) => Login()));
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 24),
                    )),
                Container(
                  height: 25,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (t) => Register()));
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 50),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(
                                width: 2,
                                color: Theme.of(context).primaryColor))),
                    child: Text(
                      "Register",
                      style: TextStyle(
                          fontSize: 24, color: Theme.of(context).primaryColor),
                    ))
              ],
            ),
          ),
        ));

    bool isContrastLow() {
      final cc = ContrastChecker();
      return !cc.contrastCheck(24, fgColor, bgColor, WCAG.AA);
    }

    void showBGPicker() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              titlePadding: const EdgeInsets.all(0),
              contentPadding: const EdgeInsets.all(0),
              content: SizedBox(
                height: 475,
                child: ColorPicker(
                  pickerColor: bgColor,
                  onColorChanged: (color) => {
                    setState(() {
                      bgColor = color;
                    })
                  },
                ),
              ));
        },
      );
    }

    void showFGPicker() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              titlePadding: const EdgeInsets.all(0),
              contentPadding: const EdgeInsets.all(0),
              content: SizedBox(
                height: 475,
                child: ColorPicker(
                  pickerColor: fgColor,
                  onColorChanged: ((color) {
                    setState(() {
                      fgColor = color;
                    });
                  }),
                ),
              ));
        },
      );
    }

    Future<File?> qrToFile() async {
      final data = await qrController.capture();
      if (data != null) {
        if (Platform.isIOS) {
          if (await Permission.photos.request().isGranted) {
            print("GRANTED");
            final docs = await getApplicationDocumentsDirectory();
            final codesDir = Directory("${docs.path}/codes");
            final dirExists = await codesDir.exists();
            if (!dirExists) {
              await codesDir.create(recursive: true);
            }
            File file = await File("${codesDir.path}/qr.png")
                .writeAsBytes(List<int>.from(data!));
            return file;
          }
        } else if (await Permission.storage.request().isGranted) {
          final docs = await getApplicationDocumentsDirectory();
          final codesDir = Directory("${docs.path}/codes");
          final dirExists = await codesDir.exists();
          if (!dirExists) {
            await codesDir.create(recursive: true);
          }
          File file = await File("${codesDir.path}/qr.png")
              .writeAsBytes(List<int>.from(data!));
          return file;
        }
      }
    }

    void share() async {
      File? imageFile = await qrToFile();
      if (imageFile != null) {
        Share.shareXFiles([XFile(imageFile.path)]);
      }
    }

    void save() async {
      if(!isAdding) {
        setState(() {
          isAdding = true;
        });
        if (FirebaseAuth.instance.currentUser == null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return authDialog;
            },
          );
        } else {
          bool isValid = _form.currentState!.validate();
          if (isValid) {
            File? imageFile = await qrToFile();
            if (imageFile != null) {
              final Reference storageRef = FirebaseStorage.instance.ref(
                  "codes");
              final String codeId = Uuid().v4();
              final Reference newCodeRef = storageRef.child(codeId);

              try {
                await newCodeRef.putFile(imageFile).then((snapshot) async {
                  String downloadURL = await newCodeRef.getDownloadURL();
                  FirebaseFirestore.instance.collection("codes").add({
                    "user": FirebaseAuth.instance.currentUser!.uid,
                    "name": textEditingController.text,
                    "type": widget.type,
                    "value": widget.value,
                    "imageURL": downloadURL,
                    "timestamp": Timestamp.now(),
                  }).then((doc) {
                    doc.update({"id": doc.id}).then((value){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  });
                });
              } on FirebaseException catch (e) {
                if (e.message != null) {
                  isAdding = false;
                  showDialog(
                      context: context,
                      builder: (t) => ErrorDialog(errorMessage: e.message!));
                }
              }
            }
          }
        }
      }
    }

    Widget buildImage(Uint8List bytes) => Image.memory(bytes);

    return Scaffold(
      // key: qrController.containerKey,
      appBar: AppBar(
        title: const Text("Preview"),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: ScrollConfiguration(
          behavior: NoInkScrollBehavior(),
          child: SingleChildScrollView(
            child: Center(
              child: Column(children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  color: Colors.black,
                  child: Center(
                      child:
                          WidgetsToImage(controller: qrController, child: qr)),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 25),
                    child: Form(
                        key: _form,
                        child: TextFormField(
                          maxLength: 32,
                          validator: (text) {
                            if (text != null) {
                              if (text.isEmpty) {
                                return "A name is required";
                              }
                            }
                            return null;
                          },
                          controller: textEditingController,
                          decoration: const InputDecoration(hintText: "Name"),
                        ))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 150,
                      child: Text(
                        "Background Color: ",
                        style: TextStyle(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: showBGPicker,
                        style:
                            ElevatedButton.styleFrom(backgroundColor: bgColor),
                        child: const Text(""))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 150,
                      child: Text(
                        "Foreground Color: ",
                        style: TextStyle(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: showFGPicker,
                      style: ElevatedButton.styleFrom(backgroundColor: fgColor),
                      child: const Text(""),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 150,
                      child: Text(
                        "Embed Logo?",
                        style: TextStyle(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Switch(
                        value: useImage,
                        onChanged: (value) => {
                              setState(() => {useImage = value})
                            })
                  ],
                ),
                isContrastLow()
                    ? const Text(
                        "QR codes with low contrast may be difficult to read",
                        style: TextStyle(color: Colors.red),
                      )
                    : Container(),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                      width: 125,
                      margin: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 10),
                      child: ElevatedButton(
                          onPressed: share, child: const Text("Share"))),
                  Container(
                      width: 125,
                      margin: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 10),
                      child: ElevatedButton(
                          onPressed: save, style: isAdding ? ElevatedButton.styleFrom(backgroundColor: Colors.grey) : ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor), child: isAdding ? const CupertinoActivityIndicator(radius: 12, color: Colors.white,) : const Text("Save"))),
                ])
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
