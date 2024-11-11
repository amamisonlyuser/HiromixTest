import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'package:neopop/neopop.dart';
import 'SignUpPage.dart';
import 'GlobalData.dart';
import 'send_otp_page.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import 'package:provider/provider.dart'; // If using Provider for state management






class VerifyOtpPage extends StatefulWidget {
  final String phoneNumber;
   const VerifyOtpPage({super.key, required this.phoneNumber});

  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool InvalidOtp = false;
  bool _isResendEnabled = false;
  int _remainingSeconds = 30;
  late Timer _timer;


@override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

 void _startTimer() {
    _isResendEnabled = false;
    _remainingSeconds = 30;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
        setState(() {
          _isResendEnabled = true;
        });
      }
    });
  }
void verifyOtp(String phoneNumber, String otp, BuildContext context) async {
  try {
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
      // Decode the response data
      Map<String, dynamic> responseData = json.decode(response.body);
      print('Response Data: $responseData'); // Debugging responseData

      // Check if statusCode is 200 within the response data
      if (responseData.containsKey('statusCode') && responseData['statusCode'] == 200) {
        // Decode the body field
        Map<String, dynamic> bodyData = json.decode(responseData['body']);
         // Debugging decoded body

        // Extract the jwtToken and action from the body
        String jwtToken = bodyData['jwtToken'];
        GlobalData().setJwtToken(jwtToken);
        GlobalData().setPhoneNumber(phoneNumber);
        print('Decoded Body: $jwtToken');
        // Check for 'complete_signup' action
        if (bodyData['action'] == 'complete_signup') {
          List<Map<String, dynamic>> institutionData = bodyData.containsKey('institutions') && bodyData['institutions'] != null
              ? List<Map<String, dynamic>>.from(bodyData['institutions']).map((institution) => {
                  'SK': institution['SK'],
                  'institution_name': institution['institution_name'],
                }).toList()
              : [];
          // Debugging institution data

          // Navigate to the SignUpPage with institution data
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpPage(
                phoneNumber: phoneNumber,
                jwtToken: jwtToken,
                institutions: institutionData,
              ),
            ),
          );
        } else {
          // Navigate to the MyHomePage after successful authentication
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(
                phoneNumber: phoneNumber,
              ),
            ),
          );
        }
      } else {
        print('Response Error: $responseData');
      }
    } else if (response.statusCode == 400) {
      // Display error if OTP is invalid
      final responseData = json.decode(response.body);
      print('Response Error: $responseData');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          content: Text('Invalid OTP, please try again'),
        ),
      );
    }
  } catch (e) {
    print('Error during OTP verification: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text('An error occurred. Please try again.'),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final globalData = Provider.of<GlobalData>(context); // Accessing GlobalData
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
      backgroundColor: Colors.black,
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
            const SizedBox(height: 10),
            Text(
              'Sent to ${widget.phoneNumber}',
              style: TextStyle(
                color: Colors.grey, // Grey text
                fontSize: 14, // Smaller font size
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
                // Combine OTP from all controllers
                String otp = _otpControllers.map((controller) => controller.text).join();
                
                // Call the verifyOtp function
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
            const SizedBox(height: 20),
            Text(
              'Resend OTP in $_remainingSeconds seconds',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
             ElevatedButton(
      onPressed: _isResendEnabled ? () {
        // Retrieve data from the global class
        String? email = globalData.getEmail();
        String? name = globalData.getUserName();
        String? phoneNumber = globalData.getPhoneNumber();

        // Call sendOtp with retrieved values
        if (email != null && name != null && phoneNumber != null) {
          sendOtp(email, name, phoneNumber);
        } else {
          // Handle the case where data is not available
          print('Global data not available.');
        }
      } : null,
      child: const Text('Resend OTP'),
    )
          ],
        ),
      ),
    );
  }
}
