import 'package:flutter/material.dart';
import 'package:healthlink/homePage.dart';
import 'package:healthlink/mainPage.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class IllnessDetailsPage extends StatefulWidget {
  final String accessToken;
  final int pickedIssueID;

  const IllnessDetailsPage(
      {Key? key, required this.accessToken, required this.pickedIssueID})
      : super(key: key);

  @override
  State<IllnessDetailsPage> createState() => _IllnessDetailsPageState();
}

class _IllnessDetailsPageState extends State<IllnessDetailsPage> {
  bool _dataFetchedSuccessfully = false;
  List<dynamic> allAPIfetchedElements = [];
  bool isLoading = true;

  @override
  void initState() {
    fetchIssueInfo();
    super.initState();

    Future.delayed(Duration(seconds: 2), ()
    {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ?
        Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
    : DefaultTabController(
        length: 3,
        child: Scaffold(
            extendBodyBehindAppBar: false,
            appBar: AppBar(
              centerTitle: false,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(top: 15, left: 12),
                child: Text(
                  allAPIfetchedElements[0]['Name'],
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w400),
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
                      icon: const Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.black,
                        size: 29,
                      )),
                )
              ],
            ),
            body: Column(children: [
              TabBar(tabs: [
                Tab(
                  icon: Icon(Icons.info_outline, color: Colors.black),
                ),
                Tab(
                  icon: Icon(Icons.medication_outlined, color: Colors.black),
                ),
                Tab(
                  icon: Icon(Icons.description_outlined, color: Colors.black),
                )
              ]),
              Expanded(
                child: TabBarView(children: [
                  Stack(fit: StackFit.expand, children: [
                    buildBackground(),
                    Align(alignment: Alignment(0, 0.15), child: buildAvatar()),
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
                  ]),
                  Stack(fit: StackFit.expand, children: [
                    buildBackground(),
                    Align(alignment: Alignment(0, 0.15), child: buildAvatar()),
                    Align(
                      alignment: Alignment(0, -0.8),
                      child: buildIllnessTreatment(),
                    ),
                    Align(
                      alignment: Alignment(0, 0.7),
                      child: buildDoctorButton(),
                    ),
                    Align(
                      alignment: Alignment(0, 0.85),
                      child: buildCompleteButton(),
                    )
                  ]),
                  Stack(fit: StackFit.expand, children: [
                    buildBackground(),
                    Align(alignment: Alignment(0, 0.15), child: buildAvatar()),
                    Align(
                      alignment: Alignment(0, -0.8),
                      child: buildIllnessCondition(),
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
                ]),
              )
            ])));
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
      width: 180,
      height: 180,
    ));
  }

  Widget buildIllnessDetails() {
    return Container(
      height: 240,
      width: 350,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.all(Radius.circular(50))),
      child: _dataFetchedSuccessfully
          ? Stack(
              children: [
                Align(
                  alignment: Alignment(0, -0.6),
                  child: Text(allAPIfetchedElements[0]['Description'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      )),
                )
              ],
            )
          : Text('Loqdnig'),
    );
  }

  Widget buildIllnessCondition() {
    return Container(
      height: 240,
      width: 350,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.all(Radius.circular(50))),
      child: _dataFetchedSuccessfully
          ? Stack(
        children: [
          Align(
            alignment: Alignment(0, -0.6),
            child: Text(allAPIfetchedElements[0]['MedicalCondition'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                )),
          )
        ],
      )
          : Text('Loqdnig'),
    );
  }

  Widget buildIllnessTreatment() {
    return Container(
      height: 240,
      width: 350,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.all(Radius.circular(50))),
      child: _dataFetchedSuccessfully
          ? Stack(
        children: [
          Align(
            alignment: Alignment(0, -0.6),
            child: Text(allAPIfetchedElements[0]['TreatmentDescription'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                )),
          )
        ],
      )
          : Text('Loqdnig'),
    );
  }

  void _fetchAPIelem(String apiURL) async {
    final url = apiURL;
    final uri = Uri.parse(url);
    final response;

    response = await http.get(uri.replace(queryParameters: {
      'token': widget.accessToken,
      'issue_id': widget.pickedIssueID.toString(),
      'language': 'en-gb',
    }));

    if (response.statusCode == 200) {
      final Map<String, dynamic> apiInfo = json.decode(response.body);
      allAPIfetchedElements.add(apiInfo);
      _dataFetchedSuccessfully = true;
      setState(() {});
    } else if (response.statusCode == 400) {
      print("error 400 while fetching data : ${response.body}");
    } else {
      print('Error while fetching data :\n'
          '${response.statusCode} : ${response.body}');
    }
  }

  void fetchIssueInfo() {
    _fetchAPIelem(
        'https://sandbox-healthservice.priaid.ch/issues/${widget.pickedIssueID}/info');
  }

  Widget buildDoctorButton() {
    return Container(
      child: TextButton(
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: Color(0xFF00ACC2)))),
          onPressed: () {},
          child: Padding(
              padding: const EdgeInsets.only(left: 57, right: 57),
              child: Text('Find a doctor',
                  style:
                      TextStyle(fontSize: 19, fontWeight: FontWeight.w300)))),
    );
  }

  Widget buildCompleteButton() {
    return Container(
      child: TextButton(
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: Color(0xFF00ACC2)))),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          child: Padding(
              padding: const EdgeInsets.only(left: 70, right: 70),
              child: Text('Complete',
                  style:
                      TextStyle(fontSize: 19, fontWeight: FontWeight.w300)))),
    );
  }
}
