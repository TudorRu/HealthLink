import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({Key? key}) : super(key: key);

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final String API_ACCESS_TOKEN = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6Im1hbm50QGhvdG1haWwuZnIiLCJyb2xlIjoiVXNlciIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL3NpZCI6IjExODcyIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy92ZXJzaW9uIjoiMjAwIiwiaHR0cDovL2V4YW1wbGUub3JnL2NsYWltcy9saW1pdCI6Ijk5OTk5OTk5OSIsImh0dHA6Ly9leGFtcGxlLm9yZy9jbGFpbXMvbWVtYmVyc2hpcCI6IlByZW1pdW0iLCJodHRwOi8vZXhhbXBsZS5vcmcvY2xhaW1zL2xhbmd1YWdlIjoiZW4tZ2IiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL2V4cGlyYXRpb24iOiIyMDk5LTEyLTMxIiwiaHR0cDovL2V4YW1wbGUub3JnL2NsYWltcy9tZW1iZXJzaGlwc3RhcnQiOiIyMDIzLTAzLTAxIiwiaXNzIjoiaHR0cHM6Ly9zYW5kYm94LWF1dGhzZXJ2aWNlLnByaWFpZC5jaCIsImF1ZCI6Imh0dHBzOi8vaGVhbHRoc2VydmljZS5wcmlhaWQuY2giLCJleHAiOjE2Nzc2Nzc2MDIsIm5iZiI6MTY3NzY3MDQwMn0.7hWghFD3zG3dGS8aMjJw4uXAJcKdBi1H8POElFWXE94';
  String debugText = 'Initial text';
  String requestText = 'Initial request';
  List<dynamic> bodyPart = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API test Page'),
      ),
      body : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              requestText,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 50,),
            Text(
              debugText,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 50,),
            ElevatedButton(onPressed:(){
              _tryToConnect("Working fine");
              },
                child: Text('debug button')
            )
          ],
        ),
      )
    );
  }

  void _tryToConnect(String nexText) async {
    setState(() {
      debugText = nexText;
    });
    final String apiKey = 'mannt@hotmail.fr';

    final String url = 'https://sandbox-authservice.priaid.ch/login';
    final headers = {
      'Authorization': 'Bearer $apiKey:${_hashCredentials('https://sandbox-authservice.priaid.ch/login')}'
    };
    setState(() {
      requestText = '${Uri.parse(url)} \n$headers';
    });
    final response = await http.post(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      setState(() {
        debugText = 'Success';
      });
    }else if(response.statusCode == 400){
      debugText = "Wrong username or password";
    }
    else {
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

  void _fetchBodyPart() async{
    const url = 'https://sandbox-healthservice.priaid.ch/body/locations';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    jsonDecode(body);
  }
}


