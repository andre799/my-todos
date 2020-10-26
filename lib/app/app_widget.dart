import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Modular.navigatorKey,
      title: 'My Tasks',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(122, 115, 231, 1),
        accentColor: Color.fromRGBO(122, 115, 231, 1),
        cursorColor: Color.fromRGBO(122, 115, 231, 1),
        highlightColor: Color.fromRGBO(122, 115, 231, 1),
        colorScheme: ColorScheme.light(
          primary: Color.fromRGBO(122, 115, 231, 1),
          secondary: Color.fromRGBO(122, 115, 231, 1),
        ),
        textTheme: GoogleFonts.archivoNarrowTextTheme(),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: GoogleFonts.archivoNarrowTextTheme(
            TextTheme(headline6: TextStyle(color: Colors.white))
          )
        )
      ),
      initialRoute: '/splash',
      onGenerateRoute: Modular.generateRoute,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
    );
  }
}
