import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Profile extends StatefulWidget {
  String username;
  String email;
  Profile({Key? key, required this.username, required this.email}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.red,
      title: Padding(
        padding: const EdgeInsets.only(left: 80),
        child: Text("Profile", style: GoogleFonts.roboto(color:Colors.white,fontWeight:FontWeight.bold, fontSize: 27)),
      ),
    ),
    drawer: Drawer(
      child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.black,
            ),
            SizedBox(height: 10,),
            Text(widget.email, textAlign: TextAlign.center, style: GoogleFonts.poppins(color:Colors.black, fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Divider(height: 10, thickness: 1,),
            SizedBox(height: 10,),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              onTap: (){
                nextscreen(context, HomePage());
              },
              selected: true,
              selectedColor: Colors.red,
              leading: Icon(Icons.group),
              title: Text("Groups"),
              minLeadingWidth:50,
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              onTap: (){
              
              },
              selected: true,
              selectedColor: Colors.red,
              leading: Icon(Icons.group, color: Colors.black54,),
              title: Text("Profile"),
              minLeadingWidth:50,
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              onTap: ()async{
                showDialog(
                  barrierDismissible: false,
                  context: context,
                 builder: (context){
                  return AlertDialog(
                    title: Text("Logout"),
                    content: Text("Are you sure you want to logout"),
                    actions: [
                    ],
                  );
                });
                // authService.signOut().whenComplete((){
                //   nextscreenReplace(context, LoginPage());
                // });
                
              },
              selected: true,
              selectedColor: Colors.black87,
              leading: Icon(Icons.group),
              title: Text("Logout"),
              minLeadingWidth:50,
            ),

            
          ],
        ),
    ),
    body: Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 170),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.account_circle, size: 200,color: Colors.grey,),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Full name", style: GoogleFonts.poppins(fontSize:20),),
              SizedBox(width: 70,),
              Text(widget.username, style: GoogleFonts.poppins(fontSize: 17),),

            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Email", style: GoogleFonts.poppins(fontSize:20),),
              SizedBox(width: 70,),
              Text(widget.email, style: GoogleFonts.poppins(fontSize: 17),),
              
            ],
          ),
        ],
      ),
    ),
    );
  }
}