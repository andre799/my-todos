import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:my_todos/app/modules/splash/splash_bloc.dart';

class SplashPage extends StatefulWidget {
  final String title;
  const SplashPage({Key key, this.title = "Splash"}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends ModularState<SplashPage, SplashBloc> {
  
  @override
  void initState() {
    controller.dbRepository
    .initDatabase().then((value) async {
      Future.delayed(Duration(milliseconds: 1900),
      () => Modular.to.pushReplacementNamed('/login', ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/lottie/check-list.json',
          height: Get.mediaQuery.size.height / 4,
          repeat: false,
        ),
      ),
    );
  }
}
