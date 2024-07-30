
import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/auth/login.dart';
import 'package:chatapp/pages/profile.dart';
import 'package:chatapp/pages/searchpage.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/services/databaseservice.dart';
import 'package:chatapp/widgets/group_tile.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "";
  String email = "";
  String groupname = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isloading = false;
  late int reverseIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }
  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }
  String getName(String res){
    return res.substring(res.indexOf("_")+1);
  }
  gettingUserData()async{
    await HelperFunctions.getUserEmailFromSf().then((value){
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSf().then((value){
      setState(() {
        username = value!;
      });
    });
    //getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot){
      setState(() {
        groups = snapshot;
      });
    });
  }
  
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(onPressed: (){
            nextscreen(context, SearchPage());
          }, icon: Icon(Icons.search))
        ],
        backgroundColor: Colors.red,
        centerTitle: true,
        title:  Text("Groups", style: GoogleFonts.poppins(color:Colors.white),),
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
            Text(email, textAlign: TextAlign.center, style: GoogleFonts.poppins(color:Colors.black, fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Divider(height: 10, thickness: 1,),
            SizedBox(height: 10,),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              onTap: (){},
              selected: true,
              selectedColor: Colors.red,
              leading: Icon(Icons.group),
              title: Text("Groups"),
              minLeadingWidth:50,
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              onTap: (){
                nextscreen(context, Profile(username: username, email: email,));
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
                      IconButton(onPressed: ()async{
                        Navigator.of(context).pop();
                      }, icon: Icon(Icons.cancel, color: Colors.red,)),
                      IconButton(onPressed: ()async{
                        await authService.signOut();
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (content)=> LoginPage()), (route) => false);
                      }, icon: Icon(Icons.done, color: Colors.red,)),
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Colors.red,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
  popUpDialog(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context, builder: (context){
      return StatefulBuilder(
        builder: ((context,setState){;
        return AlertDialog(
          title: Text("Create a group", style: GoogleFonts.poppins(color: Colors.black), textAlign: TextAlign.left,),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _isloading == true
               ? Center(
                child: 
                CircularProgressIndicator(color: Colors.red),)
                : TextField(
                  style: GoogleFonts.roboto(color: Colors.black),
                  onChanged: (val){
                    setState(() {
                      groupname = val;
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
            ],
          ),
          actions: [
            ElevatedButton(onPressed: (){
              Navigator.of(context).pop();
            }, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red
            ),
            child: Text("Cancel", style: GoogleFonts.roboto(color:Colors.white, fontWeight: FontWeight.bold),)),
            ElevatedButton(onPressed: (){
              if(groupname!= " "){
                setState(() {
                  _isloading = true;
                });
                DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createGroup(username, FirebaseAuth.instance.currentUser!.uid, groupname).whenComplete((){
                  _isloading = false;
                });
                Navigator.of(context).pop();
                showSnackBar(context, "Group created Successfully", Colors.red);
              }
            }, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red
            ),
            child: Text("Create", style: GoogleFonts.roboto(color:Colors.white, fontWeight: FontWeight.bold),))
          ],
        );
        })
      );
    });
  }
  groupList(){
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot){
        //make some checks
        if(snapshot.hasData){
          if(snapshot.data['groups']!=null){
            if(snapshot.data['groups'].length!=0){
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context,index){
                  reverseIndex = snapshot.data['groups'].length-index-1;
                  return GroupTile(username: snapshot.data["fullName"], groupid: getId(snapshot.data['groups'][reverseIndex]), groupname: getName(snapshot.data['groups'][reverseIndex]));
                },
              );
            }else{
              return noGroupWidget();
            }
          }else{
            return noGroupWidget();
          }
        }else{
          return Center(
            child: CircularProgressIndicator(color: Colors.red,),
          );
        }
      },
    );
  }
  noGroupWidget(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              popUpDialog(context);
            },
          child: Icon(Icons.add_circle, color: Colors.grey.shade700, size: 75,)),
          SizedBox(height: 50,),
          Text("You have not joined any Groups yet, Tap on the add icon to create a group and also search from the top search button", textAlign: TextAlign.center, style: GoogleFonts.roboto(fontWeight: FontWeight.w500),),

        ],
      ),
    );
  }
}