import 'dart:async';
import 'welcome_screen.dart';
import 'package:flutter/material.dart';
import 'splashscreen.dart';
import 'package:project/login.dart';
import 'home_page.dart';
import 'settingPage/themepage.dart';

void main() {
  runApp(PlantsAi());
}

class PlantsAi extends StatelessWidget {
  const PlantsAi({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: appThemeNotifier,
      builder: (context, theme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode:
              theme == "Dark"
                  ? ThemeMode.dark
                  : theme == "Light"
                  ? ThemeMode.light
                  : ThemeMode.system,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Color.fromARGB(255, 56, 114, 64),
            colorScheme: ColorScheme.light(
              primary: Color.fromARGB(255, 56, 114, 64),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Color.fromARGB(255, 56, 114, 64),
            colorScheme: ColorScheme.dark(
              primary: Color.fromARGB(255, 56, 114, 64),
            ),
          ),
          home: SplashWrapper(),
          routes: {
            '/welcome': (context) => const WelcomeScreens(),
            '/login': (context) => const LoginBox(),
            '/home': (context) => const Home(),
          },
        );
      },
    );
  }
}

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool showsplash = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      setState(() {
        showsplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return showsplash ? SplashScreen() : WelcomeScreens();
  }
}
