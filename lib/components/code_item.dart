import 'package:community_material_icon/community_material_icon.dart';
import "package:flutter/material.dart";
import 'package:qreate/models/qr_code.dart';

class CodeItem extends StatelessWidget {
  final QRCode code;

  const CodeItem({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    void morePressed() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              titlePadding: const EdgeInsets.all(0),
              contentPadding: const EdgeInsets.all(0),
              content: Container(
                width: MediaQuery.of(context).size.width - 50,
                height: 300,
                padding: EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            width: 75,
                            height: 75,
                            child: Image.network(code.imageURL)),
                        Container(
                          height: 75,
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(code.name, textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                            Text(code.type, textAlign: TextAlign.left, style: const TextStyle(fontSize: 16),),
                          ],
                        ),),
                      ],
                    ),
                    Container(
                      width: 200,
                        height: 50,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).primaryColor),
                            child: Text("Edit"))),
                    Container(
                      width: 200,
                        height: 50,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: Text("Delete"))),
                  ],
                ),
              ));
        },
      );
    }

    return Container(
        height: 100,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 100, height: 100, child: Image.network(code.imageURL)),
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width - 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(code.name),
                  Text(code.type),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  morePressed();
                },
                icon: const Icon(
                  CommunityMaterialIcons.dots_vertical,
                  color: Colors.grey,
                  size: 32,
                ))
          ],
        ));
  }
}
