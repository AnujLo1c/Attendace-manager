import 'package:attendance/Screens/ClassLogin.dart';
import 'package:attendance/Screens/lrp.dart';
import 'package:attendance/connections/Cloudfirestorefunc.dart';
import 'package:attendance/connections/Shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:attendance/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../GradientText.dart';
import '../connections/Classname_provider.dart';

////////////////////////////For new class/////////////////////////////////////
class hp extends StatefulWidget {
  static String routeName="home_page";
  final String docId;
  hp({super.key,required this.docId});

  @override
  State<hp> createState() => _hpState();
}

class _hpState extends State<hp> {
  final User? user = Auth().currentUser;

  final TextEditingController _subname = TextEditingController();

  final TextEditingController _tclasses = TextEditingController();
  var lname = [], ltclass = [], present = [];

  @override
  void dispose() {
    // TODO: implement dispose
    signOut();
    _subname.clear();
    _tclasses.clear();
    super.dispose();
  }

  @override
  initState() {
    // Cloudfirestorefunc().setUserid(user?.email, context);

    fetchDataFromFirestore();

    super.initState();
  }
Map? usersubdata;

  Future<void> fetchDataFromFirestore() async {
    Map? subdetail = await Cloudfirestorefunc().getData(context);
 usersubdata = await Cloudfirestorefunc().getStudentSubData(context,user);
    lname.clear();
    ltclass.clear();
    present.clear();
    context.read<Username_provider>().setusername(user?.email, context);
    print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
print(usersubdata);
print(subdetail);
    if(subdetail!=null && subdetail.isNotEmpty) {
      subdetail.forEach((key, value) {
        if(key!='id') {
          lname.add(key);
          ltclass.add(value);
          present.add(usersubdata?[key]);
        }
        });

    }
    setState(() {});
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _userId(){

    String? s=(user!=null)?user?.email:"";
    return GradientText(
      s ?? "Some error",
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      gradient: const LinearGradient(
          colors: [Colors.black45, Colors.black54, Colors.black38]),
    );
  }

  Widget _signoutbuttonhp() {
    return TextButton(
      onPressed: () {
        Navigator.popUntil(context,(route)=>route.settings.name==lrp.routeName,);
      },
      child: const Icon(color: Colors.blue, size: 30, Icons.exit_to_app),
    );
  }

  Widget _simpledialog(BuildContext context) {
    return SimpleDialog(
      alignment: Alignment.center,
      backgroundColor: Colors.grey.shade100,
      elevation: 5,
      shadowColor: Colors.black,
      title: Text(
        'Add Subject :',
        style: GoogleFonts.kdamThmorPro(fontSize: 20),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: TextField(
                  controller: _subname,
                  style: TextStyle(
                      backgroundColor: Colors.grey.shade50,
                      color: Colors.black,
                      fontSize: 20),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: WidgetStateColor.resolveWith(
                        (states) => Colors.grey.shade50),
                    border: const GradientOutlineInputBorder(
                      gradient:
                          LinearGradient(colors: [Colors.black, Colors.grey]),
                      width: 2,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    focusedBorder: const GradientOutlineInputBorder(
                      gradient:
                          LinearGradient(colors: [Colors.grey, Colors.black]),
                      width: 2,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              ),
              const Gap(5),
              Row(
                children: [
                  const Gap(9),
                  const Text(
                    "Total classes :",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const Gap(4),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: _tclasses,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      decoration: const InputDecoration.collapsed(
                        border: InputBorder.none,
                        hintText: ' ',
                      ),
                    ),
                  ),
                  const Gap(10),
                  SizedBox(
                    height: 55,
                    width: 70,
                    child: TextButton(
                      onPressed: () {
                        String cname = Provider.of<Classname_provider>(context,
                                listen: false)
                            .classname;

                          Cloudfirestorefunc().addSubToDoc(_subname.text,
                              int.parse(_tclasses.text), cname, user?.email);
                          // fetchDataFromFirestore();
                          lname.add(_subname.text);
                          ltclass.add(int.parse(_tclasses.text));
                          present.add(0);
                          setState(() {});

                        Navigator.pop(context, true);
                      },
                      // color: Colors.blue,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateColor.resolveWith(
                            (states) => Colors.blue.shade500),
                        side: WidgetStateProperty.resolveWith((states) =>
                            const BorderSide(color: Colors.white, width: 2)),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10)
            ],
          ),
        )
      ],
    );
  }

  void _showdialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return _simpledialog(context);
      },
    );
  }

  void _datamodifydialog(BuildContext context, int index) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => pmdialog(context, index),
    );
  }

  TextEditingController presentmodifycontroller = TextEditingController();
  TextEditingController totalmodifycontroller = TextEditingController();

  Widget pmdialog(BuildContext context, int index) {
    return SimpleDialog(
        alignment: Alignment.center,
        backgroundColor: Colors.grey.shade100,
        elevation: 5,
        shadowColor: Colors.black,
        title: Text(
          "Modify ${lname.elementAt(index)}",
          style: GoogleFonts.kdamThmorPro(fontSize: 22),
        ),
        children: <Widget>[
          Row(
            children: [
const Gap(30),
               Text(
                "Total :   ",
                style: GoogleFonts.robotoSlab(fontSize: 20),
              ),
              Container(
                width: 38,
                height: 28,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: totalmodifycontroller,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  decoration: const InputDecoration.collapsed(
                    border: InputBorder.none,
                    hintText: ' ',
                  ),
                ),
              ),
              const Gap(5),
              ///////////////////////////////////////////////////////////////////
              GestureDetector(
                onTap: (){
                  /////
                  print(usersubdata);
                  if(usersubdata==null){
                    Fluttertoast.showToast(msg: "Error fatching user data.");
                  }
                  else if(usersubdata?["host"]) {
                    ltclass[index] = ltclass.elementAt(index) + 1;
                    setState(() {});
                    Cloudfirestorefunc().incrementTotalclass(
                        lname.elementAt(index),
                        context,
                        ltclass.elementAt(index));
                    Fluttertoast.showToast(
                        msg: "Total Class to ${ltclass.elementAt(index)}");
                    Navigator.pop(context, true);
                  }
                  else{
                    Fluttertoast.showToast(msg: "You can only modify presents."
                        );
                  }
                  ////

                },
                child: Container(
width: 131,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15))

                  ),
                  child: Row(
                    children: [
                      const Gap(5),
                       const Icon(
                          Icons.arrow_upward_outlined,size: 25,
                        color: Colors.green,
                        ),

                      Text(" Increment",style: GoogleFonts.ibmPlexSans(fontSize: 16),)
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Gap(10),
          Row(
            children: [
              const Gap(30),
              Text(
                "Present :   ",
                style: GoogleFonts.robotoSlab(fontSize: 20),
              ),
              Container(
                width: 38,
                height: 28,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: presentmodifycontroller,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  decoration: const InputDecoration.collapsed(
                    border: InputBorder.none,
                    hintText: ' ',
                  ),
                ),
              ),

            ],
          ),
          const Gap(10),
          GestureDetector(

            onTap: (){
              modifyuilevel(index);

              },
            child: Container(
              height: 40,

              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: Colors.blue,
              ),
              child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Apply",
                    style: TextStyle(
                      letterSpacing: 4,
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  )),
            ),
          )
        ]);
  }

  Widget _list() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 12, left: 12),
        child: ListView.separated(
          itemCount: lname.length,
          // padding: EdgeInsets.only(right: 30,left: 30),

          itemBuilder: (context, index) => _listTile(index),
          separatorBuilder: (context, index) => const Gap(12),
        ),
      ),
    );
  }

  Color determineColor(double val) {
    // Replace this logic with your own condition to determine the color
    if (val <= .60) {
      return Colors.red.shade300;
    } else if (val <= .74) {
      return Colors.yellow.shade300;
    } else {
      return Colors.lightBlue.shade300;
    }
  }

  Widget _listTile(int index) {
    return GestureDetector(
      onTap: () {
        _datamodifydialog(context, index);
      },
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          shape: BoxShape.rectangle,
          // border: Border.all(color: Colors.grey.shade900, width: 2),
          gradient: LinearGradient(
            colors: gradientDeterminer(index),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 14, top: 10),
          child: Row(
            children: [
              Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 190,
                    child: Text(
                      lname.elementAt(index),
                      maxLines: 2,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "Total Classes: ${ltclass.elementAt(index).toString()}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Present: ${present.elementAt(index)}",
                    // "Present: asdf",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Absent: ${
                        (ltclass.elementAt(index))
                        // 1- 5
                    -
                            present.elementAt(index)
                    }",
                    // "temp",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 120,
                height: 120,
                child: GestureDetector(
                  onTap: () {
                    if (present.elementAt(index) < ltclass.elementAt(index)) {
                      Cloudfirestorefunc().incrementsubpresent(
                          lname.elementAt(index), present.elementAt(index),context,false,user?.email);
                    present[index]++;
                    }
                    else {
                      Fluttertoast.showToast(
                          msg: "Present cannot exceed Total classes ");
                    }
                    setState(() {});
                  },
                  child: LiquidCircularProgressIndicator(
                    value: present.elementAt(index) / ltclass.elementAt(index),
                    // value: .5,
                    // Defaults to 0.5.
                    valueColor: AlwaysStoppedAnimation(determineColor(

                      60
                    )),

                    // Defaults to the current Theme's accentColor.
                    backgroundColor: Colors.white,
                    // Defaults to the current Theme's backgroundColor.
                    borderColor: Colors.white,
                    borderWidth: 2.0,
                    direction: Axis.vertical,

                    center: Text(
                        // ((present.elementAt(index) / ltclass.elementAt(index)) *
                        (1 *
                                100)
                            .toStringAsFixed(2)),

                    // center: Text("${present.runtimeType}        ${ltclass.runtimeType}        ${lname.runtimeType}"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return PopScope(
    canPop: false
    ,child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
      //         leading: Center(
      //             child: SizedBox(
      //           width: 30,
      //           height: 30,
      //           child: GestureDetector(
      //             onTap: () {
      // Navigator.pop(context);
      //             },
      //             child: Image.asset(
      //               "assets/backlogo.png",
      //               fit: BoxFit.contain,
      //             ),
      //           ),
      //         )),
          title: _userId(),
          actions: [
            InkWell(
              onTap: (){
                Clipboard.setData(ClipboardData(text: widget.docId));
                Fluttertoast.showToast(msg: "Class id copied: ${widget.docId}");
              },
              child: Icon(color: Colors.blue,Icons.copy_all),
            ),
            _signoutbuttonhp(),
          ],
        ),
        body: SizedBox(
          // alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const Gap(10),
              // ListView.builder(
              _list(),
              const Gap(14)
              // )
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 16),
          child: FloatingActionButton(
              onPressed: () {
                print("?????????????????????????????????????????");
                print(usersubdata);
                if(usersubdata==null){
                  Fluttertoast.showToast(msg: "Error fatching user data.");
                }
                else if(usersubdata?["host"]) {
                  _showdialog(context);
                }
                else{
                  Fluttertoast.showToast(msg: "You are not host.");
                }
              },
              backgroundColor: Colors.grey.shade100,
              elevation: 10,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    width: 3,
                    color: Colors.grey.shade700,
                  )),
              child: const Icon(Icons.add)),
        ),
      ),
    );
  }

  modifyuilevel(int index) {
    dynamic total = (totalmodifycontroller.text.isEmpty)
        ? -1
        : int.parse(totalmodifycontroller.text);

    dynamic pres = (presentmodifycontroller.text.isEmpty)
        ? -1
        : int.parse(presentmodifycontroller.text);
    if (total != -1 && pres != -1) {
      ///////////
      print(usersubdata);
      if(usersubdata==null){
        Fluttertoast.showToast(msg: "Error fatching user data.");

      }
      else if(usersubdata?["host"]) {
        if (total >= pres) {
          ltclass[index] = total;
          present[index] = pres;
          Cloudfirestorefunc()
              .incrementTotalclass(lname.elementAt(index), context, total);
          Cloudfirestorefunc().incrementsubpresent(lname.elementAt(index), pres,context,true,user?.email);
        }
        else {
          Fluttertoast.showToast(
              msg: "Total classes should be greater than present");
        }
      }
      else{
        Fluttertoast.showToast(msg: "You are not host.");
      }
      /////////

    } else if (total != -1) {
      /////////
      print(usersubdata);
      if(usersubdata==null){
        Fluttertoast.showToast(msg: "Error fatching user data.");

      }
      else if(usersubdata?["host"]) {
        if (total >= present.elementAt(index)) {
          ltclass[index] = total;
          Cloudfirestorefunc()
              .incrementTotalclass(lname.elementAt(index), context, total);
        }
        else {
          Fluttertoast.showToast(
              msg: "Total classes can't be less than present.");
        }
      }
      else{
        Fluttertoast.showToast(msg: "You are not host.");
      }
      ///////



    } else if (pres != -1) {
      if (ltclass.elementAt(index) >= pres) {
        present[index] = pres;
        Cloudfirestorefunc().incrementsubpresent(lname.elementAt(index), pres,context,true,user?.email);
      } else {
        Fluttertoast.showToast(
            msg: "Total classes can't be less than present.");
      }
    } else {
      Fluttertoast.showToast(msg: "No Modificaiton made.");
    }
    setState(() {});
    Navigator.pop(context, true);
  }

  gradientDeterminer(int index) {
    List gradients = [];
    gradients.add([Colors.lightBlue.shade400, Colors.lightBlue.shade100]);
    gradients.add([Colors.red.shade400, Colors.red.shade200]);
    gradients.add([Colors.lime.shade300, Colors.lime.shade50]);
    gradients.add([Colors.green.shade400, Colors.green.shade100]);
    gradients.add([Colors.purple.shade300, Colors.purple.shade50]);
    gradients.add([Colors.amber.shade300, Colors.amber.shade50]);
    gradients.add([Colors.pink.shade300, Colors.pink.shade50]);
    return gradients[index % 7];
  }
}
