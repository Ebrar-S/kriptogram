import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kriptogram/screens/register.dart';

import 'home.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.deepPurple[100],
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[100],
          title: const Text(""),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(
                builder: (context) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Column(
                      children: [
                        const SizedBox(height: 125),
                        Text(
                          'EcoMind',
                          style: GoogleFonts.sarpanch(
                            textStyle: TextStyle(
                                color: Colors.deepPurple[400],
                                letterSpacing: .5),
                            fontSize: 50,
                            shadows: [
                              Shadow(
                                color: Colors.black38,
                                offset: Offset(0, 1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 125),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Color(0xFF7E57C2),
                                width: 2,
                              ),
                            ),
                            labelText: 'email',
                            prefixIcon: Icon(Icons.person,
                                color: Colors.deepPurple[400]),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Color(0xFF7E57C2),
                                width: 2,
                              ),
                            ),
                            labelText: 'password',
                            prefixIcon: Icon(Icons.password,
                                color: Colors.deepPurple[400]),
                          ),
                        ),
                        const SizedBox(height: 35),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CryptogramGameHome()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple[400],
                              foregroundColor: Colors.white70,
                              padding: EdgeInsets.symmetric(
                                horizontal: 40,
                              ),
                              elevation: 2),
                          child: Text(
                            'login',
                            style: GoogleFonts.sarpanch(
                              textStyle: TextStyle(
                                  color: Colors.white70, letterSpacing: .5),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignUpPage()),
                                );
                              },
                              child: Text(
                                'sign up',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black38,
                                      offset: Offset(0, 1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              )),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
