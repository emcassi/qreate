import 'package:community_material_icon/community_material_icon.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:qreate/screens/qr_preview.dart';

class CreateSMS extends StatefulWidget {
  const CreateSMS({Key? key}) : super(key: key);

  @override
  State<CreateSMS> createState() => _CreateSMSState();
}

class _CreateSMSState extends State<CreateSMS> {
  final _form = GlobalKey<FormState>();

  String initialCountry = "US";

  @override
  Widget build(BuildContext context) {
    final TextEditingController numberController = TextEditingController();
    final TextEditingController messageController = TextEditingController();

    PhoneNumber phoneNumber = PhoneNumber(isoCode: initialCountry);

    void createQR() {
      if (_form.currentState != null) {
        bool isValid = _form.currentState!.validate();
        if (isValid) {
          String qrValue = "SMSTO:${phoneNumber.phoneNumber}:${messageController.text}";

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (s) => QRPreview(
                        value: qrValue,
                        type: "sms",
                      )));
        }
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          // currentFocus.unfocus();
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create SMS QR"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        Container(
                            child: InternationalPhoneNumberInput(
                          onInputChanged: (number) {
                            phoneNumber = number;
                          },
                          initialValue: phoneNumber,
                          textFieldController: numberController,
                        )),
                        TextFormField(
                            controller: messageController,
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text != null) {
                                if (text.isEmpty) {
                                  return "Message required";
                                }
                              }

                              return null;
                            },
                            maxLength: 160,
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: "Message",
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: Theme.of(context).primaryColor)),
                            )),
                      ],
                    ))),
            ElevatedButton(onPressed: createQR, child: const Text("Create"))
          ],
        ),
      ),
    );
  }
}
