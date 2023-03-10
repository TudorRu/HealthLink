// ignore_for_file: constant_identifier_names, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'api_test_screen.dart';
import 'package:http/http.dart' as http;

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

class DiagnosisWorkflow extends StatefulWidget {
  const DiagnosisWorkflow({Key? key}) : super(key: key);

  @override
  _DiagnosisWorkflowState createState() => _DiagnosisWorkflowState();
}

class _DiagnosisWorkflowState extends State<DiagnosisWorkflow> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnosis workflow test'),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.all(16.0), child: Text(_debugText)),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _question,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        AnswerBuilder(
          actualStep: _actualStep,
          updateGender: _updateGender,
          updateIllnessLocation: _updateIllnessLocation,
          updatedBirthYear: _updateBirthYear,
          moveToNextPhase: _moveToNextPhase,
        ),
      ]),
    );
  }
}

class AnswerBuilder extends StatefulWidget {
  final DiagnosisStep actualStep;
  final Function(ApiGender) updateGender;
  final Function(int) updatedBirthYear;
  final Function() moveToNextPhase;
  final Function(String) updateIllnessLocation;

  const AnswerBuilder(
      {Key? key,
      required this.moveToNextPhase,
      required this.actualStep,
      required this.updateGender,
      required this.updatedBirthYear,
      required this.updateIllnessLocation})
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

  int _bodyPartID = 0;
  List<dynamic> allAPIfetchedElements = [];

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
/*      case ApiCall.ISSUE_INFO:
        _fetchAPIelem(
            'https://sandbox-healthservice.priaid.ch/issues/$_complementaryID/info');
        break;*/
      case ApiCall.SUB_BODY_PART:
        _fetchAPIelem(
            'https://sandbox-healthservice.priaid.ch/body/locations/${_bodyPartID.toString()}',
            apiCall);
        break;
/*      case ApiCall.BODY_SYMPTOMS:
        _fetchAPIelem(
            'https://sandbox-healthservice.priaid.ch/symptoms/$_complementaryID/${getStatusString()}');
        break;*/
/*      case ApiCall.MORE_SYMPTOMS:
        _fetchAPIelem(
            'https://sandbox-healthservice.priaid.ch/symptoms/proposed');
        break;*/
/*      case ApiCall.DIAGNOSIS:
        _fetchAPIelem('https://sandbox-healthservice.priaid.ch/diagnosis');
        break;*/
/*      case ApiCall.SPECIALIST:
        _fetchAPIelem(
            'https://sandbox-healthservice.priaid.ch/diagnosis/specialisations');
        break;*/
/*      case ApiCall.REDFLAG:
        _fetchAPIelem('https://sandbox-healthservice.priaid.ch/redflag');
        break;*/
      default:
        print("API fetch selected not implemented");
    }
  }

  void _fetchAPIelem(String apiURL, ApiCall myApiCall) async {
    final url = apiURL;
    final uri = Uri.parse(url);
    final response;

    switch (myApiCall) {
      /*case ApiCall.ISSUE_INFO:
        print("sending http get request for issueinfo");
        response = await http.get(uri.replace(queryParameters: {
          'token': accessToken,
          'issue_id': _complementaryID.toString(),
          'language': 'en-gb',
        }));
        break;*/
      case ApiCall.SUB_BODY_PART:
        print("sending http get request for sub-body part");
        response = await http.get(uri.replace(queryParameters: {
          'token': accessToken,
          'location_id': _bodyPartID.toString(),
          'language': 'en-gb',
        }));
        break;
      /*case ApiCall.BODY_SYMPTOMS:
        print("sending http get request for body symptoms");
        response = await http.get(uri.replace(queryParameters: {
          'token': accessToken,
          'location_id': _complementaryID.toString(),
          'selectorStatus': getStatusString(),
          'language': 'en-gb',
        }));
        break;*/
      /*case ApiCall.MORE_SYMPTOMS:
        print("sending http get request for related symptoms");
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
      /*case ApiCall.DIAGNOSIS:
        print("sending http get request for diagnosis");
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
      /*case ApiCall.REDFLAG:
        print("sending http get request for redflag warnings");
        response = await http.get(uri.replace(queryParameters: {
          'token': accessToken,
          'symptomId': _complementaryID.toString(),
          'language': 'en-gb',
        }));
        break;*/
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
          break;
        case ApiCall.REDFLAG:
          final String apiInfo = json.decode(response.body);
          allAPIfetchedElements.add(apiInfo);
          break;
        default:
          allAPIfetchedElements = json.decode(response.body);
      }
      setState(() {});
      _dataFetchedSuccessfully = true;
      print("${response.statusCode} : Successfully fetched data !");
    } else if (response.statusCode == 400) {
      print("error 400 while fetching data : ${response.body}");
    } else {
      print('Error while fetching data :\n'
          '${response.statusCode} : ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.actualStep) {
      case DiagnosisStep.GENDER:
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
        return Padding(
          padding: const EdgeInsets.all(16.0),
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
              widget.updatedBirthYear(int.parse(_textFieldController.text));
              _fetchAPI(ApiCall.BODY_PART);
              _textFieldFocusNode.unfocus();
              widget.moveToNextPhase();
            },
          ),
        );

      case DiagnosisStep.ILLNESS_LOCATION:
        return _authentificatedToAPI
            ? _dataFetchedSuccessfully
                ? Expanded(
                    child: ListView.builder(
                      itemCount: allAPIfetchedElements.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            onTap: () {
                              widget.updateIllnessLocation(
                                  allAPIfetchedElements[index]['Name']);
                              _bodyPartID = allAPIfetchedElements[index]['ID'];
                              _fetchAPI(ApiCall.SUB_BODY_PART);
                              widget.moveToNextPhase();
                            },
                            title: Text(allAPIfetchedElements[index]['Name']),
                            subtitle: const Text("Tap to choose"),
                          ),
                        );
                      },
                    ),
                  )
                : const Text("Fetching illness location data . . .")
            : const Text("Error : Not authenticated to API");

      case DiagnosisStep.PRECISE_ILLNESS_LOCATION:
        return _authentificatedToAPI
            ? _dataFetchedSuccessfully
                ? Expanded(
                    child: ListView.builder(
                      itemCount: allAPIfetchedElements.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            onTap: () {},
                            title: Text(allAPIfetchedElements[index]['Name']),
                            subtitle: const Text("Tap to choose"),
                          ),
                        );
                      },
                    ),
                  )
                : const Text("Fetching illness sub-location data . . .")
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
  List<int> symptoms = [];

  Profile();
}
