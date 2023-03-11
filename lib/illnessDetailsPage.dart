import 'package:flutter/material.dart';
import 'package:healthlink/homePage.dart';

class IllnessDetailsPage extends StatelessWidget {
  const IllnessDetailsPage ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      extendBodyBehindAppBar: false,
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 15, left: 12),
          child: const Text('Your Diagnosis', style: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400
          ),),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Container(
            color: Colors.black,
            height: 0.2,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    HomePage()), // push the new page onto the stack
              );
            },
                icon: Icon(Icons.delete_forever_outlined, color: Colors.black,
                  size: 29,)),
          )
        ],
      ),
      body: Stack(
          fit: StackFit.expand,
          children: [
          buildBackground(),
          Align(
              alignment: Alignment(0, 0.15),
              child: buildAvatar()
          ),
          Align(
            alignment: Alignment(0, -0.8),
            child: buildIllnessDetails(),
          ),
          Align(
            alignment: Alignment(0, 0.7),
            child: buildDoctorButton(),
          ),
          Align(
            alignment: Alignment(0, 0.85),
            child: buildCompleteButton(),
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

  Widget buildAvatar() {
    return Container(
        child: Image.asset(
          "assets/female_avatar.png", width: 180, height: 180,)
    );
  }

  Widget buildIllnessDetails(){
    return Container(
        height: 240,
        width: 350,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.all(Radius.circular(50))
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment(-0.8, -0.8),
              child: Text('Coronavirus 2019', style: TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 20
              )),
            ),
            Align(
              alignment: Alignment(0, 0),
              child: Text('Most people infected with the virus will experience mild to moderate respiratory illness and recover without requiring special treatment. However, some will become seriously ill and require medical attention. Older people and those with underlying medical conditions like cardiovascular disease, diabetes, chronic respiratory disease, or cancer are more likely to develop serious illness.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 14,
              )),
            )
          ],
        ),
    );
  }

  Widget buildDoctorButton(){
    return Container(
          child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: Color(0xFF00ACC2))
                )
              ),
              onPressed: () {},
              child: Padding(
              padding: const EdgeInsets.only(left: 57, right: 57),
              child: Text(
              'Find a doctor', style: TextStyle(
                  fontSize: 19, fontWeight: FontWeight.w300
              )
          ))),
    );
  }

  Widget buildCompleteButton(){
    return Container(
      child: TextButton(
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: Color(0xFF00ACC2))
              )
          ),
          onPressed: () {},
          child: Padding(
              padding: const EdgeInsets.only(left: 70, right: 70),
              child: Text(
                  'Complete', style: TextStyle(
                  fontSize: 19, fontWeight: FontWeight.w300
              )
              ))),
    );
  }

}