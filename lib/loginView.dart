import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watchmovie/homeView.dart';
import 'package:flutter/services.dart';


// ignore: camel_case_types
class loginView extends StatefulWidget {
  loginView({Key key}) : super(key: key);

  @override
  loginViewState createState() => loginViewState();
}

// ignore: camel_case_types
class loginViewState extends State<loginView> {
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _loading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _loading == true
            ? CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(
              Colors.blue),
        )
            : Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _loginFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login",
                    textAlign: TextAlign.left,
                    textScaleFactor: 3,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  customFormField("Email", false,emailController),
                  SizedBox(
                    height: 10,
                  ),
                  customFormField("Password", true,passwordController),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 50,
                        width: 150,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text("Sign In"),
                            color: Colors.black,
                            textColor: Colors.white,
                            onPressed: () {

                              if (_loginFormKey.currentState.validate()) {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  _loading = true;
                                });
                                _validateLogin();
                              }

                            }),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(children: [
                    Spacer(),
                    Text(
                      "Not Registered?",
                    ),
                    Spacer()
                  ]),
                  Row(children: [
                    Spacer(),
                    FlatButton(
                      child: Text(
                        "Sign Up",
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/signup");
                      },
                    ),
                    Spacer()
                  ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  void _validateLogin() async {

      try {
       await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text)
            .then((currentUser) => Firestore.instance
            .collection("users")
            .document()
            .get()
            ..then((result) => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => homeView()),
                      (_) => false),
              emailController.clear(),
              passwordController.clear(),
            }));
      setState(() {
         _loading = false;
       });
      }
      catch (error) {
        switch (error.code) {
          case "ERROR_USER_NOT_FOUND":
            {
              setState(() {
                _loading = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Error"),
                      content: Text("No user found!"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            }
            break;
          case "ERROR_WRONG_PASSWORD":
            {
              setState(() {
                _loading = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Error"),
                      content: Text("Wrong password!"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            }
            break;
          default:
            {
              setState(() {
                _loading = false;
              });

              }
            }
        }
      }

  }


// ignore: camel_case_types
class customFormField extends StatelessWidget {
  final txt;
  final bool pwd;
  final TextEditingController input;
  customFormField(this.txt, this.pwd,this.input);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: input,
      obscureText: pwd,
      decoration: InputDecoration(
        hintText: txt,
        fillColor: Colors.black.withOpacity(0.1),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              BorderSide(color: Colors.black.withOpacity(0.6), width: 3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.05),
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
