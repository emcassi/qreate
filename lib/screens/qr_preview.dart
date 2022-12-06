import 'dart:typed_data';

import 'package:community_material_icon/community_material_icon.dart';
import "package:flutter/material.dart";
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qreate/other/Behaviors.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import "package:flutter_colorpicker/flutter_colorpicker.dart";
import "package:share_plus/share_plus.dart";
import "dart:io";

class QRPreview extends StatefulWidget {
  final String value;
  const QRPreview({super.key, required this.value});

  @override
  State<QRPreview> createState() => _QRPreviewState();
}

class _QRPreviewState extends State<QRPreview> {
  WidgetsToImageController qrController = WidgetsToImageController();

  Color bgColor = Colors.white;
  Color fgColor = Colors.black;

  bool useImage = true;
  Image? embeddedImage;

  TextEditingController textEditingController = TextEditingController();

  void setEmbeddedImage() {
    final uri = Uri.parse(widget.value);
    Image? image;

    switch(uri.host){
      case "www.discord.com":
        image = Image.asset("assets/images/discord.png");
        break;
      case "www.facebook.com":
        image = Image.asset("assets/images/facebook.png");
        break;
      case "www.instagram.com":
        image = Image.asset("assets/images/instagram.png");
        break;
      case "www.twitter.com":
        image = Image.asset("assets/images/twitter.png");
        break;
      case "www.wechat.com":
        image = Image.asset("assets/images/wechat.png");
        break;
      case "www.youtube.com":
        print("YOUTUBE");
        image = Image.asset("assets/images/youtube.png");
        break;
    }

    setState(() {
      embeddedImage = image;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setEmbeddedImage();
  }

  @override
  Widget build(BuildContext context) {
    Widget qr = QrImage(
      data: widget.value,
      version: QrVersions.auto,
      size: 250.0,
      embeddedImage: useImage ? embeddedImage != null ? embeddedImage!.image : null : null ,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
    );

    void showBGPicker() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(0),
            contentPadding: const EdgeInsets.all(0),
            content: ColorPicker(
              pickerColor: bgColor,
              onColorChanged: (color) => {
                setState(() => {bgColor = color})
              },
            ),
          );
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
            content: SizedBox(height: 475, child: ColorPicker(
              pickerColor: fgColor,
              onColorChanged: (color) => {
                setState(() => {fgColor = color})
              },
            ),)
          );
        },
      );
    }


    void share() async {
      final data = await qrController.capture();
      if(data != null) {
        if(Platform.isIOS){
          if(await Permission.photos.request().isGranted){
            print("GRANTED");
            final docs = await getApplicationDocumentsDirectory();
            final codesDir = Directory("${docs.path}/codes");
            final dirExists = await codesDir.exists();
            if(!dirExists){
              await codesDir.create(recursive: true);
            }
            File image = await File("${codesDir.path}/qr.png").writeAsBytes(List<int>.from(data!));
            Share.shareXFiles([XFile(image.path)], text: textEditingController.text);
          }
        }
        else if(await Permission.storage.request().isGranted) {
          final docs = await getApplicationDocumentsDirectory();
          final codesDir = Directory("${docs.path}/codes");
          final dirExists = await codesDir.exists();
          if(!dirExists){
            await codesDir.create(recursive: true);
          }
          File image = await File("${codesDir.path}/qr.png").writeAsBytes(List<int>.from(data!));
          Share.shareXFiles([XFile(image.path)], text: textEditingController.text);
        }
      }
    }

    void save() async {}

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
                    child: TextField(
                      controller: textEditingController,
                      decoration: const InputDecoration(hintText: "Name"),
                    )),
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
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                      width: 125,
                      margin: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 10),
                      child: ElevatedButton(
                          onPressed: share,
                          child: const Text("Share"))),
                  Container(
                      width: 125,
                      margin: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 10),
                      child: ElevatedButton(
                          onPressed: save,
                          child: const Text("Save"))),
                ])
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
