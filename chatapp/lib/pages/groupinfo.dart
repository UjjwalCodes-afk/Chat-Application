import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/services/databaseservice.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupInfo extends StatefulWidget {
  final String groupid;
  final String groupname;
  final String adminame;
  const GroupInfo({super.key, required this.groupid, required this.groupname, required this.adminame});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  @override
  void initState() {
    // TODO: implement initState
    getMembers();
    super.initState();
  }
  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }
  getMembers()async{
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getGroupembers(widget.groupid).then((value){
      setState(() {
        members = value;
      });
    });
  }
  String getName(String r){ 
    return r.substring(r.indexOf("_")+1);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Group Info", style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
        elevation: 0,
        backgroundColor: Colors.red,
        actions: [
          IconButton(onPressed: (){
            showDialog(
                  barrierDismissible: false,
                  context: context,
                 builder: (context){
                  return AlertDialog(
                    title: Text("Logout"),
                    content: Text("Are you sure you want to exit the group?"),
                    actions: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.cancel),
                      color: Colors.red,
                      ),
                      IconButton(onPressed: ()async{
                        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).ToggleGroupJoin(widget.groupid, getName(widget.adminame), widget.groupname).whenComplete((){
                          nextscreenReplace(context, HomePage());
                        });
                      }, icon: Icon(Icons.done,color: Colors.green,))
                      
                    ],
                  );
                });
          }, icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.red.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 30, backgroundColor: Colors.red, child: Text(widget.groupname.substring(0,1).toUpperCase(), style: GoogleFonts.poppins(),),),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Group : ${widget.groupname}", style: GoogleFonts.roboto(fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Text("Admin: ${getName(widget.adminame)}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold),)
                      
                    ],
                  ),
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),    
    );
  }
  memberList(){
    return StreamBuilder(
      stream:members,
      builder: (context,AsyncSnapshot snapshot){
        if(snapshot.hasData){
          if(snapshot.data['members']!=null){
            if(snapshot.data['members'].length!=0){
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data['members'].length,
                itemBuilder: ((context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.red,
                      child: Text(getName(snapshot.data['members'][index]).substring(0,1).toUpperCase(), style: GoogleFonts.roboto(fontWeight: FontWeight.bold),),
                      ),
                      title: Text(getName(snapshot.data['members'][index]), style: GoogleFonts.roboto(fontWeight: FontWeight.bold),),
                      subtitle: Text(getId(snapshot.data['members'][index]), style: GoogleFonts.roboto(fontWeight: FontWeight.bold),),
                    ),
                  );
                }),
              );
            }
          }else{
            return const Center(child: Text("No members"),);
          }
        }else{
          return const Center(child: CircularProgressIndicator(color: Colors.red,),);
        }
        return Text("no members");
      },
    );
  }
  
}