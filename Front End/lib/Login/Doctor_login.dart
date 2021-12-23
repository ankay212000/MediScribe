import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/Component/button.dart';
import '../constants.dart';
import 'login_page.dart';
import 'Doctor_register.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String doctor_id= '';
  String hospital_id ='';
  String name ='';
  String showText='Department';
  String dep="";
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.blue,
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: formkey,
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: <Color>[
                            Color.fromRGBO(173, 200, 255, 1),
                            Colors.white,
                          ],
                          begin: FractionalOffset(0.0, 0.0),
                          end: FractionalOffset(1.0, 1.0),
                          stops: <double>[0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                      child: SingleChildScrollView(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 80),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sign In",
                              style: TextStyle(
                                  fontSize: 50,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                email = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Email";
                                }
                              },
                              textAlign: TextAlign.center,
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Email',
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              keyboardType: TextInputType.name,
                              onChanged: (value) {
                                hospital_id = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Hospital ID";
                                }
                              },
                              textAlign: TextAlign.center,
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Hospital ID',
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                            doctor_id = value;
                            },
                            validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter Doctor ID";
                            }
                            },
                            textAlign: TextAlign.center,
                            decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Doctor ID',
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              keyboardType: TextInputType.name,
                              onChanged: (value) {
                                name = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter name";
                                }
                              },
                              textAlign: TextAlign.center,
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Name',
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Password";
                                }
                              },
                              onChanged: (value) {
                                password = value;
                              },
                              textAlign: TextAlign.center,
                              decoration: kTextFieldDecoration.copyWith(
                                  hintText: 'Password',
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.black,
                                  )),
                            ),
                            SizedBox(height:30.0),
                            Row(
                              children: [
                                DropdownButton(
                        hint: Text(showText),
                        //value: gender,
                        items: [
                          DropdownMenuItem(
                                    child: Text("Allergists"),
                                    value: "Allergists",
                          ),
                          DropdownMenuItem(
                                    child: Text("Cardiologists"),
                                    value: "Cardiologists",
                          ),
                          DropdownMenuItem(
                                    child: Text("Dermatologists"),
                                    value: "Dermatologists",
                          ),
                          DropdownMenuItem(
                                    child: Text("Endocrinologists"),
                                    value: "Endocrinologists",
                          ),
                          DropdownMenuItem(
                                    child: Text("Gastroenterologists"),
                                    value: "Gastroenterologists",
                          ),
                          DropdownMenuItem(
                                    child: Text("Hematologists"),
                                    value: "Hematologists",
                          ),
                          DropdownMenuItem(
                                    child: Text("Neurologists"),
                                    value: "Neurologists",
                          ),
                          DropdownMenuItem(
                                    child: Text("Gynecologists"),
                                    value: "Gynecologists",
                          ),
                          DropdownMenuItem(
                                    child: Text("Pathologists"),
                                    value: "Pathologists",
                          ),
                          DropdownMenuItem(
                                    child: Text("Pediatricians"),
                                    value: "Pediatricians",
                          ),
                          DropdownMenuItem(
                                    child: Text("Physiatrists"),
                                    value: "Physiatrists",
                          ),
                          DropdownMenuItem(
                                    child: Text("Plastic Surgeons"),
                                    value: "Plastic Surgeons",
                          ),
                          DropdownMenuItem(
                                    child: Text("Psychiatrists"),
                                    value: "Psychiatrists",
                          ),
                          DropdownMenuItem(
                                    child: Text("Urologists"),
                                    value: "Urologists",
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                                    dep = value.toString();
                                    showText=dep;
                          });
                        },
                      ),
                      SizedBox(width: 50.0,),
                      Container(
                        width: 130.0,
                        child: LoginSignupButton(
                                title: 'Login',
                                ontapp: () async {
                                  if (formkey.currentState!.validate()) {
                                    setState(() {
                                      isloading = true;
                                    });
                                    try {
                                      await _auth.signInWithEmailAndPassword(
                                          email: email, password: password);

                                      await Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (contex) => LoginPage(
                                            doctor_id: doctor_id,
                                            hospital_id: hospital_id,
                                            name: name,
                                            dep: dep,
                                          ),
                                        ),
                                      );

                                      setState(() {
                                        isloading = false;
                                      });
                                    } on FirebaseAuthException catch (e) {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text("Ops! Login Failed"),
                                          content: Text('${e.message}'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                              },
                                              child: Text('Okay'),
                                            )
                                          ],
                                        ),
                                      );
                                      print(e);
                                    }
                                    setState(() {
                                      isloading = false;
                                    });
                                  }
                                },
                              ),
                      ),
                              ],
                            ),
                            SizedBox(height: 30),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SignupScreen(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Don't have an Account ?",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black87),
                                  ),
                                  SizedBox(width: 10),
                                  Hero(
                                    tag: '1',
                                                                      child: Text(
                                      'Sign up',
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}