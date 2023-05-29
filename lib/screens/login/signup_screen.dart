import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../shared/background_wave_container.dart';
import '../../shared/login_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String userEmail = '';
  String password = '';
  String name = '';
  String errorMessage = '';
  String secondPassword = '';
  bool loadingStatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        BackgroundWaveContainer(
          height: 260,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Sign Up',
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 70.0,
                    //fontWeight: FontWeight.bold,
                    fontFamily: "Vanila"),
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Create your Account',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold))
                ],
              ),
              const SizedBox(height: 16.0),
              LoginTextField(
                labelText: 'Full Name',
                onChanged: (value) {
                  name = value;
                },
              ),
              const SizedBox(height: 16.0),
              LoginTextField(
                labelText: 'E-mail',
                onChanged: (value) {
                  userEmail = value;
                },
              ),
              const SizedBox(height: 16.0),
              LoginTextField(
                labelText: 'Password',
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              LoginTextField(
                labelText: 'Confirm Password',
                onChanged: (value) {
                  secondPassword = value;
                },
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    errorMessage,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(150, 50),
                  primary: Colors.teal,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    errorMessage = '';
                  });
                  try {
                    if (name == '' ||
                        userEmail == '' ||
                        password == '' ||
                        secondPassword == '') {
                      setState(() {
                        errorMessage = 'Fields cannot be empty';
                      });
                    } else if (password != secondPassword) {
                      setState(() {
                        errorMessage = 'Password is not matched';
                      });
                    } else {
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: userEmail,
                        password: password,
                      );
                      setState(() {
                        loadingStatus = true;
                      });
                      final user = credential.user;

                      await user?.updateDisplayName(name);
                      user?.reload();
                      setState(() {
                        loadingStatus = false;
                      });
                      Get.back();
                    }
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      if (e.code == "unknown") {
                        errorMessage = "Pleas enter valid credentials";
                      } else {
                        errorMessage = e.code;
                      }
                    });
                  } catch (e) {
                    setState(() {
                      errorMessage = e.toString();
                    });
                  }
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.teal,
                      ),
                      onPressed: (() {
                        Get.back();
                      }),
                      child: const Text(
                        'Login in',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]))
      ],
    ));
  }
}
