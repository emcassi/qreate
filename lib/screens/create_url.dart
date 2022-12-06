import 'package:community_material_icon/community_material_icon.dart';
import "package:flutter/material.dart";
import 'package:qreate/screens/qr_preview.dart';

class CreateURL extends StatefulWidget {
  const CreateURL({Key? key}) : super(key: key);

  @override
  State<CreateURL> createState() => _CreateURLState();
}

class _CreateURLState extends State<CreateURL> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    void createQR() {
      if (controller.text.isNotEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (s) => QRPreview(
                      value: controller.text,
                    )));
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        print("SDFPOISDJF");
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
      appBar: AppBar(
        title: const Text("Create URL QR"),
        centerTitle: true,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: "URL",
                        suffixIcon: IconButton(
                            onPressed: () => {controller.text = ""},
                            icon: const Icon(
                              CommunityMaterialIcons.close_circle,
                              color: Colors.grey,
                              size: 16,
                            ))))),
            ElevatedButton(onPressed: createQR, child: const Text("Create"))
          ],
        ),
      ),
    );
  }
}
