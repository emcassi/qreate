import 'package:community_material_icon/community_material_icon.dart';
import "package:flutter/material.dart";
import 'package:qreate/screens/qr_preview.dart';

class CreateCall extends StatefulWidget {
  const CreateCall({Key? key}) : super(key: key);

  @override
  State<CreateCall> createState() => _CreateCallState();
}

class _CreateCallState extends State<CreateCall> {
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
                        value: "tel:${controller.text}",
                        type: "call",
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
          title: const Text("Create Text QR"),
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
                    child: InternationalPhoneNumberInput(
                        controller: controller,
                        validator: (text) {
                          if (text != null) {
                            if (text.isEmpty) {
                              return "Text required";
                            }
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Text",
                            suffixIcon: IconButton(
                                onPressed: () => {controller.text = ""},
                                icon: const Icon(
                                  CommunityMaterialIcons.close_circle,
                                  color: Colors.grey,
                                  size: 16, 
                                )))))),
            ElevatedButton(onPressed: createQR, child: const Text("Create"))
          ],
        ),
      ),
    );
  }
}
