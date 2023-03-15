import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:healthlink/homePage.dart';
import 'package:healthlink/possibleIllnessPage.dart';

enum ApiCall {
  BODY_PART,
  SUB_BODY_PART,
  SYMPTOMS,
  ISSUES,
  ISSUE_INFO,
  BODY_SYMPTOMS,
  MORE_SYMPTOMS,
  DIAGNOSIS,
  SPECIALIST,
  REDFLAG,
}

enum DiagnosisStep {
  GENDER,
  BIRTH_YEAR,
  ILLNESS_LOCATION,
  PRECISE_ILLNESS_LOCATION,
  LOCATED_SYMPTOMS,
  RELATED_SYMPTOMS,
  DIAGNOSIS,
  ISSUE
}

enum ApiGender {
  WOMAN,
  MAN,
  BOY,
  GIRL,
}

String _question =
    "To ensure we provide you with the best care possible, could you please share your gender identity with me?";

class DiagnosisPage extends StatefulWidget {
  const DiagnosisPage({Key? key}) : super(key: key);

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  DiagnosisStep _actualStep = DiagnosisStep.GENDER;

  String _debugText = "Debug text";

  Profile _patientProfile = Profile();
  String _illnessLocation = "";
  String _preciseIllnessLocation = "";


  void _updateGender(ApiGender gender) {
    setState(() {
      _patientProfile.gender = gender;
    });
  }

  void _updatePreciseIllnessLocation(String preciseIllnesslocation) {
    setState(() {
      _preciseIllnessLocation = preciseIllnesslocation;
    });
  }

  void _addSymptom(dynamic symptomToAdd) {
    setState(() {
      _patientProfile.symptoms.add(symptomToAdd);
    });
  }

