import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String? uid;

  DatabaseService({this.uid});

  //reference for our collections
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection("groups");

  //updating the user data

  Future updateUserData(String fullname, String email)async{
    return await userCollection.doc(uid).set({
      "fullName" : fullname,
      "email" : email,
      "groups" : [],
      "profilePic" : "",
      "uid" : uid,
    });


  }
  Future gettingUserData(String email)async{
    QuerySnapshot snapshot = await userCollection.where("email",isEqualTo: email).get();
    return snapshot;
  }

  //get user groups
  getUserGroups()async{
    return userCollection.doc(uid).snapshots();
  }
  Future createGroup(String username, String id, String groupname)async{
    DocumentReference groupdocumentReference = await groupCollection.add({
      "groupName" : groupname,
      "groupIcon": "",
      "admin":"${id}_$username",
      "members": [],
      "groupId":"",
      "recentMessage":"",
      "recentMessageSender":"",

      
    });
    //update the members
    await groupdocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$username"]),
      "groupId":groupdocumentReference.id,
    });
    DocumentReference userdocumentReference = userCollection.doc(uid);
    return userdocumentReference.update({
      "groups":FieldValue.arrayUnion(["${groupdocumentReference.id}_$groupname"])
    });
  }

  getChats(String groupId)async{
    return groupCollection.doc(groupId).collection("messages").orderBy("time").snapshots();
  }
  Future getGroupAdmin(String groupId)async{
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot["admin"]; 
  }
  getGroupembers(String groupid)async{
    return groupCollection.doc(groupid).snapshots();
  }
  //search
  searchbyname(String groupName){
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }
  Future<bool> isUserJoined(String groupName,String groupId, String userName)async{
    DocumentReference userdocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userdocumentReference.get();

    List<dynamic> groups = await documentSnapshot["groups"];
    if(groups.contains("${groupId}_$groupName")){
      return true;
    }else{
      return false;
    }
  
  }

  //toggling the group join/exit
  Future ToggleGroupJoin(String groupId, String userName, String groupName)async{
    //doc reference
    DocumentReference userdocumentReference = userCollection.doc(uid);
    DocumentReference groupdocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userdocumentReference.get();
    List<dynamic> groups = await documentSnapshot["groups"];

    //if user has our groups => then remove them or rejoin
    if(groups.contains("${groupId}_$groupName")){
      await userdocumentReference.update({
        "groups" : FieldValue.arrayRemove(["${groupId}_$groupName"]),
      });
      await groupdocumentReference.update({
        "members" : FieldValue.arrayRemove(["${uid}_$userName"]),
      });
    }else{
      await userdocumentReference.update({
        "groups" : FieldValue.arrayUnion(["${groupId}_$groupName"]),
      });
      await groupdocumentReference.update({
        "members" : FieldValue.arrayUnion(["${uid}_$userName"]),
      });
    }
  }

  //send data
  sendMessages(String groupId, Map<String, dynamic> chatMessagesData)async{
    groupCollection.doc(groupId).collection("messages").add(chatMessagesData);
    groupCollection.doc(groupId).update({
      "recentMessage" : chatMessagesData['message'],
      "recentMessageSender" : chatMessagesData['sender'],
      "recentMessageTime" : chatMessagesData['time'].toString(),
    });
  }



}