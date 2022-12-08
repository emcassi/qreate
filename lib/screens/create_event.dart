import 'package:community_material_icon/community_material_icon.dart';
import 'package:enough_icalendar/enough_icalendar.dart';
import "package:flutter/material.dart";
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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
  final TextEditingController urlController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

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
          final invite = VCalendar.createEvent(
            organizerEmail: emailController.text,
            start: startDate,
            end: endDate,
            location: addressController.text,
            url: Uri.parse(urlController.text),
            summary: nameController.text,
            description: detailsController.text,
            productId: 'enough_icalendar/v1',
          );

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (s) => QRPreview(
                        value: invite.toString(),
                        type: "event",
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
                          margin: const EdgeInsets.symmetric(vertical: 15),
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
                              const Text("Start Date "),
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
                              const Text("Start Time "),
                              TextButton(
                                  onPressed: () {
                                    DatePicker.showTime12hPicker(context,
                                        showTitleActions: true,
                                        currentTime: startDate,
                                        onChanged: (date) {
                                      setState(() {
                                        startDate = date;
                                      });
                                    });
                                  },
                                  child:
                                      Text(DateFormat.jm().format(startDate))),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("End Date "),
                              TextButton(
                                  onPressed: () {
                                    selectEndDate(context);
                                  },
                                  child: Text(
                                      DateFormat.yMMMEd().format(endDate))),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("End Time"),
                              TextButton(
                                  onPressed: () {
                                    DatePicker.showTime12hPicker(context,
                                        showTitleActions: true,
                                        currentTime: endDate,
                                        onChanged: (date) {
                                      setState(() {
                                        endDate = date;
                                      });
                                    });
                                  },
                                  child: Text(DateFormat.jm().format(endDate))),
                            ]),
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: TextFormField(
                                controller: urlController,
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.next,
                                validator: (text) {
                                  if (text != null) {
                                    if (Uri.tryParse(text) == null) {
                                      return "Invalid URL";
                                    }
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: "URL",
                                    suffixIcon: IconButton(
                                        onPressed: () =>
                                            {urlController.text = ""},
                                        icon: const Icon(
                                          CommunityMaterialIcons.close_circle,
                                          color: Colors.grey,
                                          size: 16,
                                        ))))),
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: TextFormField(
                                controller: addressController,
                                keyboardType: TextInputType.streetAddress,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    hintText: "Address",
                                    suffixIcon: IconButton(
                                        onPressed: () =>
                                            {addressController.text = ""},
                                        icon: const Icon(
                                          CommunityMaterialIcons.close_circle,
                                          color: Colors.grey,
                                          size: 16,
                                        ))))),
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                textCapitalization: TextCapitalization.none,
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
                                    hintText: "Email",
                                    suffixIcon: IconButton(
                                        onPressed: () =>
                                            {emailController.text = ""},
                                        icon: const Icon(
                                          CommunityMaterialIcons.close_circle,
                                          color: Colors.grey,
                                          size: 16,
                                        ))))),
                        TextFormField(
                            controller: detailsController,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.newline,
                            maxLines: 8,
                            decoration: InputDecoration(
                              hintText: "Details",
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
            Container(
                margin: const EdgeInsets.only(bottom: 75),
                child: ElevatedButton(
                    onPressed: createQR, child: const Text("Create QR Code")))
          ],
        )),
      ),
    );
  }
}
