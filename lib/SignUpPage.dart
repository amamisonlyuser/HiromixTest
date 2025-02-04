import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'PollsPage.dart';
import 'package:neopop/neopop.dart' as neopop;
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences


 // Import the GlobalData class

class SignUpPage extends StatefulWidget {
  final String phoneNumber;
  final String jwtToken;
  final List<dynamic> institutions; // Accept institutions data

  const SignUpPage({
    super.key,
    required this.phoneNumber,
    required this.jwtToken,
    required this.institutions,
  });

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  String? _firstName;
  String? _lastName;
  String? _selectedInstitution;
  String _institutionShortName = ''; // Default to an empty string if it should not be null
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
          InstitutionPage(
            onNext: (selectedInstitution, shortName, state, city) {
              setState(() {
                _selectedInstitution = selectedInstitution;
                _institutionShortName = shortName;
                _state = state;
                _city = city;
              });
              _nextPage();
            },
            institutions: widget.institutions,
          ),
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
            'phone_number': widget.phoneNumber,
            'institution_short_name': _institutionShortName,
            'institution_name': _selectedInstitution,
            'first_name': _firstName,
            'last_name': _lastName,
            'age': _age?.toString(),
            'gender': _gender,
            'state': _state,
            'city': _city,
            'jwt_token': widget.jwtToken,
          }),
        ],
      ),
    );
  }
}



class SummaryPage extends StatelessWidget {
  final Map<String, String?> data;

  const SummaryPage({super.key, required this.data});

  // Function to send POST request for signup
  Future<void> _sendSignupRequest(BuildContext context) async {
    const apiUrl = 'https://innqn6dwv1.execute-api.ap-south-1.amazonaws.com/prod/User/SignUp';

    // Request body without the "body" wrapper
    final requestBody = {
      'phone_number': data['phone_number'] ?? '',
      'institution_short_name': data['institution_short_name'] ?? '',
      'institution_name': data['institution_name'] ?? '',
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
          await prefs.setBool('isAuthenticated', true);  // Set user as authenticated

          // Navigate to PollsPage after successful signup
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PollsPage(
                phoneNumber: data['phone_number'] ?? '',
                institution_short_name: data['institution_short_name'] ?? '',
              ),
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

 




class InstitutionPage extends StatefulWidget {
  final List<dynamic> institutions;
  final Function(String, String, String, String) onNext;

  const InstitutionPage({super.key, required this.institutions, required this.onNext});

  @override
  _InstitutionPageState createState() => _InstitutionPageState();
}

class _InstitutionPageState extends State<InstitutionPage> {
  String? selectedInstitution;
  List<dynamic> filteredInstitutions = [];
  String searchQuery = '';

  String? state;
  String? city;

  @override
  void initState() {
    super.initState();
    // Simulated current location retrieval for the sake of example
    filteredInstitutions = List.from(widget.institutions)
      ..sort((a, b) => (a['institution_name'] ?? '').compareTo(b['institution_name'] ?? ''));
    
    _getCurrentLocation(); // Get the current location when the page loads
  }

  // Function to get the current location and update state and city
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, request to enable them
      await Geolocator.openLocationSettings();
      return;
    }

    // Check and request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return;
      }
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Use geocoding to get the address from the coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];

    setState(() {
      state = placemark.administrativeArea; // State
      city = placemark.locality; // City
    });
  }

  void _filterInstitutions(String query) {
    final filtered = widget.institutions.where((institution) {
      final name = institution['institution_name']?.toLowerCase() ?? '';
      return name.contains(query.toLowerCase());
    }).toList();

    filtered.sort((a, b) => (a['institution_name'] ?? '').compareTo(b['institution_name'] ?? ''));

    setState(() {
      searchQuery = query;
      filteredInstitutions = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    String shortName = selectedInstitution != null
        ? (widget.institutions.firstWhere(
              (inst) => inst['institution_name'] == selectedInstitution,
              orElse: () => {'SK': 'Institution#DefaultShortName'},
            )['SK']?.split('#').last ?? 'DefaultShortName')
        : 'SampleShortName';

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Search for an institution',
              labelStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.grey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: _filterInstitutions,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 0, 0),
                borderRadius: BorderRadius.circular(0),
              ),
              child: ListView.builder(
                itemCount: filteredInstitutions.length,
                itemBuilder: (context, index) {
                  final institution = filteredInstitutions[index];
                  final institutionName = institution['institution_name'] ?? 'Unknown Institution';
                  final isSelected = selectedInstitution == institutionName;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedInstitution = institutionName;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.circular(10.0),
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 2.0)
                            : Border.all(color: Colors.transparent),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              institutionName,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage('assets/college_logo.png'), // Example logo path
                            radius: 16,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 80,
            child: neopop.NeoPopTiltedButton(
              isFloating: true,
              decoration: const neopop.NeoPopTiltedButtonDecoration(
                color: Colors.white,
                plunkColor: Color.fromARGB(255, 212, 212, 212),
                shadowColor: Color.fromARGB(255, 54, 54, 54),
              ),
              onTapUp: () {
                // Ensure that selectedInstitution, state, and city are not null
                if (selectedInstitution != null) {
                  widget.onNext(
                    selectedInstitution!, 
                    shortName, 
                    state ?? 'DefaultState', // Use default values if null
                    city ?? 'DefaultCity',   // Use default values if null
                  );
                } else {
                  // You can show a dialog or feedback to the user that they need to select an institution
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select an institution')),
                  );
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 20),
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // "Skip" button
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 255, 42), // Yellow background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12), // Reduced padding
            ),
            onPressed: () {
              widget.onNext('None', 'None', state ?? '', city ?? '');
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 16, // Reduced font size
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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