import 'package:community_material_icon/community_material_icon.dart';
import "package:flutter/material.dart";
import 'package:qreate/screens/qr_preview.dart';

class CreateInstagram extends StatefulWidget {
  const CreateInstagram({Key? key}) : super(key: key);

  @override
  State<CreateInstagram> createState() => _CreateInstagramState();
}

class _CreateInstagramState extends State<CreateInstagram> {
  final _form = GlobalKey<FormState>();
    final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    void createQR() {
      if (_form.currentState != null) {
        bool isValid = _form.currentState!.validate();
        if (isValid) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (s) => QRPreview(
                        value: "https://www.instagram.com/${controller.text}",
                        type: "instagram",
                    image: Image.asset("assets/images/instagram.png"),
                      )));
        }
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create Twitter QR"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                child: Form(
                    key: _form,
                    child: TextFormField(
                        controller: controller,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.none,
                        validator: (text) {
                          if (text != null) {
                            if (text.isEmpty) {
                              return "Username required";
                            }
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Instagram Username",
                            suffixIcon: IconButton(
                                onPressed: () => {controller.text = ""},
                                icon: const Icon(
                                  CommunityMaterialIcons.close_circle,
                                  color: Colors.grey,
                                  size: 16,
                                )))))),
            ElevatedButton(
                onPressed: createQR, child: const Text("Create QR Code"))
          ],
        ),
      ),
    );
  }
}
