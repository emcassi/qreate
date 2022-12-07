import 'package:community_material_icon/community_material_icon.dart';
import "package:flutter/material.dart";
import 'package:mailto/mailto.dart';
import 'package:qreate/screens/qr_preview.dart';

class CreateWiFi extends StatefulWidget {
  const CreateWiFi({Key? key}) : super(key: key);

  @override
  State<CreateWiFi> createState() => _CreateWiFiState();
}

class _CreateWiFiState extends State<CreateWiFi> {
  final _form = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    String authType = "WPA";
    bool hidden = false;

  @override
  Widget build(BuildContext context) {


    void changeAuthType(String? type) {
      if (type is String) {
        setState(() {
          authType = type;
        });
      }
    }

    void createQR() {
      if (_form.currentState != null) {
        bool isValid = _form.currentState!.validate();
        if (isValid) {
          String qrData =
              "WIFI:T:${authType};S:${nameController.text};P:${passwordController.text};H:${hidden}";
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (s) => QRPreview(
                        value: qrData,
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
          title: const Text("Create WiFi QR"),
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
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                          Text("Authentication "),
                          DropdownButton(items: const [
                            DropdownMenuItem(
                              child: Text("nopass"),
                              value: "nopass",
                            ),
                            DropdownMenuItem(
                              child: Text("WPA"),
                              value: "WPA",
                            ),
                            DropdownMenuItem(
                              child: Text("WEP"),
                              value: "WEP",
                            ),
                          ], value: authType, onChanged: changeAuthType),
                        ]),
                        TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (text) {
                              if (text != null) {
                                if (text.isEmpty) {
                                  return "Name required";
                                }
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: "Name",
                                suffixIcon: IconButton(
                                    onPressed: () => {nameController.text = ""},
                                    icon: const Icon(
                                      CommunityMaterialIcons.close_circle,
                                      color: Colors.grey,
                                      size: 16,
                                    )))),
                        TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            textInputAction: TextInputAction.next,
                            validator: (text) {
                              if (text != null) {
                                if (text.isEmpty) {
                                  return "Password required";
                                }
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: "Password",
                                suffixIcon: IconButton(
                                    onPressed: () =>
                                        {passwordController.text = ""},
                                    icon: const Icon(
                                      CommunityMaterialIcons.close_circle,
                                      color: Colors.grey,
                                      size: 16,
                                    )))),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Hidden "),
                              Switch(
                                  value: hidden,
                                  onChanged: (value) => {
                                    setState(() => {hidden = value})
                                  })
                            ]),
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
