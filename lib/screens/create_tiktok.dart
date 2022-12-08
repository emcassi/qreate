import 'package:community_material_icon/community_material_icon.dart';
import "package:flutter/material.dart";
import 'package:qreate/screens/qr_preview.dart';

class CreateTiktok extends StatefulWidget {
  const CreateTiktok({Key? key}) : super(key: key);

  @override
  State<CreateTiktok> createState() => _CreateTiktokState();
}

class _CreateTiktokState extends State<CreateTiktok> {
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    void createQR() {
      if (_form.currentState != null) {
        bool isValid = _form.currentState!.validate();
        if (isValid) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (s) => QRPreview(
                        value: "https://www.tiktok.com/${controller.text}",
                        type: "tiktok",
                    image: Image.asset("assets/images/tiktok.png"),
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
          title: const Text("Create Tiktok QR"),
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
                            hintText: "Tiktok Username",
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
