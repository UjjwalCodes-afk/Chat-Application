import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/ChatPage.dart';
import 'package:chatapp/services/databaseservice.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchcontroller = TextEditingController();
  bool isloading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  bool isJoined = false;
  String username = "";
  User? user;
  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }
  String getName(String r){ 
    return r.substring(r.indexOf("_")+1);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserIdAndName();
  }
  getCurrentUserIdAndName()async{
    await HelperFunctions.getUserNameFromSf().then((value){
      setState(() {
        username = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red,
        title: Padding(
          padding: const EdgeInsets.only(left: 90),
          child: Text("Search", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search groups...",
                      hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.white),
                    ),
                    controller: searchcontroller,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    initiatesearchmethod();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(Icons.search, color: Colors.white,),
                  ),
                ),
              ],
            ),
          ),
          isloading ? Center(child: CircularProgressIndicator(color: Colors.red,),) : groupList(),
        ],
      ),
    );
  }
  initiatesearchmethod()async{
    if(searchcontroller.text.isNotEmpty){
      setState(() {
        isloading = true;
      });
      await DatabaseService().searchbyname(searchcontroller.text).then((snapshot){
        setState(() {
          searchSnapshot = snapshot;
          isloading = false;
          hasUserSearched = true;
        });
      });
    }

  }
  groupList(){
    return hasUserSearched 
    ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchSnapshot!.docs.length,
      itemBuilder: (context,index){
        return groupTile(
          username,
          searchSnapshot!.docs[index]['groupId'],
          searchSnapshot!.docs[index]['groupName'],
          searchSnapshot!.docs[index]['admin']
        );
      },
    ) 
    : Container();
  }
  joinedornot(String userName, String groupId, String groupName, String admin)async{
    await DatabaseService(uid: user!.uid).isUserJoined(groupName, groupId, userName).then((value){
      setState(() {
        isJoined = value;
      });
    });
  }
  Widget groupTile(String username, String groupId, String groupname, String admin){
    joinedornot(username,groupId,groupname, admin);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.red,
        child: Text(groupname.substring(0,1).toUpperCase(), style: GoogleFonts.poppins(fontWeight:FontWeight.bold),),
      ),
      title: Text(groupname, style: GoogleFonts.poppins(fontWeight:FontWeight.bold),),
      subtitle: Text("Admin : ${getName(admin)}"),
      trailing: InkWell(
        onTap: ()async{
          await DatabaseService(uid: user!.uid)
          .ToggleGroupJoin(groupId, username, groupname);
          if(isJoined){
            setState(() {
              isJoined = !isJoined;
            });
            showSnackBar(context, "Joined the group successfully", Colors.green);
            Future.delayed(Duration(seconds: 2), (){
              nextscreen(context, ChatPage(username: username, groupid: groupId, groupname: groupname));
            });
            setState(() {
              isJoined = !isJoined;
              showSnackBar(context, "Left the group $groupname", Colors.red);
            });

          }
        },
        child: isJoined? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 1)
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text("Joined", style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
        ) : Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 1)
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text("Join Now", style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
  
}