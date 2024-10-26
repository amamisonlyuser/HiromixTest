import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'package:neopop/neopop.dart';
import 'SignUpPage.dart';
import 'GlobalData.dart';




class VerifyOtpPage extends StatefulWidget {
  final String phoneNumber;
   const VerifyOtpPage({super.key, required this.phoneNumber});

  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
void verifyOtp( phoneNumber,  otp, BuildContext context) async {
  final response = await http.post(
    Uri.parse('https://innqn6dwv1.execute-api.ap-south-1.amazonaws.com/prod/User/Auth'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "phone_number": phoneNumber,
      "otp": otp,
    }),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = json.decode(response.body);

    if (responseData.containsKey('statusCode') && responseData['statusCode'] == 200) {
      // Decode the 'body' field which is a JSON string
      Map<String, dynamic> bodyData = json.decode(responseData['body']);
      print(bodyData);

      // Initialize a list for institution data
      List<dynamic> institutionData = [];

      String jwtToken = bodyData['jwtToken'];
      

      // Check for 'action' in the response body
      if (bodyData.containsKey('action')) {
        if (bodyData['action'] == 'complete_signup') {
          // If institutions are present in the response, store them in a list
          if (bodyData.containsKey('institutions') && bodyData['institutions'] != null) {
            institutionData = List.from(bodyData['institutions']).map((institution) => {
              'SK': institution['SK'],
              'institution_name': institution['institution_name'],
            }).toList();
  
            // Navigate to the SignUpPage if action is 'complete_signup'
            print('Phone Number: $phoneNumber (Type: ${phoneNumber.runtimeType})');
            print('JWT Token: $jwtToken (Type: ${jwtToken.runtimeType})');
            print( 'List $institutionData (Type: ${institutionData.runtimeType})');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpPage(
                  phoneNumber1: phoneNumber ?? '',
                 
                  jwtToken1: jwtToken ?? '', // Provide a fallback for null
                  institutions1: institutionData ?? [], // Pass institution data as a list
                ),
              ),
            );
            
          } else {
            print('No institutions found in response.');
          }
        } else        // Handle navigation for other actions if jwtToken is present
        
        GlobalData().setPhoneNumber(phoneNumber);
        GlobalData().setJwtToken(jwtToken);

        

        // Navigate to MyHomePage after successful authentication
        Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpPage(
                  phoneNumber1: phoneNumber ?? '',
                 
                  jwtToken1: jwtToken ?? '', // Provide a fallback for null
                  institutions1: institutionData ?? [], // Pass institution data as a list
                ),
              ),
            );
      
      } else {
        print('Invalid response format: Missing action key');
      }
    } else {
      print('Invalid response format: Missing statusCode or statusCode is not 200');
    }
  } else {
    print('Invalid OTP');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
              '',
              style: TextStyle(
                color: Color.fromARGB(255, 134, 134, 134),
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black, // Set background color of Scaffold
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Enter OTP',
              style: TextStyle(
                color: Color.fromARGB(255, 248, 248, 248),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 40,
                  child: TextFormField(
                    controller: _otpControllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        _focusNodes[index + 1].requestFocus();
                      }
                    },
                    decoration: const InputDecoration(
                      counter: Offstage(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                    ),
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            NeoPopTiltedButton(
              isFloating: true,
              decoration: const NeoPopTiltedButtonDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                plunkColor: Color.fromARGB(255, 212, 212, 212),
                shadowColor: Color.fromARGB(255, 54, 54, 54),
              ),
              onTapUp: () {
                String otp = _otpControllers.map((controller) => controller.text).join();
                verifyOtp(widget.phoneNumber, otp, context);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 12),
                child: Text(
                  'Verify OTP',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
