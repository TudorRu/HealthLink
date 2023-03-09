import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

enum ApiCall {
  BODY_PART,
  SYMPTOMS,
  ISSUES,
  ISSUE_INFO,
}

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({Key? key}) : super(key: key);

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  String accessToken = '';
  bool connectedToAPI = false;
  int? _selectedIssue;
  ApiCall? _selectedApiCall = ApiCall.BODY_PART;
  ApiCall? _lastSelectedApi;
  String debugText = 'Debug text';
  String buttonText = 'Connect to API';
  String bodyTempText = 'Waiting for API calls';
  List<dynamic> allAPIfetchedElements = [];

  @override
  void dispose() {
    _controller.dispose();
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
                    width: 50,
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
                    width: 50,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        connectedToAPI
                            ? _fetchAPI(_selectedApiCall)
                            : _tryToConnect();
                      },
                      child: Text(buttonText)),
                  const SizedBox(
                    width: 50,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  _selectedApiCall == ApiCall.ISSUE_INFO
                      ? SizedBox(
                    width: 250,
                    child: TextField(
                      focusNode: _focusNode,
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Enter an issue ID',
                        border: OutlineInputBorder(),
                      ),
                      onTapOutside: (pde){
                        _selectedIssue = int.parse(_controller.text);
                        _focusNode.unfocus();
                      },
                      onEditingComplete: () {
                        _selectedIssue = int.parse(_controller.text);
                        _focusNode.unfocus();
                        _fetchAPI(ApiCall.ISSUE_INFO);
                      },
                    ),
                  )
                      : const SizedBox(
                    width: 250,
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
            'https://sandbox-healthservice.priaid.ch/issues/${_selectedIssue}/info');
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
          debugText ="sending http get request for issue_info";
        });
        response = await http.get(uri.replace(queryParameters: {
          'token': accessToken,
          'issue_id': _selectedIssue.toString(),
          'language': 'en-gb',
        }));
        break;
      default:
        setState(() {
          debugText ="sending http get request for api data";
        });
        response = await http.get(uri.replace(queryParameters: {
          'token': accessToken,
          'language': 'en-gb',
        }));
    }

    if (response.statusCode == 200) {
      switch(myApiCall){
        case ApiCall.ISSUE_INFO :
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
