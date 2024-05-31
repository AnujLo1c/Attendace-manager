import 'dart:async';

import 'package:attendance/Screens/ClassLogin.dart';
import 'package:attendance/connections/Classname_provider.dart';
import 'package:attendance/connections/Shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as Flutter;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth.dart';
import 'package:rive/rive.dart';

// import 'package:rive/rive.dart'as rive;
class lrp extends StatefulWidget {
  static String routeName = "login_page";

  const lrp({super.key});

  @override
  State<lrp> createState() => lrpState();
}

class lrpState extends State<lrp> {
  static bool checkuserexits = false;
  String? errormsg = 'a';
  bool isLogin = true;

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  /// rive controller and input
  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    fetchEP();
    super.initState();
  }

  fetchEP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UN = prefs.getString('username');
    var PW = prefs.getString('password');
    if (UN != null && PW != null) {
      _controlleremail.text = UN;
      _controllerpass.text = PW;
    }
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  final TextEditingController _controlleremail = TextEditingController();
  final TextEditingController _controllerpass = TextEditingController();
  var fa = FirebaseAuth.instance;
  Future<void> signInWithEandP() async {
    try {
      UserCredential userCred = await fa.signInWithEmailAndPassword(
          email: _controlleremail.text, password: _controllerpass.text);
      if (userCred.user != null) {
        showLoadingDialog(context);
        context
            .read<Username_provider>()
            .setusername(Auth().currentUser?.email, context);
        // print(Provider.of<Username_provider>(context,listen: false).username);
        trigSuccess?.change(true);
        SharedPref().LoginSP(_controlleremail.text, _controllerpass.text);
        Timer(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, ClassLogin.routeName);
        });
      } else {
        trigFail?.change(true);
        setState(() {
          errormsg = "User doesn't exits.";
        });
        error();
      }
    } on FirebaseAuthException catch (e) {
      trigFail?.change(true);
      print(e);
      setState(() {
        errormsg = e.toString();
      });
      error();
    }
  }

  Future<void> createUserWithEandP(BuildContext context) async {
    try {
      // print("User created successfully!");
      final String email = _controlleremail.text;
      final String password = _controllerpass.text;
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      showLoadingDialog(context);
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      SharedPref().LoginSP(_controlleremail.text, _controllerpass.text);
      context
          .read<Username_provider>()
          .setusername(Auth().currentUser?.email, context);
      Navigator.pushReplacementNamed(context, ClassLogin.routeName);
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException
      print("Error: ${e.message}");
      setState(() {
        errormsg = e.message;
        error();
      });
    }
  }

  void error() {
    Fluttertoast.showToast(
        msg: errormsg!,
        fontSize: 16,
        textColor: Colors.red,
        backgroundColor: Colors.transparent);
    errormsg = '';
  }

  Future showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0.4),
      barrierDismissible: false,
      builder: (context) => Container(
          color: Colors.white.withOpacity(.4),
          height: double.infinity,
          width: double.infinity,
          child: const Center(child: CircularProgressIndicator())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFD6E2EA),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Container(
                  height: 64,
                  width: 64,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    "AM",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  )),
              SizedBox(
                height: 250,
                width: 250,
                child: RiveAnimation.asset(
                  "assets/login-teddy.riv",
                  fit: BoxFit.fitHeight,
                  stateMachines: const ["Login Machine"],
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                      artboard,
                      "Login Machine",
                    );
                    if (controller == null) return;
                    artboard.addController(controller!);
                    isChecking = controller?.findInput("isChecking");
                    numLook = controller?.findInput("numLook");
                    isHandsUp = controller?.findInput("isHandsUp");
                    trigSuccess = controller?.findInput("trigSuccess");
                    trigFail = controller?.findInput("trigFail");
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: const GradientBoxBorder(
                            width: 2,
                            gradient: Flutter.LinearGradient(colors: [
                              Colors.blueAccent,
                              Colors.blue,
                              Colors.lightBlue,
                              Colors.lightBlueAccent
                            ])),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: TextField(
                        focusNode: emailFocusNode,
                        controller: _controlleremail,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email",
                            hintStyle:
                                TextStyle(color: Colors.black87, fontSize: 18)),
                        style: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (value) {
                          numLook?.change(value.length.toDouble());
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: const GradientBoxBorder(
                            width: 2,
                            gradient: Flutter.LinearGradient(colors: [
                              Colors.blueAccent,
                              Colors.blue,
                              Colors.lightBlue,
                              Colors.lightBlueAccent
                            ])),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: TextField(
                        focusNode: passwordFocusNode,
                        controller: _controllerpass,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            hintStyle:
                                TextStyle(color: Colors.black87, fontSize: 18)),
                        obscureText: true,
                        style: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (value) {},
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        height: 38,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(isLogin ? 'Register ' : 'Login'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: () {
                          // showLoadingDialog(context);
                          emailFocusNode.unfocus();
                          passwordFocusNode.unfocus();
                          isLogin
                              ? signInWithEandP()
                              : createUserWithEandP(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              )),
                        ),
                        child: Text(
                          !isLogin ? 'Register ' : 'Login ',
                          style:
                              const TextStyle(letterSpacing: 1, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /////
// Future<bool> Checkuserclass()async{
//     print("checking user class");
//   CollectionReference cref = FirebaseFirestore.instance.collection(
//       "studentids");
//   bool ds = await cref.doc(_controlleremail.text).get().then((value){
//     if(value.exists){
//       var dsdata = value.get("ClassName");
//
//       String cname=Provider.of<Classname_provider>(context,listen: false).classname;
//       print(cname);
//       print(dsdata);
//       if(dsdata != cname){
//         return false;
//       }
//       else{
//         return true;
//       }
//     }else{
//       return false;
//     }
//     }
//   );
//  return ds;
// }
}
