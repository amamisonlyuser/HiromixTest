import 'package:flutter/material.dart';
import 'package:neopop/neopop.dart';
import 'dart:async';
import 'verify_otp_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SendOtpPage extends StatefulWidget {
  const SendOtpPage({super.key});

  @override
  _SendOtpPageState createState() => _SendOtpPageState();
}

class _SendOtpPageState extends State<SendOtpPage> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  int _bgIndex = 0;
  bool showLoginScreen = true;
  final List<String> _bgImages = [
    'assets/bg3.png',
    'assets/bg4.png',
    'assets/bg6.png',
    'assets/bg10.png'
  ];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() => _bgIndex = (_bgIndex + 1) % _bgImages.length);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showLoginScreen ? _buildLoginScreen() : _buildOtpScreen(),
    );
  }

Widget _buildLoginScreen() {
  return Stack(
    children: [
      // Black Background
      Container(color: Colors.black),

      // Centered Content
      Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
            children: [
              const SizedBox(height: 60),
              Image.asset(
                'assets/Welcome.png',
                width: 250,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 40),

              // Image Box
              Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    child: Image.asset(
                      _bgImages[_bgIndex],
                      key: ValueKey(_bgImages[_bgIndex]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Login Button
              NeoPopTiltedButton(
                isFloating: true,
                decoration: NeoPopTiltedButtonDecoration(
                  color: Colors.white,
                  plunkColor: Colors.grey[300]!,
                  shadowColor: Colors.black,
                ),
                onTapUp: () => setState(() => showLoginScreen = false),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: Text(
                    'Login / Signup',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100), // Space before footer

              // Footer Section
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    const Text(
                      'Help and support: Aman@hiromix.club',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () async {
                          final url = Uri.parse(
                            'https://www.freeprivacypolicy.com/live/8d997e19-86bc-49e7-9ec9-aca9684d8c4e'
                          );
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                        child: const Text(
                          'Privacy Policy',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

  Widget _buildOtpScreen() {
    return Container(
      color: const Color.fromARGB(255, 0, 0, 0),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Phone Image at Top
              Image.asset(
                'assets/Phone.png',
                width: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 40),

              // Input Fields
              SizedBox(
                width: 300,
                child: _buildInputField(_emailController, 'Email'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: _buildInputField(_nameController, 'Name'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: _buildInputField(_phoneController, 'Phone Number', isPhone: true),
              ),
              const SizedBox(height: 40),

              // Send OTP Button
              NeoPopTiltedButton(
                isFloating: true,
                decoration: NeoPopTiltedButtonDecoration(
                  color: Colors.white,
                  plunkColor: Colors.grey[300]!,
                  shadowColor: Colors.black,
                ),
                onTapUp: () {
                // Update global data with input values
                sendOtp(_emailController.text, _nameController.text, _phoneController.text); // Function to send OTP
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VerifyOtpPage(phone_number: _phoneController.text,)), // Navigate to OTP verification page
                );
              },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: Text(
                    'Send OTP',
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
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, 
                         {bool isPhone = false}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: isPhone ? TextInputType.phone : TextInputType.emailAddress,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        alignLabelWithHint: true,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }

  

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
}