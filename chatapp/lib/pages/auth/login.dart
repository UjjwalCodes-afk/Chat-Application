
import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/auth/register.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/services/databaseservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/widgets.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage>{
  AuthService authService = AuthService();
  bool isloading = false;
  final _formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("Lets Make Groups", style: GoogleFonts.poppins(fontSize: 32,fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("Login to see what others are typing",style: GoogleFonts.roboto(fontSize: 15),),
                ),
                Image.asset("images/login.png"),
                TextFormField(
                  decoration: textinputdecoration,
                  onChanged: (value){
                    setState(() {
                      email = value;
                      print(email);
                    });
                  },
                  validator: (value){
                    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)?null:"Please enter a value";
                  },
                ),
                SizedBox(height: 10,),
                TextFormField(
                  decoration: passwordecoration,
                  obscureText: true,
                  onChanged: (value){
                    setState(() {
                      password = value;
                      print(password);
                    });
                  },
                  validator: (value){
                    if(value!.length<6){
                      return "password must be atleast 6 characters";
                    }else{
                      return null;
                    }
                  },
                ),
                SizedBox(height: 10,),
                ElevatedButton(onPressed: ()async{
                  if(_formkey.currentState!.validate()){
                    setState(() {
                      isloading = true;
                    });
                    await authService.loginWithUserNameAndPassword(email, password).then((value)async{
                      if(value==true){
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
                       QuerySnapshot snapshot =  await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);

                       //saving the values to our shared prefernces
                       await HelperFunctions.saveUserLoggedInStatus(true);
                       await HelperFunctions.saveUserEmail(email);
                       await HelperFunctions.saveUserNameSf(snapshot.docs[0]["fullName"]);
                       Navigator.push(context, MaterialPageRoute(builder: (content)=> HomePage()));
                      }else{
                        showSnackBar(context, value, Colors.red);
                        setState(() {
                          isloading = false;
                        });
                      }

                    });


                  }
                  

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.only(left: 100,right: 100),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  
                ),
                 child: Text("Sign in", style: GoogleFonts.poppins(color:Colors.white,fontWeight: FontWeight.bold),)),
                 SizedBox(height: 10,),
                 Text.rich(
                  TextSpan(
                    text: "Dont have an account? ",
                    children: [
                      TextSpan(
                        text: "Register here",
                        style: const TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Register()));
                        }
                      ),
                    ]
                    
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 15),
                 ),
                
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}