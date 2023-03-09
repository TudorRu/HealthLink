import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

enum ApiCall {
  BODY_PART,
  SUB_BODY_PART,
  SYMPTOMS,
  ISSUES,
  ISSUE_INFO,
  BODY_SYMPTOMS,
  MORE_SYMPTOMS,
  DIAGNOSIS,
}

enum ApiGender {
  WOMAN,
  MAN,
  BOY,
  GIRL,
}

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({Key? key}) : super(key: key);

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final _firstController = TextEditingController();
  final _secondController = TextEditingController();
  final _firstFocusNode = FocusNode();
  final _secondFocusNode = FocusNode();

  String accessToken = '';
  bool connectedToAPI = false;
  int? _complementaryID;
  int? _birthYear;
  ApiCall? _selectedApiCall = ApiCall.BODY_PART;
  ApiGender? _selectedGender = ApiGender.WOMAN;
  ApiCall? _lastSelectedApi;
  String debugText = 'Debug text';
  String buttonText = 'Connect to API';
  String bodyTempText = 'Waiting for API calls';
  List<int> symptoms = [];
  List<dynamic> allAPIfetchedElements = [];

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('API test Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                debugText,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  connectedToAPI
                      ? DropdownButton<ApiCall>(
                          value: _selectedApiCall,
                          onChanged: (ApiCall? value) {
                            setState(() {
                              _selectedApiCall = value;
                            });
                          },
                          items: ApiCall.values.map((ApiCall apiCall) {
                            return DropdownMenuItem<ApiCall>(
                              value: apiCall,
                              child: Text(apiCall.toString()),
                            );
                          }).toList(),
                        )
                      : const SizedBox(
                          height: 0,
                        ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        connectedToAPI
                            ? _fetchAPI(_selectedApiCall)
                            : _tryToConnect();
                      },
                      child: Text(buttonText)),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  (_selectedApiCall == ApiCall.ISSUE_INFO ||
                          _selectedApiCall == ApiCall.SUB_BODY_PART ||
                          _selectedApiCall == ApiCall.BODY_SYMPTOMS ||
                          _selectedApiCall == ApiCall.MORE_SYMPTOMS ||
                          _selectedApiCall == ApiCall.DIAGNOSIS)
                      ? Expanded(
                          child: TextField(
                            focusNode: _firstFocusNode,
                            controller: _firstController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Enter complementary ID',
                              border: OutlineInputBorder(),
                            ),
                            onTapOutside: (pde) {
                              _complementaryID =
                                  int.parse(_firstController.text);
                              _firstFocusNode.unfocus();
                            },
                            onEditingComplete: () {
                              _complementaryID =
                                  int.parse(_firstController.text);
                              _firstFocusNode.unfocus();
                            },
                          ),
                        )
                      : const SizedBox(
                          width: 250,
                        ),
                  (_selectedApiCall == ApiCall.BODY_SYMPTOMS ||
                          _selectedApiCall == ApiCall.MORE_SYMPTOMS ||
                          _selectedApiCall == ApiCall.DIAGNOSIS)
                      ? DropdownButton<ApiGender>(
                          value: _selectedGender,
                          onChanged: (ApiGender? value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                          items: ApiGender.values.map((ApiGender apiGender) {
                            return DropdownMenuItem<ApiGender>(
                              value: apiGender,
                              child: Text(apiGender.toString()),
                            );
                          }).toList(),
                        )
                      : const SizedBox(
                          width: 10,
                        ),
                  (_selectedApiCall == ApiCall.MORE_SYMPTOMS ||
                          _selectedApiCall == ApiCall.DIAGNOSIS)
                      ? Expanded(
                          child: TextField(
                            focusNode: _secondFocusNode,
                            controller: _secondController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Enter birth year',
                              border: OutlineInputBorder(),
                            ),
                            onTapOutside: (pde) {
                              _birthYear = int.parse(_secondController.text);
                              _secondFocusNode.unfocus();
                            },
                            onEditingComplete: () {
                              _birthYear = int.parse(_secondController.text);
                              _secondFocusNode.unfocus();
                            },
                          ),
                        )
                      : const SizedBox(
                          width: 10,
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              (allAPIfetchedElements.isNotEmpty && _lastSelectedApi != null)
                  ? Expanded(
                      child: ApiElemList(
                          APIelements: allAPIfetchedElements,
                          apiCall: _lastSelectedApi))
                  : Text(
                      bodyTempText,
                      style: const TextStyle(fontSize: 24),
                    ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ));
  }

  void _tryToConnect() async {
    setState(() {
      debugText = "Trying to connect to API ... ";
    });
    const String apiKey = 'mannt@hotmail.fr';

    const String url = 'https://sandbox-authservice.priaid.ch/login';
    final headers = {
      'Authorization': 'Bearer $apiKey:${_hashCredentials(url)}'
    };
    final response = await http.post(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      accessToken = data['Token'];
      connectedToAPI = true;
      setState(() {
        debugText =
            'Connected successfully !\nToken valid through: ${data['ValidThrough']}';
        buttonText = 'Fetch API';
      });
    } else if (response.statusCode == 400) {
      setState(() {
        debugText = "Wrong username or password";
      });
    } else {
      setState(() {
        debugText = 'Error : ${response.statusCode}';
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

  void _fetchAPI(ApiCall? apiCall) {
    allAPIfetchedElements.clear();
    switch (apiCall) {
      case ApiCall.BODY_PART:
        setState(() {
          bodyTempText = 'fetching body part from API...';
        });
        _fetchAPIelem('https://sandbox-healthservice.priaid.ch/body/locations');
        break;
      case ApiCall.SYMPTOMS:
        setState(() {
          bodyTempText = 'fetching symptoms from API...';
        });
        _fetchAPIelem('https://sandbox-healthservice.priaid.ch/symptoms');
        break;
      case ApiCall.ISSUES:
        setState(() {
          bodyTempText = 'fetching issues from API...';
        });
        _fetchAPIelem('https://sandbox-healthservice.priaid.ch/issues');
        break;
      case ApiCall.ISSUE_INFO:
        setState(() {
          bodyTempText = 'fetching issue from API...';
        });
        _fetchAPIelem(
            'https://sandbox-healthservice.priaid.ch/issues/$_complementaryID/info');
        break;
      case ApiCall.SUB_BODY_PART:
        setState(() {
          bodyTempText = 'fetching sub-bodyparts from API...';
        });
        _fetchAPIelem(
            'https://sandbox-healthservice.priaid.ch/body/locations/$_complementaryID');
        break;
      case ApiCall.BODY_SYMPTOMS:
        setState(() {
          bodyTempText = 'fetching body symptoms from API...';
        });
        _fetchAPIelem(
            'https://sandbox-healthservice.priaid.ch/symptoms/$_complementaryID/${getStatusString()}');
        break;
      case ApiCall.MORE_SYMPTOMS:
        setState(() {
          bodyTempText = 'fetching related symptoms from API...';
        });
        _fetchAPIelem(
            'https://sandbox-healthservice.priaid.ch/symptoms/proposed');
        break;
      case ApiCall.DIAGNOSIS:
        setState(() {
          bodyTempText = 'fetching diagnosis from API...';
        });
        _fetchAPIelem('https://sandbox-healthservice.priaid.ch/diagnosis');
        break;
      default:
        setState(() {
          bodyTempText = 'invalid API selection';
        });
    }
  }

  void _fetchAPIelem(String apiURL) async {
    final url = apiURL;
    final uri = Uri.parse(url);
    final response;
    ApiCall? myApiCall = _selectedApiCall;

    switch (_selectedApiCall) {
      case ApiCall.ISSUE_INFO:
        setState(() {
          debugText = "sending http get request for issue_info";
        });
        response = await http.get(uri.replace(queryParameters: {
          'token': accessToken,
          'issue_id': _complementaryID.toString(),
          'language': 'en-gb',
        }));
        break;
      case ApiCall.SUB_BODY_PART:
        setState(() {
          debugText = "sending http get request for sub_body_part";
        });
        response = await http.get(uri.replace(queryParameters: {
          'token': accessToken,
          'location_id': _complementaryID.toString(),
          'language': 'en-gb',
        }));
        break;
      case ApiCall.BODY_SYMPTOMS:
        setState(() {
          debugText = "sending http get request for body symptoms";
        });
        response = await http.get(uri.replace(queryParameters: {
          'token': accessToken,
          'location_id': _complementaryID.toString(),
          'selectorStatus': getStatusString(),
          'language': 'en-gb',
        }));
        break;
      case ApiCall.MORE_SYMPTOMS:
        setState(() {
          debugText = "sending http get request for related symptoms";
        });
        symptoms.clear();
        symptoms.add(_complementaryID!);
        response = await http.get(uri.replace(queryParameters: {
          'token': accessToken,
          'symptoms': jsonEncode(symptoms),
          'gender': getGenderString(),
          'year_of_birth': _birthYear.toString(),
          'language': 'en-gb',
        }));
        break;
      case ApiCall.DIAGNOSIS:
        setState(() {
          debugText = "sending http get request for diagnosis";
        });
        symptoms.clear();
        symptoms.add(_complementaryID!);
        response = await http.get(uri.replace(queryParameters: {
          'token': accessToken,
          'symptoms': jsonEncode(symptoms),
          'gender': getGenderString(),
          'year_of_birth': _birthYear.toString(),
          'language': 'en-gb',
        }));
        break;
      default:
        setState(() {
          debugText = "sending http get request for api data";
        });
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
        default:
          allAPIfetchedElements = json.decode(response.body);
      }
      _lastSelectedApi = myApiCall;
      setState(() {
        debugText = "${response.statusCode} : Successfully fetched data !";
      });
    } else if (response.statusCode == 400) {
      setState(() {
        debugText = "error 400 : ${response.body}";
      });
    } else {
      setState(() {
        debugText = 'Error : ${response.statusCode}';
      });
    }
  }

  String getStatusString() {
    String gender;
    switch (_selectedGender) {
      case ApiGender.WOMAN:
        gender = "woman";
        break;
      case ApiGender.MAN:
        gender = "man";
        break;
      case ApiGender.GIRL:
        gender = "girl";
        break;
      case ApiGender.BOY:
        gender = "boy";
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
      case ApiGender.GIRL:
        gender = "female";
        break;
      case ApiGender.BOY:
        gender = "male";
        break;
      default:
        gender = "female";
    }
    return gender;
  }
}

class ApiElemList extends StatelessWidget {
  final List<dynamic> APIelements;
  final ApiCall? apiCall;

  const ApiElemList(
      {super.key, required this.APIelements, required this.apiCall});

  @override
  Widget build(BuildContext context) {
    switch (apiCall) {
      case ApiCall.ISSUE_INFO:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  APIelements[0]['Name'],
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      APIelements[0]['Description'],
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Medical condition',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      APIelements[0]['MedicalCondition'],
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case ApiCall.DIAGNOSIS:
        return ListView.builder(
          itemCount: APIelements.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text("${APIelements[index]['Issue']['ID']} - ${APIelements[index]['Issue']['Name']}"),
                subtitle: Text(
                    "${APIelements[index]['Specialisation'][0]['ID']} : ${APIelements[index]['Specialisation'][0]['Name']}"),
              ),
            );
          },
        );
      default:
        return ListView.builder(
          itemCount: APIelements.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text(APIelements[index]['Name']),
                subtitle: Text(APIelements[index]['ID'].toString()),
              ),
            );
          },
        );
    }
  }
}
