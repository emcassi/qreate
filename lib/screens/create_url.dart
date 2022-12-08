import 'package:community_material_icon/community_material_icon.dart';
import "package:flutter/material.dart";
import 'package:qreate/screens/qr_preview.dart';

class CreateURL extends StatefulWidget {
  const CreateURL({Key? key}) : super(key: key);

  @override
  State<CreateURL> createState() => _CreateURLState();
}

class _CreateURLState extends State<CreateURL> {
  final _form = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Image? setEmbeddedImage() {
      final uri = Uri.parse(controller.text);
      Image? image;

      switch (uri.host) {
        case "www.amazon.com":
        case "amazon.com":
          image = Image.asset("assets/images/amazon.png");
          break;
        case "www.baidu.com":
        case "baidu.com":
          image = Image.asset("assets/images/baidu.png");
          break;
        case "www.discord.com":
        case "discord.com":
          image = Image.asset("assets/images/discord.png");
          break;
        case "www.ebay.com":
        case "ebay.com":
          image = Image.asset("assets/images/ebay.png");
          break;
        case "www.facebook.com":
        case "facebook.com":
          image = Image.asset("assets/images/facebook.png");
          break;
        case "www.fandom.com":
        case "fandom.com":
          image = Image.asset("assets/images/fandom.png");
          break;
        case "www.github.com":
        case "github.com":
          image = Image.asset("assets/images/github.png");
          break;
        case "www.instagram.com":
        case "instagram.com":
          image = Image.asset("assets/images/instagram.png");
          break;
        case "www.linkedin.com":
        case "linkedin.com":
          image = Image.asset("assets/images/linkedin.png");
          break;
        case "www.netflix.com":
        case "netflix.com":
          image = Image.asset("assets/images/netflix.png");
          break;
        case "www.onlyfans.com":
        case "onlyfans.com":
          image = Image.asset("assets/images/onlyfans.png");
          break;
        case "www.pornhub.com":
        case "pornhub.com":
          image = Image.asset("assets/images/pornhub.png");
          break;
        case "www.quora.com":
        case "quora.com":
          image = Image.asset("assets/images/quora.png");
          break;
        case "www.reddit.com":
        case "reddit.com":
          image = Image.asset("assets/images/reddit.png");
          break;
        case "www.tiktok.com":
        case "tiktok.com":
          image = Image.asset("assets/images/tiktok.png");
          break;
        case "www.twitch.com":
        case "twitch.com":
        case "www.twitch.tv":
        case "twitch.tv":
          image = Image.asset("assets/images/twitch.png");
          break;
        case "www.twitter.com":
        case "twitter.com":
          image = Image.asset("assets/images/twitter.png");
          break;
        case "www.wechat.com":
        case "wechat.com":
          image = Image.asset("assets/images/wechat.png");
          break;
        case "www.whatsapp.com":
        case "whatsapp.com":
          image = Image.asset("assets/images/whatsapp.png");
          break;
        case "www.wikipedia.com":
        case "wikipedia.com":
          image = Image.asset("assets/images/wikipedia.png");
          break;
        case "www.xnxx.com":
        case "xnxx.com":
          image = Image.asset("assets/images/xnxx.png");
          break;
        case "www.xvideos.com":
        case "xvideos.com":
          image = Image.asset("assets/images/xvideos.png");
          break;
        case "www.yahoo.com":
        case "yahoo.com":
          image = Image.asset("assets/images/yahoo.png");
          break;
        case "www.yandex.ru":
        case "yandex.ru":
          image = Image.asset("assets/images/yandex.png");
          break;
        case "www.youtube.com":
        case "youtube.com":
        case "www.youtu.be":
        case "youtu.be":
          image = Image.asset("assets/images/youtube.png");
          break;
        case "www.zoom.com":
        case "zoom.com":
          image = Image.asset("assets/images/zoom.png");
          break;
      }

      return image;
    }

    void createQR() {
      if (_form.currentState != null) {
        bool isValid = _form.currentState!.validate();
        if (isValid) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (s) => QRPreview(
                        value: controller.text.toLowerCase(),
                        type: "url",
                        image: setEmbeddedImage(),
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
          title: const Text("Create URL QR"),
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
                        keyboardType: TextInputType.url,
                        validator: (text) {
                          if (text != null) {
                            if (text.isEmpty) {
                              return "URL required";
                            } else {
                              bool urlValid = Uri.parse(text).host.isNotEmpty;
                              if (!urlValid) {
                                return "Invalid URL";
                              }
                            }
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "URL",
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
