import 'package:community_material_icon/community_material_icon.dart';
import "package:flutter/material.dart";
import 'package:qreate/screens/qr_preview.dart';
import "package:intl_phone_number_input/intl_phone_number_input.dart";

class CreateCall extends StatefulWidget {
  const CreateCall({Key? key}) : super(key: key);

  @override
  State<CreateCall> createState() => _CreateCallState();
}

class _CreateCallState extends State<CreateCall> {
  final _form = GlobalKey<FormState>();
    final TextEditingController controller = TextEditingController();

    String initialCountry = "US";

  @override
  Widget build(BuildContext context) {
    PhoneNumber phoneNumber = PhoneNumber(isoCode: initialCountry);

    void createQR() {
      if (_form.currentState != null) {
        bool isValid = _form.currentState!.validate();
        if (isValid) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (s) => QRPreview(
                        value: "tel:${phoneNumber.phoneNumber}",
                        type: "phone",
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
          title: const Text("Create Phone QR"),
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
                      onInputChanged: (number) {
                        phoneNumber = number;
                      },
                      initialValue: phoneNumber,
                      textFieldController: controller,
                    ))),
            ElevatedButton(onPressed: createQR, child: const Text("Create QR Code"))
          ],
        ),
      ),
    );
  }
}
