import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'package:neopop/neopop.dart';
import 'SignUpPage.dart';
import 'package:flutter/animation.dart';
import 'dart:async';






class VerifyOtpPage extends StatefulWidget {
  final String phone_number;
  final String? otp; // Optional OTP parameter for autofill

  const VerifyOtpPage({
    super.key,
    required this.phone_number,
    this.otp, // Make OTP optional
  });

  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _invalidOtp = false;
  bool _isResendEnabled = false;
  int _remainingSeconds = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();

    // Autofill OTP if provided
    if (widget.otp != null && widget.otp!.length == 6) {
      _autofillOtp(widget.otp!);
      // Optionally trigger auto-verification after autofill
      Future.delayed(const Duration(milliseconds: 500), () {
        verifyOtp(widget.phone_number, widget.otp!, context);
      });
    }
  }

  void _autofillOtp(String otp) {
    for (int i = 0; i < 6; i++) {
      _otpControllers[i].text = otp[i];
    }
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

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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

  void verifyOtp(String phone_number, String otp, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('https://innqn6dwv1.execute-api.ap-south-1.amazonaws.com/prod/User/Auth'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "phone_number": phone_number,
          "otp": otp,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['statusCode'] == 200) {
          Map<String, dynamic> bodyData = json.decode(responseData['body']);
          String jwtToken = bodyData['jwtToken'];
          String institution_short_name = bodyData['institution_short_name'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isAuthenticated', true);
          await prefs.setString('phone_number', phone_number);
          await prefs.setString('jwtToken', jwtToken);
          await prefs.setString('institution_short_name', institution_short_name);


          if (bodyData['action'] == 'complete_signup') {

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpPage(
                  phone_number: phone_number,
                  jwtToken: jwtToken,
                ),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(phone_number:phone_number),
              ),
            );
          }
        } else {
          _showErrorSnackBar('Authentication failed. Please try again.');
        }
      } else if (response.statusCode == 400) {
        _showErrorSnackBar('Invalid OTP, please try again.');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred. Please try again.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP', style: TextStyle(color: Colors.white)),
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
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(color: Colors.black),
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
                verifyOtp(widget.phone_number, otp, context);
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
            
          ],
        ),
      ),
    );
  }
}




