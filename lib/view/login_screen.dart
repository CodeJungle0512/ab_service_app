import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../ui-components/rounded_button.dart';
import '../config/auth_provider.dart';
import '../config/preferences.dart';
import '../ui-components/rounded_text.dart';
import '../config/i10n.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final _auth = FirebaseAuth.instance;

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  bool showSpinner = false;
  String errorMessage = '';
  @override
  void initState() {
    super.initState();
  }

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
                            context.intl.loginTitle,
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
                                //Do something with the user input.
                              },
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: context.intl.enterEmail,
                              )),
                          const SizedBox(
                            height: 30.0,
                          ),
                          TextField(
                              obscureText: true,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                password = value;
                                //Do something with the user input.
                              },
                              decoration: kTextFieldDecoration.copyWith(
                                  hintText: context.intl.enterPassword)),
                          const SizedBox(
                            height: 24.0,
                          ),
                          if (errorMessage.isNotEmpty)
                            Text(
                              errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          RoundedButton(
                              colour: Colors.lightBlueAccent,
                              title: context.intl.loginButton,
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                  errorMessage = '';
                                });
                                try {
                                  final userCredential =
                                      await _auth.signInWithEmailAndPassword(
                                          email: email, password: password);
                                  final user = userCredential.user;
                                  if (user != null && user.emailVerified) {
                                    final authProvider =
                                        Provider.of<CusAuthProvider>(context,
                                            listen: false);
                                    authProvider.setLoggedIn(true);
                                    String? token = await user.getIdToken();
                                    saveToken(token!);
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      Navigator.pushReplacementNamed(
                                          context, 'home_screen');
                                    });
                                  } else if (user != null &&
                                      !user.emailVerified) {
                                    Navigator.pushNamed(
                                        context, 'email_verification_screen');
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
                                }
                                setState(() {
                                  showSpinner = false;
                                });
                              }),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                            child: Row(
                              children: [
                                Text(context.intl.noneAccount,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.black87,
                                    )),
                                TextButton(
                                    child: Text(
                                      context.intl.signup,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: Colors.lightBlueAccent,
                                      ),
                                    ),
                                    onPressed: () => Navigator.pushNamed(
                                        context, 'registration_screen')),
                              ],
                            ),
                          ),
                        ],
                      ),
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
