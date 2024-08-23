import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../ui-components/rounded_text.dart';
import '../config/I10n.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String? email = FirebaseAuth.instance.currentUser!.email;
  String? curEmail = FirebaseAuth.instance.currentUser!.email;
  String error = '';
  TextEditingController emailController =
      TextEditingController(text: FirebaseAuth.instance.currentUser!.email);

  @override
  void initState() {
    super.initState();
    // Listen for changes in the authentication state
    _auth.authStateChanges().listen((User? user) {
      if (user != null && user.emailVerified) {
        // If the user is authenticated and their email is verified, navigate to the main content
        Navigator.pushReplacementNamed(context, 'main_screen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.intl.emailScreenTitle),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/email_icon_blue.png', // Replace with the path to your email image
                    height: 120.0,
                    width: 120.0,
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                      controller: emailController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                        //Do something with the user input.
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: context.intl.enterEmail,
                      )),
                  const SizedBox(height: 10.0),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showSpinner = true;
                        error = '';
                      });
                      // Implement the logic to send the verification email to the entered email address
                      _updateEmailAndResendVerification();
                    },
                    child: Text(
                      context.intl.sendVerification,
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _updateEmailAndResendVerification() async {
    if (email!.isNotEmpty) {
      var user = _auth.currentUser;
      try {
        if (email != curEmail) await user?.updateEmail(email!);
        await user?.sendEmailVerification();
        Timer.periodic(Duration(seconds: 5), (timer) async {
          await user?.reload();
          user = _auth.currentUser;
          if (user!.emailVerified) {
            timer.cancel();
            Navigator.pushReplacementNamed(context, 'login_screen');
          }
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(context.intl.verifyEmailTitle),
              content: Text(context.intl.verifyEmailContent(email!)),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          error = e.message ?? 'An error occurred';
        });
      } catch (e) {
        setState(() {
          error = 'An error occurred';
        });
      } finally {
        setState(() {
          showSpinner = false;
        });
      }
    }
    // Example method to send the verification email to the entered email address
    // void _sendVerificationEmail(String emailAddress) async {
    //   try {
    //     await _auth.sendSignInWithEmailLink(
    //       email: emailAddress,
    //       actionCodeSettings: ActionCodeSettings(
    //         url: 'YOUR_DYNAMIC_LINK', // Replace with your dynamic link
    //         handleCodeInApp: true,
    //         iOSBundleId: 'YOUR_IOS_BUNDLE_ID', // Replace with your iOS bundle ID
    //         androidPackageName: 'YOUR_ANDROID_PACKAGE_NAME', // Replace with your Android package name
    //       ),
    //     );
    //     // Show a message indicating that the verification email has been sent
    //     // Optionally, you can update the UI to reflect the sent email
    //   } catch (e) {
    //     // Handle any errors during the email sending process
    //     print(e.toString());
    //   }
    // }
  }
}
