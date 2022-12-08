import 'package:community_material_icon/community_material_icon.dart';
import "package:flutter/material.dart";
import 'package:qreate/screens/qr_preview.dart';

class CreateGithub extends StatefulWidget {
  const CreateGithub({Key? key}) : super(key: key);

  @override
  State<CreateGithub> createState() => _CreateGithubState();
}

class _CreateGithubState extends State<CreateGithub> {
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
                        value: "https://www.github.com/${controller.text}",
                        type: "github",
                    image: Image.asset("assets/images/github.png"),
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
          title: const Text("Create Github QR"),
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
                            hintText: "Github Username",
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
