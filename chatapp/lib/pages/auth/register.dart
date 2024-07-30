import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/widgets.dart';
import '../home_page.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String value = "";
  bool loading = false;
  final _formkey1 = GlobalKey<FormState>();
  String fullname = "";
  String registeremail = "";
  String registerpassword = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor),): SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
          child: Form(
            key: _formkey1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("Groupie", style: GoogleFonts.poppins(fontSize: 32,fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("Login to see what others are typing",style: GoogleFonts.roboto(fontSize: 15),),
                ),
                Image.asset("images/register.png"),
                TextFormField(
                  decoration: fullnamedec,
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter your name";
                    }
                  },
                  onChanged: (value){
                    setState(() {
                      fullname = value;
                      print(fullname);
                    });
                  },
                ),
                SizedBox(height: 10,),
                TextFormField(
                  decoration: textinputdecoration.copyWith(
                    labelText: "email",
                  ),
                  onChanged: (value){
                    setState(() {
                      registeremail = value;
                      print(registeremail);
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
                      registerpassword = value;
                      print(registerpassword);
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
                  if(_formkey1.currentState!.validate()){
                    setState(() {
                      loading = true;
                    });
                    await authService.registerUserWithEmailandPassword(fullname, registeremail, registerpassword).then((value)async{
                      if(value==true){
                        //saving the shared prefernces state
                        await HelperFunctions.saveUserLoggedInStatus(true);
                        await HelperFunctions.saveUserEmail(registeremail);
                        await HelperFunctions.saveUserNameSf(fullname);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
                        nextscreenReplace(context, const HomePage());
                        

                      }
                      else{
                        showSnackBar(context, value, Colors.red);
                        setState(() {
                          loading = false;
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
                 child: Text("Register", style: GoogleFonts.poppins(color:Colors.white,fontWeight: FontWeight.bold),)),
                 SizedBox(height: 10,),
                //  Text.rich(
                //   TextSpan(
                //     text: "Dont have an account? ",
                //     children: [
                //       TextSpan(
                //         text: "Register here",
                //         style: const TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                //         recognizer: TapGestureRecognizer()..onTap = (){
                //           Navigator.push(context, MaterialPageRoute(builder: (context)=> Register()));
                //         }
                //       ),
                //     ]
                    
                //   ),
                //   style: TextStyle(color: Colors.black, fontSize: 15),
                //  ),
                
                
              ],
            ),
          ),
        ),
      ),
    );
      
    
  }
}