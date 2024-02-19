import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoadingMessage(BuildContext context) {
  //Android
  if (Platform.isAndroid) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>  AlertDialog(
              title: const Text('Espere por favor'),
              content: Container(
                height: 100,
                width: 100,
                margin: const EdgeInsets.only(top: 10),
                child: const Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Cargando...'),
                    SizedBox(height: 15),
                    CircularProgressIndicator(strokeWidth: 3, color: Colors.black,)
                  ],
                ),
              ),
            ));
    return;
  }
  //iOS
  showCupertinoDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const CupertinoAlertDialog(
      title: Text('Espere por favor'),
      content: CupertinoActivityIndicator(),
    ),
  );
}
