import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/Component/button.dart';
import '../constants.dart';
import 'Doctor_login.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String name = '';
  String doctor_id= '';
  String hospital_id= '';
  String showText='Department';
  String dep='';
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Hero(
                              tag: '1',
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                email = value.toString().trim();
                              },
                              validator: (value) => (value!.isEmpty)
                                  ? ' Please enter email'
                                  : null,
                              textAlign: TextAlign.center,
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Enter Your Email',
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
                                doctor_id = value.toString().trim();
                              },
                              validator: (value) => (value!.isEmpty)
                                  ? ' Please enter ID'
                                  : null,
                              textAlign: TextAlign.center,
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Enter Your ID',
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              keyboardType: TextInputType.name,
                              onChanged: (value) {
                                hospital_id = value.toString().trim();
                              },
                              validator: (value) => (value!.isEmpty)
                                  ? ' Please Hospital ID'
                                  : null,
                              textAlign: TextAlign.center,
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Enter Hospital ID',
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              keyboardType: TextInputType.name,
                              onChanged: (value) {
                                name = value.toString().trim();
                              },
                              validator: (value) => (value!.isEmpty)
                                  ? 'Please enter name'
                                  : null,
                              textAlign: TextAlign.center,
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Enter Your Name',
                                prefixIcon: Icon(
                                  Icons.account_box_outlined,
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
                                  hintText: 'Choose a Password',
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.black,
                                  )),
                            ),
                            SizedBox(height: 30),
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
                      SizedBox(width:50.0),
                                Container(
                                  width: 130.0,
                                  child: LoginSignupButton(
                                    title: 'Register',
                                    ontapp: () async {
                                      if (formkey.currentState!.validate()) {
                                        setState(() {
                                          isloading = true;
                                        });
                                        try {
                                          print(doctor_id+"_"+name);
                                          await _auth.createUserWithEmailAndPassword(
                                              email: email, password: password);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.blueGrey,
                                              content: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                    'Sucessfully Register.You Can Login Now'),
                                              ),
                                              duration: Duration(seconds: 5),
                                            ),
                                          );
                                          Navigator.of(context).pop();

                                          setState(() {
                                            isloading = false;
                                          });
                                        } on FirebaseAuthException catch (e) {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title:
                                                  Text(' Ops! Registration Failed'),
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
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Already have an account ?",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black87),
                                  ),
                                  SizedBox(width: 10),
                                  Hero(
                                    tag: '2',
                                      child: Text(
                                      'Sign in',
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