  void _updateIssue(dynamic issueToAdd) {
    setState(() {
      _patientProfile.issue = issueToAdd;
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

  void _moveToNextPhase() {
    if (_actualStep != DiagnosisStep.DIAGNOSIS) {
      _actualStep = DiagnosisStep.values[_actualStep.index + 1];
    }
    print("Move to phase : $_actualStep");
    _updateQuestion();
  }

  void _updateQuestion() {
    setState(() {
      switch (_actualStep) {
        case DiagnosisStep.GENDER:
          _question =
              "To ensure we provide you with the best care possible, could you please share your gender identity with me?";
          break;
        case DiagnosisStep.BIRTH_YEAR:
          _question = "Can you provide your year of birth?";
          break;
        case DiagnosisStep.ILLNESS_LOCATION:
          _question =
              "Can you tell me where are experiencing symptoms or discomfort?";
          break;
        case DiagnosisStep.PRECISE_ILLNESS_LOCATION:
          _question =
              "Where specifically are you experiencing symptoms or discomfort?";
          break;
        case DiagnosisStep.LOCATED_SYMPTOMS:
          _question = "Please select from the list below one symptom that you are currently experiencing.";
          break;
        case DiagnosisStep.RELATED_SYMPTOMS:
          _question = "Do you experience any of below symptoms?";
          break;
        case DiagnosisStep.DIAGNOSIS:

          break;
        case DiagnosisStep.ISSUE:
          _question = "Here is your diagnosis :";
          break;
        default:
          _question = "Unexistant diagnosis step question";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 15, left: 12),
          child: const Text(
            'New Assessment',
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400),
          ),
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
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomePage()), // push the new page onto the stack
                  );
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 29,
                )),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/fin3.png"), fit: BoxFit.fill)),
        child: Column(children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Align(alignment: Alignment(-0.9, 1), child: buildAvatar()),
                Align(
                    alignment: Alignment(0.8, 0.4),
                    child: Container(
                      width: (MediaQuery.of(context).size.width) / 2,
                      child: Text(
                        _question,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w400),
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment(0, -0.5),
              child: AnswerBuilder(
                actualStep: _actualStep,
                moveToNextPhase: _moveToNextPhase,
                updateGender: _updateGender,
                updateIllnessLocation: _updateIllnessLocation,
                updatedBirthYear: _updateBirthYear,
                updatePreciseIllnessLocation: _updatePreciseIllnessLocation,
                addSymptom: _addSymptom,
                addIssue: _updateIssue,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildBackground() {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/fin3.png"), fit: BoxFit.fill)));
  }

  Widget buildAvatar() {
    return Container(
        child: Image.asset(
      "assets/female_avatar.png",
      width: 200,
      height: 200,
    ));
  }
}

class AnswerBuilder extends StatefulWidget {
  final DiagnosisStep actualStep;
  final Function(ApiGender) updateGender;
  final Function(int) updatedBirthYear;
  final Function() moveToNextPhase;
  final Function(String) updateIllnessLocation;
  final Function(String) updatePreciseIllnessLocation;
  final Function(dynamic) addSymptom;
  final Function(dynamic) addIssue;

  const AnswerBuilder(
      {Key? key,
      required this.moveToNextPhase,
      required this.actualStep,
      required this.updateGender,
      required this.updatedBirthYear,
      required this.updateIllnessLocation,
      required this.updatePreciseIllnessLocation,
      required this.addSymptom,
      required this.addIssue})
      : super(key: key);

  @override
  State<AnswerBuilder> createState() => _AnswerBuilderState();
}

class _AnswerBuilderState extends State<AnswerBuilder> {
  final _textFieldController = TextEditingController();
  final _textFieldFocusNode = FocusNode();

  String accessToken = '';
  bool _authentificatedToAPI = false;
  bool _dataFetchedSuccessfully = false;
  List<String>years = ['2000', '2001'];
  String? value;

  String text = "Enter birth year";

  int _bodyPartID = 0;
  int _bodyPrecisePartID = 0;
  int _birthYearChosed = 0;
  List<int> _pickedSymptom = [];
  int _pickedIssueID = 0;
  ApiGender _selectedGender = ApiGender.WOMAN;
  List<dynamic> allAPIfetchedElements = [];
  List<dynamic> _selectedSymptoms = [];
  bool redFlagSympmtom = false;

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  void _APIauthentificate() async {
    const String apiKey = 'mannt@hotmail.fr';
    const String url = 'https://sandbox-authservice.priaid.ch/login';
    final headers = {
      'Authorization': 'Bearer $apiKey:${_hashCredentials(url)}'
    };
    final response = await http.post(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      accessToken = data['Token'];
      _authentificatedToAPI = true;
      print("Connected to API !");
    } else if (response.statusCode == 400) {
      print(
          "Wrong authentification password or id :\n${response.statusCode} : ${response.body}");
    } else {
      setState(() {
        print(
            'Authentification Error : ${response.statusCode} : ${response.body}');
      });
    }
  }

  String _hashCredentials(String credentials) {
    final key = utf8.encode('Ni6g9Q3XmRq54Msa2');
    final bytes = utf8.encode(credentials);
    final hmac = Hmac(md5, key);
    final digest = hmac.convert(bytes);
    return base64Url.encode(digest.bytes);
  }

  String getStatusString() {
    String gender;
    switch (_selectedGender) {
      case ApiGender.WOMAN:
        if (2023 - _birthYearChosed < 16) {
          gender = "girl";
        } else {
          gender = "woman";
        }
        break;
      case ApiGender.MAN:
        if (2023 - _birthYearChosed < 16) {
          gender = "boy";
        } else {
          gender = "man";
        }
        break;
      default:
        gender = "woman";
    }
    return gender;
  }

  String getGenderString() {
    String gender;
    switch (_selectedGender) {
      case ApiGender.WOMAN:
        gender = "female";
        break;
      case ApiGender.MAN:
        gender = "male";
        break;
      default:
        gender = "female";
    }
    return gender;
  }

  void _fetchAPI(ApiCall apiCall) {
    allAPIfetchedElements.clear();
    _dataFetchedSuccessfully = false;
    switch (apiCall) {
      case ApiCall.BODY_PART:
        _fetchAPIelem(
            'https://sandbox-healthservice.priaid.ch/body/locations', apiCall);
        break;
/*      case ApiCall.SYMPTOMS:
        _fetchAPIelem('https://sandbox-healthservice.priaid.ch/symptoms');
        break;*/
/*      case ApiCall.ISSUES:
        _fetchAPIelem('https://sandbox-healthservice.priaid.ch/issues');
        break;*/
      case ApiCall.ISSUE_INFO:
        _fetchAPIelem(
            'https://sandbox-healthservice.priaid.ch/issues/$_pickedIssueID/info',
            apiCall);
        break;
      case ApiCall.SUB_BODY_PART:
        _fetchAPIelem(
            'https://sandbox-healthservice.priaid.ch/body/locations/${_bodyPartID.toString()}',
            apiCall);
        break;
      case ApiCall.BODY_SYMPTOMS:
        _fetchAPIelem(
            'https://sandbox-healthservice.priaid.ch/symptoms/$_bodyPrecisePartID/${getStatusString()}',
            apiCall);
        break;
      case ApiCall.MORE_SYMPTOMS:
        _fetchAPIelem(
            'https://sandbox-healthservice.priaid.ch/symptoms/proposed',
            apiCall);
        break;
      case ApiCall.DIAGNOSIS:
        _fetchAPIelem(
            'https://sandbox-healthservice.priaid.ch/diagnosis', apiCall);
        break;
/*      case ApiCall.SPECIALIST:
        _fetchAPIelem(
            'https://sandbox-healthservice.priaid.ch/diagnosis/specialisations');
        break;*/
      case ApiCall.REDFLAG:
        _fetchAPIelem(
            'https://sandbox-healthservice.priaid.ch/redflag', apiCall);
        break;
      default:
        print("API fetch selected not implemented");
    }
  }

  void _fetchAPIelem(String apiURL, ApiCall myApiCall) async {
    final url = apiURL;
    final uri = Uri.parse(url);
    final response;

    switch (myApiCall) {
      case ApiCall.ISSUE_INFO:
        print("sending http get request for issueinfo");
        response = await http.get(uri.replace(queryParameters: {
          'token': accessToken,
          'issue_id': _pickedIssueID.toString(),
          'language': 'en-gb',
        }));
        break;
      case ApiCall.SUB_BODY_PART:
        print("sending http get request for sub-body part");
        response = await http.get(uri.replace(queryParameters: {
          'token': accessToken,
          'location_id': _bodyPartID.toString(),
          'language': 'en-gb',
        }));
        break;
      case ApiCall.BODY_SYMPTOMS:
        print("sending http get request for body symptoms");
        response = await http.get(uri.replace(queryParameters: {
          'token': accessToken,
          'location_id': _bodyPrecisePartID.toString(),
          'selectorStatus': getStatusString(),
          'language': 'en-gb',
        }));
        break;
      case ApiCall.MORE_SYMPTOMS:
        print("sending http get request for related symptoms");
        response = await http.get(uri.replace(queryParameters: {
          'token': accessToken,
          'symptoms': jsonEncode(_pickedSymptom),
          'gender': getGenderString(),
          'year_of_birth': _birthYearChosed.toString(),
          'language': 'en-gb',
        }));
        break;
      case ApiCall.DIAGNOSIS:
        print("sending http get request for diagnosis");
        response = await http.get(uri.replace(queryParameters: {
          'token': accessToken,
          'symptoms': getSymptomsID().toString(),
          'gender': getGenderString(),
          'year_of_birth': _birthYearChosed.toString(),
          'language': 'en-gb',
        }));
        break;
      /* case ApiCall.SPECIALIST:
        print("sending http get request for specialists");
        symptoms.clear();
        symptoms.add(_complementaryID!);
        response = await http.get(uri.replace(queryParameters: {
          'token': accessToken,
          'symptoms': jsonEncode(symptoms),
          'gender': getGenderString(),
          'year_of_birth': _birthYear.toString(),
          'language': 'en-gb',
        }));
        break;*/
      case ApiCall.REDFLAG:
        print("sending http get request for redflag warnings");
        response = await http.get(uri.replace(queryParameters: {
          'token': accessToken,
          'symptomId': _selectedSymptoms[0].toString(),
          'language': 'en-gb',
        }));
        break;
      default:
        print("sending http get request for api data");
        response = await http.get(uri.replace(queryParameters: {
          'token': accessToken,
          'language': 'en-gb',
        }));
    }

    if (response.statusCode == 200) {
      switch (myApiCall) {
        case ApiCall.ISSUE_INFO:
          final Map<String, dynamic> apiInfo = json.decode(response.body);
          allAPIfetchedElements.add(apiInfo);
          _dataFetchedSuccessfully = true;
          break;
        case ApiCall.REDFLAG:
          final String apiInfo = json.decode(response.body);
          if (apiInfo.isNotEmpty) {
            redFlagSympmtom = true;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PossibleIllnessPage(
                          allAPIfetchedElements: allAPIfetchedElements,
                          redFlag: redFlagSympmtom, accessToken: accessToken,
                        )));
          } else {
            _selectedSymptoms.removeAt(0);
            if (_selectedSymptoms.isEmpty) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PossibleIllnessPage(
                            allAPIfetchedElements: allAPIfetchedElements,
                            redFlag: redFlagSympmtom,accessToken: accessToken,
                          )));
            } else {
              _fetchAPI(ApiCall.REDFLAG);
            }
          }
          break;
        case ApiCall.DIAGNOSIS:
          allAPIfetchedElements = json.decode(response.body);
          //_fetchAPI(ApiCall.REDFLAG);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PossibleIllnessPage(
                        allAPIfetchedElements: allAPIfetchedElements,
                        redFlag: redFlagSympmtom, accessToken: accessToken,
                      )));
          break;
        default:
          allAPIfetchedElements = json.decode(response.body);
          _dataFetchedSuccessfully = true;
      }
      setState(() {});
      print("${response.statusCode} : Successfully fetched data !");
    } else if (response.statusCode == 400) {
      print("error 400 while fetching data : ${response.body}");
    } else {
      print('Error while fetching data :\n'
          '${response.statusCode} : ${response.body}');
    }
  }

  List<int> getSymptomsID() {
    List<int> mySymptomsId = [];
    for (final symptom in _selectedSymptoms) {
      mySymptomsId.add(symptom["ID"]);
    }
    print(mySymptomsId);
    return mySymptomsId;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.actualStep) {
      case DiagnosisStep.GENDER:
        return Container(
            width: 200,
            child: ListView(
              shrinkWrap: true,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(color: Color(0xFF00ACC2))),
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.transparent),
                  onPressed: () {
                    _APIauthentificate();
                    widget.updateGender(ApiGender.MAN);
                    widget.moveToNextPhase();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text('Male',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400)),
                  ), // push the new page onto the stack
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(color: Color(0xFF00ACC2))),
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.transparent),
                  onPressed: () {
                    _APIauthentificate();
                    widget.updateGender(ApiGender.MAN);
                    widget.moveToNextPhase();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text('Female',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400)),
                  ), // push the new page onto the stack
                ),
              ],
            ));
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _APIauthentificate();
                  widget.updateGender(ApiGender.MAN);
                  widget.moveToNextPhase();
                },
                child: const Text("Male"),
              ),
              const SizedBox(width: 16),
              // Add some spacing between the buttons
              ElevatedButton(
                onPressed: () {
                  _APIauthentificate();
                  widget.updateGender(ApiGender.WOMAN);
                  widget.moveToNextPhase();
                },
                child: const Text("Female"),
              ),
            ],
          ),
        );

      case DiagnosisStep.BIRTH_YEAR:
        return Container(
          width: 200,
          child: TextField(
            focusNode: _textFieldFocusNode,
            controller: _textFieldController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Enter birth year',
              border: OutlineInputBorder(),
            ),
            onTapOutside: (pde) {
              _textFieldFocusNode.unfocus();
            },
            onEditingComplete: () {
                if(int.parse(_textFieldController.text) < 1900 || int.parse(_textFieldController.text) > 2023)
                  {

                  }
                else
                {
                  widget.updatedBirthYear(int.parse(_textFieldController.text));
                  _fetchAPI(ApiCall.BODY_PART);
                  _textFieldFocusNode.unfocus();
                  widget.moveToNextPhase();
                }
              }
          ),
        );

      case DiagnosisStep.ILLNESS_LOCATION:
        return _authentificatedToAPI
            ? _dataFetchedSuccessfully
                ? Container(
                    width: 300,
                    child: ListView.builder(
                        padding: EdgeInsets.only(top: 30),
                        shrinkWrap: true,
                        itemCount: allAPIfetchedElements.length,
                        itemBuilder: (BuildContext context, int index) {
                          return TextButton(
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side:
                                          BorderSide(color: Color(0xFF00ACC2))),
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.transparent),
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Text(
                                      allAPIfetchedElements[index]['Name'],
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400))),
                              onPressed: () {
                                widget.updateIllnessLocation(
                                    allAPIfetchedElements[index]['Name']);
                                _bodyPartID =
                                    allAPIfetchedElements[index]['ID'];
                                _fetchAPI(ApiCall.SUB_BODY_PART);
                                widget.moveToNextPhase();
                              });
                        }),
                  )
                : CircularProgressIndicator()
            : const Text('');

      case DiagnosisStep.PRECISE_ILLNESS_LOCATION:
        return _authentificatedToAPI
            ? _dataFetchedSuccessfully
                ? Container(
                    width: 300,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 30),
                      shrinkWrap: true,
                      itemCount: allAPIfetchedElements.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TextButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(color: Color(0xFF00ACC2))),
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.transparent),
                          child: Text(allAPIfetchedElements[index]['Name'],
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400)),
                          onPressed: () {
                            widget.updatePreciseIllnessLocation(
                                allAPIfetchedElements[index]['Name']);
                            _bodyPrecisePartID =
                                allAPIfetchedElements[index]['ID'];
                            _fetchAPI(ApiCall.BODY_SYMPTOMS);
                            widget.moveToNextPhase();
                          },
                        );
                      },
                    ),
                  )
                : const Text("")
            : const Text("");
      case DiagnosisStep.LOCATED_SYMPTOMS:
        return _authentificatedToAPI
            ? _dataFetchedSuccessfully
                ? Container(
                    width: 300,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 30),
                      shrinkWrap: true,
                      itemCount: allAPIfetchedElements.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TextButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(color: Color(0xFF00ACC2))),
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.transparent),
                          onPressed: () {
                            widget.addSymptom(allAPIfetchedElements[index]);
                            _pickedSymptom
                                .add(allAPIfetchedElements[index]['ID']);
                            _selectedSymptoms.add(allAPIfetchedElements[index]);
                            _fetchAPI(ApiCall.MORE_SYMPTOMS);
                            widget.moveToNextPhase();
                          },
                          child: Text(allAPIfetchedElements[index]['Name'],
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w400)),
                        );
                      },
                    ),
                  )
                : const CircularProgressIndicator()
            : const Text("Error : Not authenticated to API");

      case DiagnosisStep.RELATED_SYMPTOMS:
        return _authentificatedToAPI
            ? _dataFetchedSuccessfully
                ? Container(
                    width: 300,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment(0, 0.85),
                          child: TextButton(
                            onPressed: () {
                              for (final symptom in _selectedSymptoms) {
                                widget.addSymptom(symptom);
                              }
                              _fetchAPI(ApiCall.DIAGNOSIS);
                              widget.moveToNextPhase();
                            },
                            child: const Text('Confirm related symptoms', style: TextStyle(color: Colors.white),),
                            style: TextButton.styleFrom(
                                backgroundColor: Color(0xFF001C32)),
                          ),
                        ),
                        Align(
                            alignment: Alignment(1, -1),
                            child: Container(
                              height: 300,
                              child: ListView.builder(
                                padding: EdgeInsets.only(top: 30),
                                itemCount: allAPIfetchedElements.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final symptom = allAPIfetchedElements[index];
                                  bool isChecked =
                                      _selectedSymptoms.contains(symptom);
                                  return TextButton(
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            side: BorderSide(
                                                color: Color(0xFF00ACC2))),
                                        foregroundColor: Colors.black,
                                        backgroundColor: isChecked
                                            ? Colors.orange
                                            : Colors.transparent),
                                    onPressed: () {
                                      setState(() {
                                        isChecked = !isChecked;
                                        isChecked
                                            ? _selectedSymptoms.add(symptom)
                                            : _selectedSymptoms.remove(symptom);
                                      });
                                    },
                                    child: Text(
                                        allAPIfetchedElements[index]['Name'],
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400)),
                                  );
                                },
                              ),
                            ))
                      ],
                    ),
                  )
                : const CircularProgressIndicator()
            : const Text("Error : Not authenticated to API");

      case DiagnosisStep.DIAGNOSIS:
        return _authentificatedToAPI
            ? _dataFetchedSuccessfully
                ? Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 30),
                    itemCount: allAPIfetchedElements.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            widget.addIssue(
                                allAPIfetchedElements[index]['Issue']);
                            _pickedIssueID =
                                allAPIfetchedElements[index]['Issue']['ID'];
                            _fetchAPI(ApiCall.ISSUE_INFO);
                            widget.moveToNextPhase();
                          },
                          title: Text(
                              "${allAPIfetchedElements[index]['Issue']['ID']} - ${allAPIfetchedElements[index]['Issue']['Name']}"),
                          subtitle: Text(
                              "${allAPIfetchedElements[index]['Specialisation'][0]['ID']} : ${allAPIfetchedElements[index]['Specialisation'][0]['Name']}"),
                        ),
                      );
                    },
                  ))
                : const CircularProgressIndicator()
            : const Text("Error : Not authenticated to API");

      case DiagnosisStep.ISSUE:
        return _authentificatedToAPI
            ? _dataFetchedSuccessfully
                ? Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              allAPIfetchedElements[0]['Name'],
                              style: const TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  allAPIfetchedElements[0]['Description'],
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Medical condition',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  allAPIfetchedElements[0]['MedicalCondition'],
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Treatment',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  allAPIfetchedElements[0]
                                      ['TreatmentDescription'],
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const CircularProgressIndicator()
            : const Text("Error : Not authenticated to API");

      default:
        return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("Not an actual step"));
    }
  }
}

class Profile {
  int birthYear = 1000;
  ApiGender gender = ApiGender.WOMAN;
  List<dynamic> symptoms = [];
  dynamic issue;

  Profile();

  String printSymptoms() {
    String mySymptoms = "";
    for (final symptom in symptoms) {
      mySymptoms += symptom["Name"];
    }
    return mySymptoms;
  }
}
