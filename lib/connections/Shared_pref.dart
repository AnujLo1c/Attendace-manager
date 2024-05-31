import 'package:attendance/Screens/ClassLogin.dart';
import 'package:attendance/Screens/hp.dart';
import 'package:attendance/Screens/lrp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../auth.dart';
import 'Classname_provider.dart';

class SharedPref{
  LoginSP(username, password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }
  joinClass(classname)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("class", classname);
  }

  isLoggedinSP(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      var UN = prefs.getString('username');
      var PW = prefs.getString('password');
      if (UN != null && PW != null) {
     await FirebaseAuth.instance.signInWithEmailAndPassword(email: UN, password: PW);
        // context.read<Username_provider>().setusername(UN, context);
      print("none");

        Navigator.pushReplacementNamed(context, ClassLogin.routeName);
          }
      else {
      print("none1");
        Navigator.pushReplacementNamed(context, lrp.routeName);
      }
  }
  Future<String> getClass(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? c=await prefs.getString('class');
    if(c!=null) {
      return c;
    }
    else{
      return "";
    }
  }
  isLoggedinClass(context)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var c=await prefs.getString('class');
    if(c!=null){
      // context.read<Classname_provider>().setclassname(c, context);
        Navigator.pushReplacementNamed(context, hp.routeName,arguments: c);
    }
    else{
        Navigator.pushReplacementNamed(context, ClassLogin.routeName);
    }
  }
  Logoutclass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('class');
  }
  LogoutSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    await prefs.remove('class');

  }
}