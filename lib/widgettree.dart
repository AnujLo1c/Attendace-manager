import 'package:attendance/Screens/ClassLogin.dart';
import 'package:attendance/auth.dart';

import 'package:flutter/material.dart';
class widgettree extends StatefulWidget {
  late bool ch;
   widgettree(bool check, {super.key}){
     ch=check;
   }
  @override
  State<widgettree> createState() => _widgettreeState(ch);
}

class _widgettreeState extends State<widgettree> {
  late bool c;
  _widgettreeState(check){c=check;}
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: Auth().authStateChanges,
        builder: (context,snapshot){
if(snapshot.hasData)
{
  print("snapshots data ${snapshot.data}");
  return ClassLogin();
}
  else{
    return const ClassLogin();
}

  });}
}
