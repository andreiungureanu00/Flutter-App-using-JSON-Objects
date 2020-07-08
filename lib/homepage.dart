import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:jsonget/database/favorite_singleton.dart';
import 'package:jsonget/productsPage/ProductsPageScreen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with FavouriteEvents {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  bool isSignInGoogle = false;
  bool isSignInFacebook = false;
  GoogleSignIn _googleSignIn = new GoogleSignIn(
      scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);

  @override
  void initState() {
    FavouriteSingleton().addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    FavouriteSingleton().removeListener(this);
    super.dispose();
  }

  var graphResponse;
  var profile;

  void _logInWithFacebook() async {
    var facebookLogin = new FacebookLogin();
    var result = await facebookLogin.logIn(['email']);
    final FacebookAccessToken accessToken = result.accessToken;
    AuthCredential credential =
        FacebookAuthProvider.getCredential(accessToken: accessToken.token);

    debugPrint(result.status.toString());

    if (result.status == FacebookLoginStatus.loggedIn) {
      try {
        _user = (await _auth.signInWithCredential(credential)).user;
        graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}');
        setState(() {
          isSignInFacebook = true;
        });
        profile = json.decode(graphResponse.body);

        debugPrint(profile.toString());
      } on PlatformException catch (e) {
        print(e.toString());
      }
    } else if (result.status == FacebookLoginStatus.cancelledByUser) {
      print("CancelledByUser");
    } else if (result.status == FacebookLoginStatus.error) {
      print("Error");
    }
  }

  void _logoutFromFacebook() {
    facebookLogin.logOut();
    setState(() {
      isSignInFacebook = false;
    });
  }

  void _logInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    AuthResult result = (await _auth.signInWithCredential(credential));
    _user = result.user;

    setState(() {
      isSignInGoogle = true;
    });
  }

  Future<void> googleSignout() async {
    await _auth.signOut().then((onValue) {
      _googleSignIn.signOut();
      setState(() {
        isSignInGoogle = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/download (1).jpg'),
              fit: BoxFit.fitHeight)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(height: 40),
            isSignInFacebook
                ? Column(
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      ),
                      SizedBox(height: 10),
                      Text(
                        profile['name'],
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  )
                : Text(""),
            isSignInGoogle
                ? Column(
                    children: [
                      Text(
                        "Welcome to my page",
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _user.email,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  )
                : Text(""),
            isSignInGoogle || isSignInFacebook
                ? Container()
                : SizedBox(height: 250),
            isSignInFacebook
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 200),
                        RaisedButton(
                          child: Text(
                            "Logout from Facebook",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: _logoutFromFacebook,
                          color: Colors.indigo,
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: FacebookSignInButton(onPressed: _logInWithFacebook),
                  ),
            isSignInGoogle
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 50),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn.windowsreport.com%2Fwp-content%2Fuploads%2F2016%2F10%2FGoogle-icon.jpg&f=1&nofb=1"),
                        ),
                        SizedBox(height: 20),
                        Text(_user.displayName),
                        Text(_user.email),
                        SizedBox(height: 20),
                        OutlineButton(
                          onPressed: () {
                            googleSignout();
                          },
                          child: Text("Logout from Google"),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: OutlineButton(
                      color: Colors.lightGreen,
                      onPressed: () {
                        _logInWithGoogle();
                      },
                      child: Text("Sign in with Google"),
                    ),
                  ),
            isSignInFacebook || isSignInGoogle
                ? SizedBox(height: 50)
                : Text(""),
            isSignInFacebook
                ? Column(
                    children: [
                      SizedBox(height: 130),
                      Text(
                        "You have succesfully logged in with Facebook",
                        style: TextStyle(
                            color: Colors.black,
                          fontSize: 18
                        ),
                      ),
                      SizedBox(height: 15),
                      FlatButton(
                        child: Text(
                          'View Products',
                          style: TextStyle(color: Colors.indigo, fontSize: 20),
                        ),
                        color: Colors.yellow,
                        onPressed: () {
                          if (isSignInFacebook) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProductsPageScreen(),
                            ));
                          }
                        },
                      ),
                    ],
                  )
                : Container(),
            isSignInGoogle
                ? Column(
              children: [
                SizedBox(height: 160),
                Text(
                  "You have succesfully logged in with Facebook",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                  ),
                ),
                SizedBox(height: 15),
                FlatButton(
                  child: Text(
                    'View Products',
                    style: TextStyle(color: Colors.indigo, fontSize: 20),
                  ),
                  color: Colors.yellow,
                  onPressed: () {
                    if (isSignInGoogle) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductsPageScreen(),
                      ));
                    }
                  },
                ),
              ],
            )
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  void onFavouriteAdded(int productId) {}

  @override
  void onFavouriteDeleted(int productId) {}
}
