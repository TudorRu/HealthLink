import 'package:flutter/material.dart';
import 'package:healthlink/diagnosisPage.dart';
import 'package:healthlink/landingPage.dart';
import 'package:healthlink/medicationPage.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _State();
}

class _State extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.logout_outlined, color: Colors.black,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    LandingPage()), // push the new page onto the stack
              );
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.settings_outlined, color: Colors.black,),
              onPressed: () {},
            )
          ],
        ),
        body: kIsWeb ? Stack(
            fit: StackFit.expand,
            children: [
              buildBackground(),
              Align(
                  alignment: Alignment(-1, -1),
                  child: buildGreet(context)
              ),
              Align(
                alignment: Alignment(-0.07, 0),
                child: buildButton(),
              ),
              Align(
                alignment: Alignment(-0.1, 0.15),
                child: buildText(),
              ),
              Align(
                alignment: Alignment(0, 0.6),
                child: buildMedication(),
              )
            ])
            :
        Stack(
            fit: StackFit.expand,
            children: [
              buildBackground(),
              Align(
                  alignment: Alignment(0, -0.6),
                  child: buildGreett()
              ),
              Align(
                alignment: Alignment(-0.5, 0),
                child: buildButton(),
              ),
              Align(
                alignment: Alignment(-0.719, 0.3),
                child: buildText(),
              ),
              Align(
                alignment: Alignment(-1, 0.7),
                child: buildMedication(),
              )
            ])


    );
  }

  Widget buildBackground() {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/fin3.png"),
                fit: BoxFit.fill)
        )
    );
  }

  Widget buildGreett() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Stack(
        children: [
          Row(
            children: [Container(
              child: Image.asset(
                "assets/female_avatar.png", width: 150, height: 150,),
            ),
              Container(
                margin: const EdgeInsets.only(left: 21),
                width: 200,
                child: Text("Welcome!\n\nHow can I help you today?",
                  style: TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 22),),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildGreet(context) {
    return Container(
      child: Stack(
      children: [
      Align(
        alignment: Alignment(-0.15, -0.8),
        child: Container(
        child: Image.asset(
        "assets/female_avatar.png", width: 150, height: 150),
    ),
      ),
    Align(
      alignment: Alignment(0.12, -0.7),
      child: Container(
      margin: const EdgeInsets.only(left: 21),
      width: 200,
      child: Text("Welcome!\n\nHow can I help you today?",
      style: TextStyle(
      fontWeight: FontWeight.normal, fontSize: 22),),
      ),
    )
    ],
    ),
    );
  }

  Widget buildText() {
    return Container(
      child: Text("Medication & Personal Advice",
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 14
        ),
      ),
    );
  }

  Widget buildMedication() {
    return GestureDetector(
      child: Container(
        width: 400,
        height: 190,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/medication.png'),
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              MedicationPage()), // push the new page onto the stack
        );
      },
    );
  }

  Widget buildButton() {
    return Container(
        child: TextButton(
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)
                ),
                foregroundColor: Color(0xFFFFFFFF),
                minimumSize: Size(250, 40),
                backgroundColor: Color(0xFF001C32)
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    DiagnosisPage()), // push the new page onto the stack
              );
            },
            child: Text('Start symptom assessment')
        )
    );
  }
}

