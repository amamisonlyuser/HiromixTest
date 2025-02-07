import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rizz/main.dart';
import 'dart:convert';
import 'package:neopop/neopop.dart' as neopop;
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences


 // Import the GlobalData class

class SignUpPage extends StatefulWidget {
  final String phone_number;
  final String jwtToken;
  // Accept institutions data

  const SignUpPage({
    super.key,
    required this.phone_number,
    required this.jwtToken,
   
  });

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  String? _firstName;
  String? _lastName;
  int? _age;
  String? _gender;
  String? _state;
  String? _city;

  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    setState(() {
      _currentPage++;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Signup'),
        backgroundColor: Colors.black,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
        
          GenderPage(onNext: (value) {
            setState(() => _gender = value);
            _nextPage();
          }),
          FirstNamePage(onNext: (value) {
            setState(() => _firstName = value);
            _nextPage();
          }),
          LastNamePage(onNext: (value) {
            setState(() => _lastName = value);
            _nextPage();
          }),
          AgePage(onNext: (value) {
            setState(() => _age = value);
            _nextPage();
          }),
          // Pass data to SummaryPage
          SummaryPage(data: {
            'phone_number': widget.phone_number,
            'first_name': _firstName,
            'last_name': _lastName,
            'age': _age?.toString(),
            'gender': _gender,
            'state': _state,
            'city': _city,
            'jwt_token': widget.jwtToken,
            
          },phone_number:widget.phone_number),
        ],
      ),
    );
  }
}



class SummaryPage extends StatelessWidget {
  final Map<String, String?> data;
  final String phone_number;

  const SummaryPage({super.key, required this.data, required this.phone_number});

  // Function to send POST request for signup
  Future<void> _sendSignupRequest(BuildContext context) async {
    const apiUrl = 'https://innqn6dwv1.execute-api.ap-south-1.amazonaws.com/prod/User/SignUp';

    // Request body without the "body" wrapper
    final requestBody = {
      'phone_number': data['phone_number'] ?? '',
      'first_name': data['first_name'] ?? '',
      'last_name': data['last_name'] ?? '',
      'age': int.tryParse(data['age'] ?? '0') ?? 0,
      'gender': data['gender'] ?? '',
      'state': data['state'] ?? '',
      'city': data['city'] ?? '',
      'jwt_token': data['jwt_token'] ?? '',
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        try {
          final responseData = json.decode(response.body);
          print('Signup successful: $responseData');

          // Save each value to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          
          // Iterate over requestBody and save each item
          for (String key in requestBody.keys) {
            var value = requestBody[key];
            
            // Store value as appropriate type
            if (value is int) {
              await prefs.setInt(key, value);
            } else if (value is String) {
              await prefs.setString(key, value);
            }
          }

          // Additional flag for authentication
          await prefs.setBool('isAuthenticated', true); 
          
           // Set user as authenticated

          // Navigate to PollsPage after successful signup
           Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(phone_number: phone_number),
              ),
            ); 
        } catch (e) {
          print('Response is not in JSON format: ${response.body}');
        }
      } else {
        print('Failed to signup: Status Code ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error during signup: $e');
    }
  }

  // Initialize the current page indexes
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...data.entries.map((entry) {
            return Text('${entry.key}: ${entry.value ?? ''}');
          }).toList(),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Call the signup function with extracted data and context
                _sendSignupRequest(context);
              },
              child: const Text('Submit Signup'),
            ),
          ),
        ],
      ),
    );
  }
}



class FirstNamePage extends StatelessWidget {
  final ValueChanged<String> onNext;

