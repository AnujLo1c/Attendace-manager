import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Classname_provider extends ChangeNotifier{
 String classname;

 Classname_provider({
   this.classname="def",


});
setclassname(String cname, BuildContext context ) {
  classname=cname;
  notifyListeners();
}
}
class Username_provider extends ChangeNotifier {
 String? username;

  Username_provider({
    this.username="sample"
});
  setusername(String? uname, BuildContext context) {
    username = uname;
    notifyListeners();
  }
}
