import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Modal padrão de confirmação 
Future<bool> dialogConfirm(String title, String content) async {
  var confirm = await Get.dialog(
    AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        FlatButton(
          color: Get.theme.primaryColor.withOpacity(.5),
          onPressed: () => Get.back(result: false), 
          child: Text("Voltar")
        ),
        FlatButton(
          color: Get.theme.primaryColor,
          onPressed: () => Get.back(result: true), 
          child: Text("Confirmar")
        ),
      ],
    )
  ) ?? false;

  return confirm;
}