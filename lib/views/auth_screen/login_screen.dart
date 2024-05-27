import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final adminEmail = TextEditingController();
  final adminPass = TextEditingController();

  bool isObscured = true;

  void viewPass() {
    setState(() {
      if (isObscured == true) {
        isObscured = false;
      } else {
        isObscured = true;
      }
    });
  }

  void signIn() {
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: adminEmail.text, password: adminPass.text);
    } catch (e) {
      showToast('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 4, 83, 158),
          centerTitle: true,
          title: Text(
            'COMPRA SA HGT - ADMIN',
            style: GoogleFonts.anton(
              color: const Color.fromARGB(255, 254, 240, 2),
              letterSpacing: 5,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Card(
                elevation: 10,
                color: const Color.fromARGB(255, 214, 214, 214),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width / 2.8,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: Container(
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: const Image(
                              image:
                                  ExactAssetImage('assets/images/hgt_logo.png'),
                              height: 350,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: TextField(
                            controller: adminEmail,
                            decoration: InputDecoration(
                                hintText: 'Email',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 4, 83, 158),
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 4, 83, 158),
                                    ))),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: TextField(
                            obscureText: isObscured,
                            controller: adminPass,
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: viewPass,
                                child: Icon(isObscured
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              hintText: 'Password',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 4, 83, 158),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 4, 83, 158),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            signIn();
                          },
                          child: Container(
                            height: 50,
                            width: 200,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color.fromARGB(255, 4, 83, 158),
                            ),
                            child: Text(
                              'LOGIN',
                              style: GoogleFonts.anton(
                                color: const Color.fromARGB(255, 254, 240, 2),
                                letterSpacing: 3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
