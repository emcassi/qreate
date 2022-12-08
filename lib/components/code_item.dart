import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as HTTP;
import 'package:path/path.dart';

import 'package:community_material_icon/community_material_icon.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:gallery_saver/files.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qreate/models/qr_code.dart';
import 'package:share_plus/share_plus.dart';

class CodeItem extends StatelessWidget {
  final QRCode code;
  final Function getCodes;

  const CodeItem({super.key, required this.code, required this.getCodes});

  @override
  Widget build(BuildContext context) {
    Future<File> fileFromImageUrl() async {
      final response = await HTTP.get(Uri.parse(code.imageURL));

      final documentDirectory = await getApplicationDocumentsDirectory();

      final file = File(join(documentDirectory.path, 'qr.png'));

      file.writeAsBytesSync(response.bodyBytes);

      return file;
    }

    void share() async {
      File imageFile = await fileFromImageUrl();
      Share.shareXFiles([XFile(imageFile.path)]);
    }

    void download() async {
      File imageFile = await fileFromImageUrl();
      GallerySaver.saveImage(imageFile.path);
      showDialog(
          context: context,
          builder: (t) => AlertDialog(
                content: SizedBox(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Saved",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      const Text(
                        "The QR code has been saved to your images.",
                        style: TextStyle(fontSize: 14),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Ok"))
                    ],
                  ),
                ),
              ));
    }

    void delete() async {
      showDialog(
          context: context,
          builder: (t) => AlertDialog(
                content: SizedBox(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Delete?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      const Text(
                        "Are you sure you want to delete this code?",
                        style: TextStyle(fontSize: 14),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).primaryColor),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("codes")
                                  .doc(code.id)
                                  .delete();
                              getCodes();
                            },
                            child: const Text("Yes",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("No",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ));
    }

    return Container(
        height: 130,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.only(left: 15),
                child: Image.network(
                  code.imageURL,
                  width: 100,
                  height: 100,
                )),
            Container(
              height: 115,
              width: MediaQuery.of(context).size.width - 150,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    code.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(code.type),
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: download,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor),
                                child: const Icon(
                                  CommunityMaterialIcons.download,
                                  color: Colors.white,
                                )),
                            ElevatedButton(
                                onPressed: share,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor),
                                child: Icon(
                                  Platform.isIOS
                                      ? CommunityMaterialIcons.export_variant
                                      : CommunityMaterialIcons.share,
                                  color: Colors.white,
                                )),
                            ElevatedButton(
                                onPressed: delete,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: const Icon(
                                  CommunityMaterialIcons.trash_can,
                                  color: Colors.white,
                                )),
                          ])),
                ],
              ),
            ),
          ],
        ));
  }
}
