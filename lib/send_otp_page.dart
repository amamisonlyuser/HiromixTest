import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'verify_otp_page.dart';
import 'package:neopop/neopop.dart';
import 'GlobalData.dart';

// For HapticFeedback

void sendOtp(String email, String name, String phoneNumber) async {
  print('Sending OTP to $email, $name, $phoneNumber');
  try {
    final response = await http.post(
      Uri.parse('https://innqn6dwv1.execute-api.ap-south-1.amazonaws.com/prod/User/Otp'),
      body: json.encode({'email': email, 'name': name, 'phoneNumber': phoneNumber}),
    );
    if (response.statusCode == 200) {
      print('OTP Sent');
      print(response);
    } else {
      print('Failed to send OTP. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error sending OTP: $e');
  }
}

class SendOtpPage extends StatefulWidget {
  const SendOtpPage({super.key});

  @override
  _SendOtpPageState createState() => _SendOtpPageState();
}

class _SendOtpPageState extends State<SendOtpPage> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Login'), // Page title
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.grey[900], // Dark grey background
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white), // White text
            ),
            SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.grey[900], // Dark grey background
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white), // White text
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.grey[900], // Dark grey background
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              keyboardType: TextInputType.phone,
              style: TextStyle(color: Colors.white), // White text
            ),
            SizedBox(height: 20),
            NeoPopTiltedButton(
              isFloating: true,
              decoration: const NeoPopTiltedButtonDecoration(
                color: Color.fromARGB(255, 255, 255, 255), // Button color (white in this example)
                plunkColor: Color.fromARGB(255, 212, 212, 212), // Secondary color (light gray in this example)
                shadowColor: Color.fromARGB(255, 54, 54, 54), // Shadow color (standard gray)
              ),
              onTapUp: () {
                // Update global data with input values
                GlobalData().setPhoneNumber(_phoneController.text);
                GlobalData().setEmail(_emailController.text);
                GlobalData().setUserName(_nameController.text);
                sendOtp(_emailController.text, _nameController.text, _phoneController.text); // Function to send OTP
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VerifyOtpPage(phoneNumber: _phoneController.text,)), // Navigate to OTP verification page
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 15),
                child: Text(
                  'Send OTP', // Text label for the button
                  style: TextStyle(
                    color: Colors.black, // Text color (black in this example)
                    fontSize: 18, // Text size
                    fontWeight: FontWeight.bold, // Text weight
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