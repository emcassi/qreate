import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";

class QRType extends StatelessWidget {
  final String type;
  final IconData iconData;
  final Widget widget;
  const QRType(
      {super.key,
      required this.type,
      required this.iconData,
      required this.widget});

  @override
  Widget build(BuildContext context) {
    void goToScreen() {
      Navigator.push(context, MaterialPageRoute(builder: (t) => widget));
    }

    return GestureDetector(
        onTap: goToScreen,
        child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 68, 93, 133),
                borderRadius: BorderRadius.circular(25)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  color: Colors.white70,
                ),
                Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(
                      type,
                      style: const TextStyle(color: Colors.white70),
                    )),
              ],
            )));
  }
}
