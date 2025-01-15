import 'package:flutter/material.dart';
import 'package:main/view/register.dart';
import 'package:main/view/login.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => Login();
}

class Login extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 33, 61, 41),
          body: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment(0.0, 1.0),
                image: AssetImage("images/tape.png"),
                opacity: 0.6,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  const SizedBox(height: 200),
              
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(40),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello!",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            "Endless Entertainment Awaits, Book Your Tickets Now!",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ),
                        ],
              
                      ),
                    ), 
                  ),
              
                  const SizedBox(height: 200),
              
                  Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
              
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginForm()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: const Color.fromARGB(255, 206, 206, 206),
                              ),
                              child: const Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 24, 36, 24),
                                ),
                              ),
                            ),
                          ), 
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterForm()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: const Color.fromARGB(255, 206, 206, 206),
                              ),
                              child: const Text(
                                "SIGN UP",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 24, 36, 24),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
        ),
          
      ),
    );
  }
}