  const FirstNamePage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    String? firstName;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Orange background to match the image
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
          children: [
            const Text(
              "What's your first name?",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white, // White text color
              ),
            ),
            const SizedBox(height: 10),
            
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter your first name',
                hintStyle: const TextStyle(color: Color.fromARGB(255, 204, 204, 204)), // Hint text color
                filled: true,
                fillColor: const Color.fromARGB(255, 35, 35, 35), // Light transparent white background for the input field
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0), // Rounded corners for the text field
                  borderSide: BorderSide.none, // No border
                ),
              ),
              style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)), // Input text color
              onChanged: (value) => firstName = value,
            ),
            const SizedBox(height: 60),
            Center(
              child: SizedBox(
                height: 80, // Button height
                child: neopop.NeoPopTiltedButton(
  isFloating: true, // Make the button floating
  decoration: const neopop.NeoPopTiltedButtonDecoration(
    color: Colors.white, // White background for the button
    plunkColor: Color.fromARGB(255, 212, 212, 212), // Light gray for the plunk effect
    shadowColor: Color.fromARGB(255, 54, 54, 54), // Shadow color
  ),
  onTapUp: () {
    if (firstName != null && firstName!.isNotEmpty) { // Check if firstName is not null or empty
      onNext(firstName!); // Call the onNext function with firstName
    }
  },
  child: const Padding(
    padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 20), // Padding around the button text
    child: Text(
      'Next', // Button label
      style: TextStyle(
        color: Color.fromARGB(255, 0, 0, 0), // Black text on the button
        fontSize: 18, // Font size
        fontWeight: FontWeight.bold, // Bold text
      ),
    ),
  ),
)

              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LastNamePage extends StatelessWidget {
  final ValueChanged<String> onNext;

  const LastNamePage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    String? lastName;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Same black background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What's your last name?",
              style: TextStyle(
                fontSize: 30, // Increased font size for consistency
                color: Colors.white, // White text color
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter your last name',
                hintStyle: const TextStyle(color: Color.fromARGB(255, 204, 204, 204)), // Hint text color
                filled: true,
                fillColor: const Color.fromARGB(255, 35, 35, 35), // Same input field background color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0), // Rounded corners for the text field
                  borderSide: BorderSide.none, // No border
                ),
              ),
              style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)), // Input text color
              onChanged: (value) => lastName = value,
            ),
            const SizedBox(height: 60),
            Center(
              child: SizedBox(
                height: 80, // Button height
                child: neopop.NeoPopTiltedButton(
                  isFloating: true, // Make the button floating
                  decoration: const neopop.NeoPopTiltedButtonDecoration(
                    color: Colors.white, // White background for the button
                    plunkColor: Color.fromARGB(255, 212, 212, 212), // Light gray for the plunk effect
                    shadowColor: Color.fromARGB(255, 54, 54, 54), // Shadow color
                  ),
                  onTapUp: () {
                    if (lastName != null && lastName!.isNotEmpty) { // Check if lastName is not null or empty
                      onNext(lastName!); // Call the onNext function with lastName
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 20), // Padding around the button text
                    child: Text(
                      'Next', // Button label
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), // Black text on the button
                        fontSize: 18, // Font size
                        fontWeight: FontWeight.bold, // Bold text
                      ),
                    ),
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

 









 



class GenderPage extends StatefulWidget {
  final ValueChanged<String> onNext;

  const GenderPage({required this.onNext, super.key});

  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 0, 0, 0), // Black background
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Select Your Gender',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _genderImage('Male', 'assets/male.svg'),
              _genderImage('Female', 'assets/female.svg'),
            ],
          ),
          const SizedBox(height: 10),
          Center(child: _genderImage('Other', 'assets/other.svg')),
          const SizedBox(height: 30),
          neopop.NeoPopTiltedButton(
            isFloating: true,
            decoration: const neopop.NeoPopTiltedButtonDecoration(
              color: Color.fromARGB(255, 255, 255, 255), // Button color (white)
              plunkColor: Color.fromARGB(255, 212, 212, 212), // Secondary color (light gray)
              shadowColor: Color.fromARGB(255, 54, 54, 54), // Shadow color
            ),
            onTapUp: () {
              if (selectedGender != null) { // Check if a gender is selected
                widget.onNext(selectedGender!); // Call the onNext function with selectedGender
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 15),
              child: Text(
                'Next', // Button label
                style: TextStyle(
                  color: Colors.black, // Text color (black)
                  fontSize: 18, // Font size
                  fontWeight: FontWeight.bold, // Font weight
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _genderImage(String gender, String imagePath) {
    Color borderColor;
  
    if (selectedGender == gender) {
      if (gender == 'Male') {
        borderColor = Colors.blue;
      } else if (gender == 'Female') {
        borderColor = Colors.pink;
      } else {
        // Create a rainbow gradient for "Other"
        borderColor = Colors.transparent; // Set transparent as base, handled by gradient
      }
    } else {
      borderColor = Colors.transparent;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender; // Update selected gender
        });
      },
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor,
                width: 4,
              ),
              gradient: selectedGender == 'Other' && gender == 'Other'
                  ? const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 163, 67, 60),
                        Color.fromARGB(255, 255, 196, 107),
                        Color.fromARGB(255, 255, 245, 156),
                        Color.fromARGB(255, 54, 252, 206),
                        Color.fromARGB(255, 33, 152, 243),
                        Color.fromARGB(255, 85, 106, 221),
                        Color.fromARGB(255, 226, 29, 200),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SvgPicture.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            gender,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}





class AgePage extends StatefulWidget {
  final ValueChanged<int> onNext;

  const AgePage({super.key, required this.onNext});

  @override
  _AgePageState createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  int selectedAge = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Black background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter your age',
              style: TextStyle(
                fontSize: 30, // Increased font size for consistency
                color: Colors.white, // White text color
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 200, // Adjust height to make the picker visible
              child: CupertinoPicker(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Match background color
                itemExtent: 40.0, // Height of each item
                scrollController: FixedExtentScrollController(initialItem: selectedAge - 5),
                onSelectedItemChanged: (int index) {
                  setState(() {
                    selectedAge = index + 5;
                  });
                },
                children: List<Widget>.generate(86, (int index) {
                  return Center(
                    child: Text(
                      (index + 5).toString(),
                      style: const TextStyle(color: Colors.white), // White text color
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 60), // Increased space for consistency
            Center(
              child: SizedBox(
                height: 80, // Button height
                child: neopop.NeoPopTiltedButton(
                  isFloating: true, // Make the button floating
                  decoration: const neopop.NeoPopTiltedButtonDecoration(
                    color: Colors.white, // White button background
                    plunkColor: Color.fromARGB(255, 212, 212, 212), // Light gray for the plunk effect
                    shadowColor: Color.fromARGB(255, 54, 54, 54), // Shadow color
                  ),
                  onTapUp: () {
 // Check if selectedAge is not null
                    widget.onNext(selectedAge); // Call the onNext function with selectedAge
                                    },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 20), // Padding around the button text
                    child: Text(
                      'Next', // Button label
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), // Black text on the button
                        fontSize: 18, // Font size
                        fontWeight: FontWeight.bold, // Bold text
                      ),
                    ),
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