import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pages/ChatPage.dart';

class GroupTile extends StatefulWidget {
  final String username;
  final String groupid;
  final String groupname;
  const GroupTile({super.key, required this.username, required this.groupid, required this.groupname});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        nextscreen(context, ChatPage(username: widget.username ,groupid: widget.groupid,groupname: widget.groupname,));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.red,
            child: Text(widget.groupname.substring(0,1).toUpperCase(), textAlign: TextAlign.center, style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: Colors.white),),
          ),
          title: Text(widget.groupname, style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold),),
          subtitle: Text("Join the conversation as ${widget.username}", style: GoogleFonts.poppins(color: Colors.black ),),
        ),
      ),
    );
  }
}