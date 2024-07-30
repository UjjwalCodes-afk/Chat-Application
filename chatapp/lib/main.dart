import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/auth/login.dart';
import 'package:chatapp/pages/home_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options : DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUSerLoggedInStatus();

  }
  getUSerLoggedInStatus()async{
    await HelperFunctions.getUSerLoggedInStatus().then((value){
      if(value!=null){
        setState(() {
          isSignedIn = true;
        });

      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter demo',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: isSignedIn?const HomePage() : LoginPage(),
    );
  }
}