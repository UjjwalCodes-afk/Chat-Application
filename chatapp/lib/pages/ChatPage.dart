import 'package:chatapp/pages/groupinfo.dart';
import 'package:chatapp/services/databaseservice.dart';
import 'package:chatapp/widgets/message_tile.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  final String username;
  final String groupid;
  final String groupname;
  const ChatPage({super.key, required this.username, required this.groupid, required this.groupname});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";

  @override
  void initState() {
    // TODO: implement initState
    getChatAndAdmin();
    super.initState();
  }
  getChatAndAdmin(){
    DatabaseService().getChats(widget.groupid).then((val){
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupid).then((value){
      setState(() {
        admin = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text(widget.groupname, style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(onPressed: (){
            nextscreen(context, GroupInfo(
              groupid: widget.groupid,
              groupname: widget.groupname,
              adminame: admin,
            ));
          }, icon:Icon(Icons.info))
        ],
      ),
      body: Stack(
        children: [
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[700],
              child: Row(
                children: [
                  Expanded(child: TextFormField(
                    controller: messageController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Send a message...",
                      hintStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                      border: InputBorder.none,
                    ),
                  )),
                  SizedBox(width: 12,),
                  GestureDetector(
                    onTap: (){
                      sendMessages();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.red,
                      ),
                      child: Icon(Icons.send, color: Colors.white,),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot){
        return snapshot.hasData
         ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context,index){
            return MessageTile(message: snapshot.data.docs[index]['message'], sender: snapshot.data.docs[index]['sender'], sentbyme: widget.username == snapshot.data.docs[index]['sender']);
          },
         ):
         Container();
      },
    );
  }
  sendMessages(){
    if(messageController.text.isNotEmpty){
      Map<String, dynamic> chatMessagesMap = {
        "message" : messageController.text,
        "sender" : widget.username,
        "time" : DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseService().sendMessages(widget.groupid, chatMessagesMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}