import "package:flutter/material.dart";

class ErrorDialog extends StatelessWidget {
  final String errorMessage;
  const ErrorDialog({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          height: 300,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 50),
                child: const Text(
                  "Error",
                  style: TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 25),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Close")),
              ),
            ]),
          ),
        ));
  }
}
