import 'dart:async';

import 'package:attendance/GradientText.dart';
import 'package:attendance/Screens/ClassLogin.dart';
import 'package:attendance/Screens/lrp.dart';
import 'package:attendance/connections/Shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splash_screen extends StatefulWidget {
  static String routeName="splash_screen";
  const Splash_screen({super.key});

  @override
  State<Splash_screen> createState() => _Splash_screenState();
}

class _Splash_screenState extends State<Splash_screen> {
    var _visible=false;
  @override
  void initState() {
    // TODO: implement initState
    Timer(const Duration(milliseconds: 500),() {
      setState(() {
        _visible=true;
      });
    },);
    Timer(const Duration(seconds: 3),(){
    // SharedPref().isLoggedinSP(context);
      Navigator.pushNamed(context, lrp.routeName);
    },);
    Lottie.asset( 'assets/robo.json');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 400,
              width: 400,
              child: Lottie.asset("assets/splash/c.json"),
            ),
            AnimatedOpacity(
              // If the widget is visible, animate to 0.0 (invisible).
              // If the widget is hidden, animate to 1.0 (fully visible).
              opacity: _visible==false ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 500),
              // The green box must be a child of the AnimatedOpacity widget.
              child:  const GradientText("Attendance Manager", gradient: LinearGradient(colors: [Colors.blue,Colors.lightBlue,Colors.lightBlueAccent]),
                style: TextStyle(fontWeight: FontWeight.w600,fontSize: 28),)
            )

          ],
        ),
      ),
    );
  }
}
