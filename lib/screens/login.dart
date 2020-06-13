import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thriftit/animation/faded_animation.dart';
import 'package:http/http.dart' as http;
import 'package:thriftit/screens/home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FacebookLogin fbLogin = new FacebookLogin();
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  SharedPreferences preferences;
  bool isLoggedIn = false;


  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {

    preferences = await SharedPreferences.getInstance();
    isLoggedIn = await googleSignIn.isSignedIn();

    if(isLoggedIn){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()) );
    }

  }

  Future _signInGoogle() async{

    preferences = await SharedPreferences.getInstance();
    
    GoogleSignInAccount gUser = await googleSignIn.signIn();

    GoogleSignInAuthentication googleSignInAuthentication = await gUser.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    FirebaseUser firebaseUser = (await _auth.signInWithCredential(credential)).user;

    if(firebaseUser != null){
        final QuerySnapshot result = await Firestore.instance.collection("users").where("id",isEqualTo: firebaseUser.uid).getDocuments();
        final List<DocumentSnapshot> docs = result.documents;

        if(docs.length==0){
            //add user to collection
          Firestore.instance
              .collection("users")
              .document(firebaseUser.uid)
              .setData({
            "id" : firebaseUser.uid,
            "username" : firebaseUser.displayName,
            "profilePicture" : firebaseUser.photoUrl,
            "email" : firebaseUser.email
          });
          await preferences.setString("id", firebaseUser.uid);
          await preferences.setString("username", firebaseUser.displayName);
          await preferences.setString("profilePicture", firebaseUser.photoUrl);
          await preferences.setString("email", firebaseUser.email);
        }else {
          await preferences.setString("id", docs[0]['id']);
          await preferences.setString("username", docs[0]['username']);
          await preferences.setString("profilePicture", docs[0]['profilePicture']);
          await preferences.setString("email", docs[0]['email']);
        }

        Fluttertoast.showToast(msg: "Logged In");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()) );

    }else {
      Fluttertoast.showToast(msg: "Log in failed");
    }

  }

  void _signInFb() async{
    FacebookLogin fbLogin = FacebookLogin();

    final result = await fbLogin.logIn(['email']);

    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
    print(graphResponse.body);

    if(result.status==FacebookLoginStatus.loggedIn){
      final credential = FacebookAuthProvider.getCredential(accessToken: token);
      _auth.signInWithCredential(credential);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(1, Text("Welcome", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                  ),)),
                  SizedBox(height: 20,),
                  FadeAnimation(1.2, Text("Automatic identity verification which enables you to verify your identity",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15
                    ),)),
                ],
              ),
              FadeAnimation(1.4, Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo.PNG')
                    )
                ),
              )),
              Column(
                children: <Widget>[
                  FadeAnimation(1.5, MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      _signInFb();
                    },
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.black
                        ),
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text("Sign in with facebook", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                    ),),
                  )),
                  SizedBox(height: 20,),
                  FadeAnimation(1.6, Container(
                    padding: EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        )
                    ),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        _signInGoogle();
                      },
                      color: Colors.red[300],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text("Sign in with google", style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      ),),
                    ),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );

  }

}
