import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthUtil {

  static Future<FirebaseUser> getCurrentUser() async {
    final user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  static Future<bool> signOutCurrentUser() async {
    await FirebaseAuth.instance.signOut();
    return true;
  }


}