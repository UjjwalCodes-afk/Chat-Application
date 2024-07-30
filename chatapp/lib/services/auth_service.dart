import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/services/databaseservice.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future loginWithUserNameAndPassword(String email, String password)async{
    try{
      User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;
      if(user!=null){
        return true;
      }
    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }


  //register
  Future registerUserWithEmailandPassword(String fullname,String email, String password)async{

    try{
    User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;
    if(user!= null){
      //call our database service
      await DatabaseService(uid: user.uid).updateUserData(fullname, email);
      return true;
    }

    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }


  //signout
  Future signOut()async{
    try{
    await HelperFunctions.saveUserLoggedInStatus(false);
    await HelperFunctions.saveUserEmail("");
    await HelperFunctions.saveUserNameSf("");
    
    }catch(e){
      return null;
    }
    
  }
}