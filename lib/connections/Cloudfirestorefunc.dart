import 'dart:core';
import 'dart:ui';

import 'package:attendance/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:attendance/connections/Classname_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/hp.dart';

class Cloudfirestorefunc with ChangeNotifier {
  CollectionReference classids =
      FirebaseFirestore.instance.collection("class");
  CollectionReference studentid =
      FirebaseFirestore.instance.collection("class");


  addSubToDoc(String name, int totalclasses, String cname, String? email) async {
    classids.doc(cname).update({name: totalclasses});

    var docs= classids.doc(cname).collection("students");
QuerySnapshot data=await docs.get();
    var allData = data.docs.map((doc) => doc.id).toList();
    for(int i=0;i<allData.length;i++){
      docs.doc(allData.elementAt(i)).update({name: totalclasses});
    }
    notifyListeners();
  }

  getCorU(String name, BuildContext context) {
    if (name == "classname") {
      return Provider.of<Classname_provider>(context, listen: false).classname;
    } else if (name == "username") {
      return Provider.of<Username_provider>(context, listen: false).username;
    }
  }

  getData(BuildContext context) async {
    String cname = getCorU("classname", context);
    print(cname);
    DocumentSnapshot ds = await classids.doc(cname).get();
    Map<String, dynamic>? data = ds.data() as Map<String, dynamic>?;
    // dynamic data=ds.data();
    print("get data functin data $data");
    return data;
  }

setinitvalue( BuildContext context)async{
    print("hellp ${await getData(context)}");
  Map studata=await getData(context);
  Map<dynamic,dynamic> finalsdata={};
  studata.forEach((key, value) {
    finalsdata[key]=0;
  });
  // print(finalsdata);
  return finalsdata;
}

//   setUserid(String? uname, BuildContext context) async {
//     CollectionReference studentids =
//         FirebaseFirestore.instance.collection("studentids");
//
//     String cname = getCorU("classname", context);
//     print("Classname is $cname");
//     Map<String, dynamic> m = <String, dynamic>{};
//     int? _count = await studentids
//         .where('ClassName', isEqualTo: cname)
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       int count = querySnapshot.docs.length; // this is the count of student IDs
//       return count;
//     });
//
//     if (_count == null || _count == 0) {
//       m["Auth"] = true;
//       studentids.doc(uname).set(m);
//       studentids.doc(uname).update({"ClassName": cname});
//     } else {
//       m["Auth"] = false;
//       studentids.doc(uname).set(m);
//       studentids.doc(uname).update({"ClassName": cname});
//       /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// print(setinitvalue(context));
//       studentids.doc(uname).update({
//         "Subjects": setinitvalue(context)
//         // "Subjects": FieldValue.arrayUnion([temp])
//       });
//
//       ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//     }
//   }

  getStudentSubData(BuildContext context, uname) async{
    // String? sname=Auth().currentUser?.email;
    SharedPreferences spf=await SharedPreferences.getInstance();

    String? cname=spf.getString('class');
    String? sname=spf.getString('username');
    print("//////////////////////////////////////////////////////////////////////////////////");
    print(uname);
    print(cname);
    print(sname);

    DocumentSnapshot ds = await studentid.doc(cname).collection("students").doc(sname).get();
    print("data");
    print(ds.data());
    Map<String, dynamic>? data = ds.data() as Map<String, dynamic>?;
    print("map");
    print(data);
    return data;

  }

  incrementsubpresent( indexname, currentp,context,set,user)async{
// print(Provider.of<Classname_provider>(context,listen: false).classname);
// print(user);
    var temp=classids.doc(Provider.of<Classname_provider>(context,listen: false).classname).collection("students").doc(user);
    if(set==true){
    temp.update({
      indexname :currentp
    });
    }
    else{

    temp.update({
      indexname :currentp+1
    });
    }
    // Fluttertoast.showToast(msg: "added $indexname $currentp");
  }

  void incrementTotalclass(subname, BuildContext context, value) async{
   await classids.doc(Provider.of<Classname_provider>(context,listen: false).classname).update({subname:value});
  }

}
