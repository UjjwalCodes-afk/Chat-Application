import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentbyme;
  const MessageTile({super.key, required this.message, required this.sender, required this.sentbyme});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.sentbyme ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: widget.sentbyme ? 0 : 24,
        right: widget.sentbyme ? 24:0,
      ),
      child: Container(
        margin: widget.sentbyme ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20,right: 20),
        decoration: BoxDecoration(
          borderRadius: widget.sentbyme ? BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ): BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          color: widget.sentbyme ? Colors.red : Colors.grey[700],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.sender.toUpperCase(), style: GoogleFonts.poppins(color: Colors.white, letterSpacing: -0.1), textAlign: TextAlign.center,),
            SizedBox(height: 8,),
            Text(widget.message, textAlign: TextAlign.center, style: GoogleFonts.poppins(),)
          ],
        ),
      ),
    );
  }
}