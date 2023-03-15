import 'package:flutter/material.dart';
import 'package:healthlink/homePage.dart';

class LandingPage extends StatelessWidget {

  bool avatar = false;

  LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/backgroundHomepage.png"),
                    fit: BoxFit.fill)),
            child: Stack(children: [
              Align(
                  alignment: Alignment(0, -0.5),
                  child: Container(
                    width: 270,
                    height: 270,
                    decoration: const BoxDecoration(
                      image:
                          DecorationImage(image: AssetImage("assets/logo.png")),
                    ),
                    child: Align(
                      alignment: Alignment(0, 0.5),
                      child: Text(
                      'HealthLink',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Color(0xFF00ACC2)),
                    ),
                  ))),
              Align(
                  alignment: Alignment(0, 0.2),
                  child: Container(
                      width: 250,
                      height: 36,
                      child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: 'Email',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xFF00ACC2)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xFF00ACC2)),
                              ))))),
              Align(
                  alignment: Alignment(-0.01, 0.4),
                  child: TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Color(0xFFFFFFFF),
                          minimumSize: Size(220, 45),
                          backgroundColor: Color(0xFFEF8808)),
                      onPressed: () {},
                      child: Text('Continue'))),
              Align(
                  alignment: Alignment(0, 1),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomePage()), // push the new page onto the stack
                      );
                    },
                    child: Text('Continue anonymously',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 19,
                            color: Color(0xFFEF8808))),
                  ))
            ])));
  }
}
