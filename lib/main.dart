import 'package:attendance/Screens/ClassLogin.dart';
import 'package:attendance/Screens/Splash_screen.dart';
import 'package:attendance/Screens/hp.dart';
import 'package:attendance/Screens/lrp.dart';
import 'package:attendance/connections/Classname_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Username_provider()),
          ChangeNotifierProvider(create: (_) => Classname_provider()),
        ],
        child: const MyApp(),
      )
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
    debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
hp.routeName :(context)=> hp(docId: ModalRoute.of(context)?.settings.arguments as String),
        Splash_screen.routeName :(context)=> const Splash_screen(),
        lrp.routeName :(context)=> const lrp(),
        ClassLogin.routeName:(context)=>const ClassLogin()

      },
      initialRoute: Splash_screen.routeName,
      // home: const lrp(),
    );
  }
}
