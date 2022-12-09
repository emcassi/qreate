import 'package:community_material_icon/community_material_icon.dart';
import "package:flutter/material.dart";
import 'package:mailto/mailto.dart';
import 'package:qreate/screens/qr_preview.dart';

class CreateEmail extends StatefulWidget {
  const CreateEmail({Key? key}) : super(key: key);

  @override
  State<CreateEmail> createState() => _CreateEmailState();
}

class _CreateEmailState extends State<CreateEmail> {
  final _form = GlobalKey<FormState>();
    final TextEditingController recipientController = TextEditingController();
    final TextEditingController subjectController = TextEditingController();
    final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    void createQR() {
      if (_form.currentState != null) {
        bool isValid = _form.currentState!.validate();
        if (isValid) {
          Mailto mailto = Mailto(to: [recipientController.text], subject: subjectController.text, body: messageController.text);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (s) => QRPreview(
                        value: mailto.toString(),
                        type: "email",
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
          title: const Text("Create Email QR"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                            controller: recipientController,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (text) {
                              if (text != null) {
                                if (text.isEmpty) {
                                  return "Recipient required";
                                }
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: "Recipient",
                                suffixIcon: IconButton(
                                    onPressed: () => {recipientController.text = ""},
                                    icon: const Icon(
                                      CommunityMaterialIcons.close_circle,
                                      color: Colors.grey,
                                      size: 16,
                                    )))),
                        Container(margin: const EdgeInsets.symmetric(vertical: 15), child: TextFormField(
                            controller: subjectController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                hintText: "Subject",
                                suffixIcon: IconButton(
                                    onPressed: () => {subjectController.text = ""},
                                    icon: const Icon(
                                      CommunityMaterialIcons.close_circle,
                                      color: Colors.grey,
                                      size: 16,
                                    ))))),
                        TextFormField(
                            controller: messageController,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.newline,
                            validator: (text) {
                              if (text != null) {
                                if (text.isEmpty) {
                                  return "Message required";
                                }
                              }

                              return null;
                            },
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: "Message",
                              border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).primaryColor)),
                            )),
                      ],
                    ))),
            ElevatedButton(
                onPressed: createQR, child: const Text("Create QR Code"))
          ],
        )),
      ),
    );
  }
}
