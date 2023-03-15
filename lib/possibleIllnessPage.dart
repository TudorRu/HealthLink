import 'package:flutter/material.dart';
import 'package:healthlink/homePage.dart';
import 'package:healthlink/illnessDetailsPage.dart';

class PossibleIllnessPage extends StatelessWidget {

  final List<dynamic> allAPIfetchedElements;
  final bool redFlag;
  final String accessToken;



  const PossibleIllnessPage({Key? key, required this.allAPIfetchedElements, required this.redFlag, required this.accessToken}) : super(key: key);

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
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/fin3.png"), fit: BoxFit.fill)),
        child: Column(
          children: [
            Expanded(
              child: Container(
                  child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Align(
                          alignment: Alignment(-0.9, 0.4),
                          child: buildAvatar(),
                        ),
                        Align(
                          alignment: Alignment(0.8, -0.3),
                          child: Container(
                            width: (MediaQuery.of(context).size.width) / 2,
                            child: buildAdvice(redFlag),
                          ),
                        )
                      ])
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                child: Container(
                  width: 330,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: allAPIfetchedElements.length,
                      itemBuilder: (BuildContext context, int index){
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Container(
                            width: 200,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Color(0xFFd5eded),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment(0, -0.7),
                                  child: Text("${allAPIfetchedElements[index]["Issue"]["Name"]}", style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 20
                                  )),
                                ),
                                Align(
                                  alignment: Alignment(0, 0.7),
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              side: BorderSide(color: Color(0xFF00ACC2))
                                          ),
                                          foregroundColor: Colors.black,
                                          backgroundColor: Colors.transparent
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => IllnessDetailsPage(accessToken: accessToken, pickedIssueID:allAPIfetchedElements[index]["Issue"]['ID'],), // push the new page onto the stack
                                            ));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10,right: 10),
                                        child: Text('Tell me more', style: TextStyle(
                                            fontSize: 17, fontWeight: FontWeight.w400
                                        )),
                                      )
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
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

  Widget buildAdvice(bool redFlag) {
    return redFlag
        ? Text(
      'People with symptoms similar to yours may require prompt medical assessment and care. '
          'You should seek advice from a doctor within the next few hours',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w300
      ),
    )
    : Text(
    'Please note that the information provided by this app is intended for informational purposes only and should not be used as a substitute for professional medical advice, diagnosis, or treatment. If you have any concerns about your health, please consult with a qualified healthcare professional.',
    textAlign: TextAlign.center,
    style: TextStyle(
    fontSize: 18, fontWeight: FontWeight.w300
    ));
  }
}