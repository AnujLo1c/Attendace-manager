import 'dart:async';

import 'package:attendance/GradientText.dart';
import 'package:attendance/Screens/hp.dart';
import 'package:attendance/Screens/lrp.dart';
import 'package:attendance/auth.dart';
import 'package:attendance/connections/Classname_provider.dart';
import 'package:attendance/widgettree.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../connections/Shared_pref.dart';

class ClassLogin extends StatefulWidget {
  static String routeName="class_login_page";
  const ClassLogin({super.key});
  @override
  State<ClassLogin> createState() => _ClassLoginState();
}

class _ClassLoginState extends State<ClassLogin> with TickerProviderStateMixin {
  bool bstatus = true;
   final TextEditingController _classid = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // login();
    fetchClass(context);

  }

  login()async{
    print("t");
    SharedPreferences spf=await SharedPreferences.getInstance();
    String? u=spf.getString("username");
   String? p= spf.getString("password");
   print(u);
   print(p);
  if(u!=null && p!=null){
   print("here");
    FirebaseAuth.instance.signInWithEmailAndPassword(email: u, password: p);
  }
  else {
    Navigator.pop(context);
  }
  }

  fetchClass(context)async{
    _classid.text=await SharedPref().getClass(context);
    setState(() {
    });
  }
  Future<void> signOut() async {
    await Auth().signOut();
  }
  Widget _signoutbutton() {
    return TextButton(
      onPressed: () {
        signOut();
        SharedPref().LogoutSP();
        Navigator.pop(context);
      },
      child: const Icon(color: Colors.white, size: 30, Icons.exit_to_app),
    );
  }
  Future<void> storeClass() async {
    // login();
    String? email=FirebaseAuth.instance.currentUser?.email;
    CollectionReference classids =
        FirebaseFirestore.instance.collection("class");
    showLoadingDialog(context);
    // var docId="$email#${_classid.text}";
    var text=_classid.text;
    var shift=3;
    String docId = String.fromCharCodes(text.runes.map((char) => char + shift));
    // print("11111111111111111111111111111111");
    print(docId);
    DocumentSnapshot data=await classids.doc(docId).get();
    if(data.exists) {
      Fluttertoast.showToast(msg: "Class already exits.");
      Navigator.pop(context);
    } else{
      setClassname(docId);
      var classrep = classids.doc(docId);
      SharedPref().joinClass(docId);
      classrep.set({"id":docId});
      classrep.collection("students").doc(email!).set({"host":true});

      Navigator.pop(context);
    Navigator.pushReplacementNamed(context, hp.routeName,arguments: docId);}
  }

  void setClassname(String docId) {
    context.read<Classname_provider>().setclassname(docId, context);
  }
  void loginClass() async {
    // login();
    String? email=await FirebaseAuth.instance.currentUser?.email;
    showLoadingDialog(context);
    var docId=_classid.text;
    CollectionReference cid = FirebaseFirestore.instance.collection("class");
    DocumentSnapshot temp=await cid.doc(docId).get();
    if(temp.exists) {
      SharedPref().joinClass(docId);
      DocumentSnapshot ds = await cid.doc(docId).collection("students").doc(email).get();
      if (ds.exists) {
        Navigator.pushReplacementNamed(context, hp.routeName,arguments: docId);
      }
      else {
        await cid.doc(docId).get().then((value) {
          Map<String, dynamic>? classData = value.data() as Map<String, dynamic>;
          classData.forEach((key, value) {
            print('$key: $value');
            if(key=="id"){
            //nothing
            }else {
              classData[key] = 0;
            }
          });
          // classData.addAll({"host":false});
          cid.doc(docId).collection("students").doc(email).set(classData);
          cid.doc(docId).collection("students").doc(email).update({"host":false});
        });

      }
      setClassname(_classid.text);

      Navigator.pushReplacementNamed(context, hp.routeName, arguments: docId);
    }
    else
      {
        Fluttertoast.showToast(msg: "No class exists with this name.");
        Navigator.pop(context);
      }
  }
  Future showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0.4),
      barrierDismissible: false,

      builder: (context) =>  Container(
          color: Colors.white.withOpacity(.4),
          height: double.infinity,
          width: double.infinity,
          child: const Center(child: CircularProgressIndicator())),

    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        FirebaseAuth.instance.signOut();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFECECEE),
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            titleSpacing: 1,
            centerTitle: true,
            title: const Text(
              "Attendance Manager",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFF3B8DFC),
            automaticallyImplyLeading: false,
            elevation: 4,
            actions: [
              _signoutbutton()],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                color: const Color(0xFFECECEE),
                child: Lottie.asset(
                  'assets/robo.json',
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  alignment: Alignment.center,
                  child: GradientText(
                    "Welcome",
                    gradient: const LinearGradient(colors: [
                      Colors.blueAccent,
                      Colors.blue,
                      Colors.lightBlue,
                      Colors.lightBlueAccent
                    ]),
                    style: GoogleFonts.lato(
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                        color: Colors.blue),
                  )),
              const Gap(20),
              const Align(
                alignment: AlignmentDirectional(-1.00, 0.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(22, 0, 0, 0),
                  child: Text(
                    'Class Name :',
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                  child: TextField(
                    controller: _classid,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF3B8DFC),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF158BFF),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                      suffixIcon: Icon(
                        Icons.drive_file_rename_outline_sharp,
                        color: Color(0xFF158BFF),
                        size: 25,
                      ),
                    ),
                    style: GoogleFonts.getFont(
                      'Roboto',
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    cursorColor: const Color(0xFF3B8DFC),
                  )),
              Align(
                alignment: const AlignmentDirectional(0.00, 0.00),
                child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
                    child: SizedBox(
                      width: 100,
                      height: 40,
                      child: FloatingActionButton(
                        onPressed: () {
                          bstatus ? loginClass() : storeClass();
                        },
                        elevation: 3,
                        backgroundColor: const Color(0xE5FFFFFF),
                        foregroundColor: const Color(0xFF207DF6),
                        hoverElevation: 5,
                        hoverColor: Colors.black,
                        child: Text(
                          bstatus ? 'Join' : 'Create',
                          style: const TextStyle(
                              letterSpacing: 2,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
              ),
              const Text(
                'or',
                style: TextStyle(
                    fontFamily: 'Outfit',
                    color: Color(0xFF434343),
                    fontSize: 16),
              ),
              Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        bstatus = !bstatus;
                      });
                    },
                    child: Text(
                      bstatus ? "Create Instead" : "Join Instead",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
