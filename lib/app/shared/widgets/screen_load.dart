import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

// Widget padrão de load
class ScreenLoad extends StatelessWidget {

  final String message;

  const ScreenLoad({Key key, this.message = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white54,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/lottie/loading.json',
              height: Get.mediaQuery.size.height / 3,
              repeat: true,
            ),
            Text(message, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}