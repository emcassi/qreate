import 'package:community_material_icon/community_material_icon.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:mailto/mailto.dart';
import 'package:qreate/screens/qr_preview.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key? key}) : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _form = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(2015, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime(2015, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void createQR() {
      if (_form.currentState != null) {
        bool isValid = _form.currentState!.validate();
        if (isValid) {
          String qrData = "";
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (s) => QRPreview(
                        value: qrData,
                        type: "event",
                      )));
        }
      }
    }

    print(startDate);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar( calk
          title: const Text("Create Event QR"),
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
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: TextFormField(
                              controller: nameController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (text) {
                                if (text != null) {
                                  if (text.isEmpty) {
                                    return "Title required";
                                  }
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: "Title",
                                  suffixIcon: IconButton(
                                      onPressed: () =>
                                          {nameController.text = ""},
                                      icon: const Icon(
                                        CommunityMaterialIcons.close_circle,
                                        color: Colors.grey,
                                        size: 16,
                                      )))),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Start Date "),
                              TextButton(
                                  onPressed: () {
                                    selectStartDate(context);
                                  },
                                  child: Text(
                                      DateFormat.yMMMEd().format(startDate))),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("End Date "),
                              TextButton(
                                  onPressed: () {
                                    selectEndDate(context);
                                  },
                                  child: Text(
                                      DateFormat.yMMMEd().format(endDate))),
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
