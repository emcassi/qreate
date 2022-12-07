import 'package:community_material_icon/community_material_icon.dart';
import "package:flutter/material.dart";
import 'package:qreate/components/qr_type.dart';
import 'package:qreate/screens/create_call.dart';
import 'package:qreate/screens/create_email.dart';
import 'package:qreate/screens/create_event.dart';
import 'package:qreate/screens/create_sms.dart';
import 'package:qreate/screens/create_url.dart';
import 'package:qreate/screens/create_text.dart';
import 'package:qreate/screens/create_wifi.dart';

class CreateNew extends StatelessWidget {
  const CreateNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 1.75;

    return GridView.count(
      crossAxisCount: 2,
      scrollDirection: Axis.horizontal,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      padding: const EdgeInsets.all(25),

      primary: true,
      childAspectRatio: (itemWidth / itemHeight),
      children: const [
        QRType(type: "URL", iconData: CommunityMaterialIcons.web, widget: CreateURL()),
        QRType(type: "Message", iconData: CommunityMaterialIcons.message_plus, widget: CreateSMS()),
        QRType(type: "Wi-Fi Login", iconData: CommunityMaterialIcons.wifi, widget: CreateWiFi()),
        QRType(type: "Call", iconData: CommunityMaterialIcons.phone, widget: CreateCall()),
        QRType(type: "Email", iconData: CommunityMaterialIcons.email, widget: CreateEmail()),
        QRType(type: "Location", iconData: CommunityMaterialIcons.map_marker, widget: CreateURL()),
        QRType(type: "Event", iconData: CommunityMaterialIcons.calendar, widget: CreateEvent()),
        QRType(type: "Text", iconData: CommunityMaterialIcons.alphabetical, widget: CreateText()),
      ],
    );
  }
}
