import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'homeView.dart';

// ignore: camel_case_types
class signInView extends StatefulWidget {
  signInView({Key key}) : super(key: key);

  @override
  signUpViewState createState() => signUpViewState();
}

// ignore: camel_case_types
class signUpViewState extends State<signInView> {
  final _signInFormKey = GlobalKey<FormState>();
  String errorMsg = "";
  bool _loading = false;

  bool usernameExist = false;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  String fullNameValidator(String value) {
    if (value.length < 3) {
      return 'Please enter a valid name';
    } else {
      return null;
    }
  }

  String usernameValidator(String value) {

     if (usernameExist) {

       return 'Username already exists';
     }
     else {
       print("etf111");
       return null;

   }

  }


  Future checkUser() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('Users')
        .where('username', isEqualTo: usernameController.text)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents.length == 1;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _loading == true
            ? CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(
              Colors.blue),
        )
        :Container(
          padding: EdgeInsets.all(20),
          child: Form(
            //autovalidateMode: AutovalidateMode.always,
            key: _signInFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sign Up",
                    textAlign: TextAlign.left,
                    textScaleFactor: 3,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  customFormField("Full Name", false, fullNameController,
                      fullNameValidator),
                  SizedBox(
                    height: 10,
                  ),
                  customFormField(
                      "Username", false, usernameController, usernameValidator),
                  SizedBox(
                    height: 10,
                  ),
                  customFormField(
                      "Email", false, emailController, emailValidator),
                  SizedBox(
                    height: 10,
                  ),
                  customFormField(
                      "Password", true, passwordController, pwdValidator),
                  SizedBox(
                    height: 10,
                  ),
                  customFormField("Confirm Password", true,
                      conPasswordController, pwdValidator),
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
                            child: Text("Register"),
                            color: Colors.black,
                            textColor: Colors.white,
                            onPressed: () async{
                              var response = await checkUser();
                              print(response);
                              setState(() {
                                this.usernameExist = response;
                              });

                              if (_signInFormKey.currentState.validate()) {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  _loading = true;
                                });
                                _validateSignIn();
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
                      "Already Registered?",
                    ),
                    Spacer()
                  ]),
                  Row(children: [
                    Spacer(),
                    FlatButton(
                      child: Text(
                        "Login",
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Spacer()
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _validateSignIn() async {
    if (passwordController.text ==
        conPasswordController.text) {
      try {
       await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text)
            .then((currentUser) => Firestore.instance
            .collection("Users")
            .document()
            .setData({
          "fullname": fullNameController.text,
          "username": usernameController.text,
          "email": emailController.text,
        })
            .then((result) => {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => homeView()),
                  (_) => false),
          fullNameController.clear(),
          usernameController.clear(),
          emailController.clear(),
          passwordController.clear(),
          conPasswordController.clear()
        }));

       setState(() {
         _loading = false;
       });
            /*.catchError((err) => print(err)))
            .catchError((err) {

         switch (err.code) {
           case "ERROR_EMAIL_ALREADY_IN_USE":
             { showDialog(
                 context: context,
                 builder: (BuildContext context) {
                   return AlertDialog(
                     title: Text("Error"),
                     content: Text("The email is already in use!"),
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
           case "ERROR_WEAK_PASSWORD":
             {
               _sheetController.setState(() {
                 errorMsg = "The password must be 6 characters long or more.";
                 _loading = false;
               });
               showDialog(
                   context: context,
                   builder: (BuildContext context) {
                     return AlertDialog(
                       content: Container(
                         child: Text(errorMsg),
                       ),
                     );
                   });
             }
             break;
           default:
             {
               _sheetController.setState(() {
                 errorMsg = "";
               });
             }
         }
       });
*/
      }
      catch (error) {
        switch (error.code) {
          case "ERROR_EMAIL_ALREADY_IN_USE":
            {
              setState(() {
                _loading = false;
              });
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Error"),
                    content: Text("The email is already in use!"),
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
          case "ERROR_WEAK_PASSWORD":
            {
              setState(() {
                _loading = false;
              });

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        child: Text(errorMsg),
                      ),
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
    else{
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("The passwords do not match"),
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
  }





}

// ignore: camel_case_types
class customFormField extends StatelessWidget {
  final txt;
  final bool pwd;
  final TextEditingController ctrl;
  final String Function(String) validate;
  customFormField(this.txt, this.pwd, this.ctrl, this.validate);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validate,
      controller: ctrl,
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
