import 'package:flutter/material.dart';
import 'package:healthlink/homePage.dart';
import 'package:healthlink/possibleIllnessPage.dart';

enum DiagnosisStep {
  GENDER,
  BIRTH_YEAR,
  ILLNESS_LOCATION,
  PRECISE_ILLNESS_LOCATION,
  PROPOSED_SYMPTOMS,
  RELATED_SYMPTOMS,
  MORE_SYMPTOMS,
  DIAGNOSIS,
}

enum ApiGender {
  WOMAN,
  MAN,
  BOY,
  GIRL,
}


class DiagnosisPage extends StatefulWidget {
  const DiagnosisPage({Key? key}) : super(key: key);

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class Profile{
  int? birthYear;
  ApiGender? gender;
  List<int>? symptoms;

  Profile();
}

class _DiagnosisPageState extends State<DiagnosisPage> {

  Profile profile = new Profile();

  @override
  Widget build(BuildContext context) {

    DiagnosisStep _actualStep = DiagnosisStep.GENDER;
    String _question = "What's your gender ?";
    String _debugText = "Debug text";

    Profile _patientProfile = Profile();
    String _illnessLocation = "";

    void _updateGender(ApiGender gender) {
      setState(() {
        _patientProfile.gender = gender;
      });
    }

    void _updateBirthYear(int birthyear) {
      setState(() {
        _patientProfile.birthYear = birthyear;
      });
    }

    void _updateIllnessLocation(String illnesslocation) {
      setState(() {
        _illnessLocation = illnesslocation;
      });
    }

    void _updateQuestion() {
      setState(() {
        switch (_actualStep) {
          case DiagnosisStep.GENDER:
            _question = "What's your gender ?";
            break;
          case DiagnosisStep.BIRTH_YEAR:
            _debugText = "Gender selected : ${_patientProfile.gender.toString()}";
            _question = "What's your birth year?";
            break;
          case DiagnosisStep.ILLNESS_LOCATION:
            _debugText =
            "Birth year entered : ${_patientProfile.birthYear.toString()}";
            _question = "Where is it hurting ?";
            break;
          case DiagnosisStep.PRECISE_ILLNESS_LOCATION:
            _debugText = "Illness location chosen : $_illnessLocation";
            _question = "More precisely ?";
            break;
          default:
            _question = "Unexistant diagnosis step question";
        }
      });
    }

    void _moveToNextPhase() {
      if (_actualStep != DiagnosisStep.DIAGNOSIS) {
        _actualStep = DiagnosisStep.values[_actualStep.index + 1];
      }
      print("Move to phase : $_actualStep");
      _updateQuestion();
    }


    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title:Padding(
          padding: const EdgeInsets.only(top: 15, left: 12),
          child: const Text('New Assessment', style: TextStyle(
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
                MaterialPageRoute(builder: (context) => HomePage()), // push the new page onto the stack
              );
            }, icon: Icon(Icons.close, color: Colors.black, size: 29,)),
          )
        ],
      ),
      body: Stack(
          fit: StackFit.expand,
          children: [
            buildBackground(),
            Align(
                alignment: Alignment(-0.9, 0.2),
                child: buildAvatar()
            ),
            Align(
                alignment: Alignment(0.8, -0.2),
                child: buildQuestion()
            ),
            Align(
              alignment: Alignment(0.8, 0.55),
              child: buildAnswers(),
            ),
            Align(
              alignment: Alignment(-0.1, 0.72),

            )
          ]),
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
          "assets/female_avatar.png", width: 200, height: 200,)
    );
  }

  Widget buildQuestion(){
    return Container(
      width: (MediaQuery.of(context).size.width) /2,
      child: Text(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis dapibus tellus purus?',
        style: TextStyle(
            fontSize: 26, fontWeight: FontWeight.w400
        ),
      ),
    );
  }

  Widget buildAnswers(){
    return Container(
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
              MaterialPageRoute(builder: (context) => PossibleIllnessPage(), // push the new page onto the stack
            ));
          }, child: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: Text('Answer 1', style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w400
          )),
        ), // push the new page onto the stack
        )
    );
  }
}