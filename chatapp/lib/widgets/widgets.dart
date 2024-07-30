

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const textinputdecoration = InputDecoration(
  prefixIcon: Icon(Icons.email,color: Colors.red,),
  hintText: "Email",
  labelStyle: TextStyle(color: Colors.black),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red,width: 2),
  )


);

const passwordecoration = InputDecoration(
  prefixIcon: Icon(Icons.lock, color: Colors.red,),
  hintText: "Password",
  labelStyle: TextStyle(color: Colors.black),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
      width: 2,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red,width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red,width: 2),
  ),
);

const fullnamedec = InputDecoration(
  prefixIcon: Icon(Icons.person, color: Colors.red,),
  hintText: "Full Name",
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red,width: 2),
  )
);

void showSnackBar(context,message,color){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message, style: GoogleFonts.poppins(fontSize: 15),),
     backgroundColor: color,
     duration: Duration(seconds: 2),
     action: SnackBarAction(label: "OK", onPressed: (){},textColor: Colors.white,),
     ),
     );
}

void nextscreenReplace(context,page){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (content)=> page));
}
void nextscreen(content,page){
  Navigator.push(content, MaterialPageRoute(builder: (context)=>page));
}