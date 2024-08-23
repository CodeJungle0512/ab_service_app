import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:google_fonts/google_fonts.dart';

import '../ui-components/rounded_button.dart';
import '../ui-components/rounded_text.dart';
import '../config/i10n.dart';

// Code for designing the UI of our text field where the user writes his email id or password

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String conf_password = '';
  String errorMessage = '';
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(0, 400, 0, 0),
            shrinkWrap: true,
            reverse: true,
            children: [
              Stack(
                children: [
                  Container(
                    height: 535,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              context.intl.signup,
                              style: GoogleFonts.poppins(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              keyboardType: TextInputType.emailAddress,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                email = value;
                              },
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: context.intl.enterEmail,
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            TextField(
                              obscureText: true,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                password = value;
                              },
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: context.intl.enterPassword,
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            TextField(
                              obscureText: true,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                conf_password = value;
                              },
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: context.intl.confirmPassword,
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            // Display error message
                            if (errorMessage.isNotEmpty)
                              Text(
                                errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            RoundedButton(
                              colour: Colors.blueAccent,
                              title: context.intl.signup,
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                  errorMessage = '';
                                });
                                try {
                                  // Check if passwords match
                                  if (password != conf_password) {
                                    throw FirebaseAuthException(
                                      code: 'passwords-mismatch',
                                      message: 'Passwords do not match',
                                    );
                                  }

                                  final userCredential = await _auth
                                      .createUserWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );

                                  var user = userCredential.user;

                                  if (user != null) {
                                    await user.sendEmailVerification();

                                    Timer.periodic(Duration(seconds: 5),
                                        (timer) async {
                                      await user?.reload();
                                      user = _auth.currentUser;
                                      if (user!.emailVerified) {
                                        timer.cancel();
                                        Navigator.pushReplacementNamed(
                                            context, 'login_screen');
                                      }
                                    });

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                              context.intl.verifyEmailTitle),
                                          content: Text(context.intl
                                              .verifyEmailContent(email)),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(context.intl.ok),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                } on FirebaseAuthException catch (e) {
                                  setState(() {
                                    errorMessage =
                                        e.message ?? 'An error occurred';
                                  });
                                } catch (e) {
                                  //print(e);
                                  setState(() {
                                    errorMessage = 'An error occurred';
                                  });
                                } finally {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                }
                              },
                            ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                              child: Row(
                                children: [
                                  Text(context.intl.haveAccount,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      )),
                                  TextButton(
                                      child: Text(
                                        context.intl.loginTitle,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.lightBlueAccent,
                                        ),
                                      ),
                                      onPressed: () => Navigator.pushNamed(
                                          context, 'login_screen')),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -253),
                    child: Image.asset(
                      'assets/plants2.png',
                      scale: 1.5,
                      width: double.infinity,
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
