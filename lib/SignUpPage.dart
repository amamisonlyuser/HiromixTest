import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'package:neopop/neopop.dart' as neopop;
import 'GlobalData.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
 // Import the GlobalData class

class SignUpPage extends StatefulWidget {
  final String phoneNumber1;
  final String jwtToken1;
  final List<dynamic> institutions1; // Accept institutions data

  SignUpPage({
    Key? key,
    required this.phoneNumber1,
    required this.jwtToken1,
    required this.institutions1,
  }) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  String? _firstName;
  String? _lastName;
  String? _institutionName; // This might be nullable, so no `!` here directly
  String _institutionShortName = ''; // Default to an empty string if it should not be null

  int? _age;
  String? _gender;
  String? _state;
  String? _city;

  // To track selected institution
  String? _selectedInstitution;



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
          institutions: widget.institutions1, // Pass the list of institutions
        ),
        SummaryPage(data: {
          'First Name': _firstName,
          'Last Name': _lastName,
          'Institution': _selectedInstitution,
          'Institution Short Name': _institutionShortName,
          'Age': _age.toString(),
          'Gender': _gender,
          'State': _state,
          'City': _city,
        }),
      ],
    ),
  );
}



  Future<void> _completeSignup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Check for null values before creating the signup data
      if (_firstName == null || _lastName == null ||  
          _institutionName == null || _age == null || _gender == null ||
          _state == null || _city == null) {
        // Handle error (show a message or log)
        print('Please ensure all fields are filled out properly.');
        return;
      }

      // Create the body for the POST request
      final Map<String, dynamic> signupData = {
        "phone_number": widget.phoneNumber1,
        "institution_short_name": _institutionShortName,
        "institution_name": _institutionName,
        "first_name": _firstName,
        "last_name": _lastName,
        "age": _age,
        "gender": _gender,
        "state": _state,
        "city": _city,
        "jwt_token": widget.jwtToken1, // Include the JWT token
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse('https://innqn6dwv1.execute-api.ap-south-1.amazonaws.com/prod/User/SignUp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"body": jsonEncode(signupData)}),
      );

      if (response.statusCode == 200) {
        // Successful signup
        
        // Save data to GlobalData
        GlobalData().setPhoneNumber(widget.phoneNumber1);
        GlobalData().setFirstName('${_firstName}');
        GlobalData().setLastName('${_lastName}');
        GlobalData().setInstitutionShortName('${_institutionShortName}');
        GlobalData().setInstitutionName('${_institutionName}');
        GlobalData().setAge(_age!);
        GlobalData().setGender('${_gender}');
        GlobalData().setState('${_state}');
        GlobalData().setCity('${_city}');

        // Navigate to MyHomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage(phoneNumber: widget.phoneNumber1)),
        );
      } else {
        // Handle error
        print('Signup failed: ${response.body}');
      }
    }
  }

  
  
}


class FirstNamePage extends StatelessWidget {
  final ValueChanged<String> onNext;

  FirstNamePage({required this.onNext});

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

  LastNamePage({required this.onNext});

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

  InstitutionPage({required this.institutions, required this.onNext});

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
    _getCurrentLocation();

    // Sort the initial list of institutions alphabetically by name
    filteredInstitutions = List.from(widget.institutions)
      ..sort((a, b) => (a['institution_name'] ?? '').compareTo(b['institution_name'] ?? ''));
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) return;
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        setState(() {
          city = placemarks[0].locality;
          state = placemarks[0].administrativeArea;
        });
      }
    } catch (e) {
      print(e);
    }
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
            orElse: () => {'SK': 'Institution#DefaultShortName'}, // Default value
          )['SK']?.split('#').last ?? 'DefaultShortName') // Get the last part after '#'
      : 'SampleShortName';

  return Container(
    color: const Color.fromARGB(255, 0, 0, 0), // Black background color
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        Text(
          state != null ? 'State: $state' : 'Fetching state...',
          style: const TextStyle(color: Colors.white), // White text color
        ),
        Text(
          city != null ? 'City: $city' : 'Fetching city...',
          style: const TextStyle(color: Colors.white), // White text color
        ),
        const SizedBox(height: 20),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Search for an institution',
            labelStyle: TextStyle(color: Colors.white54), // Light grey label text
            filled: true,
            fillColor: Colors.grey, // Grey background for the search field
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.grey), // Light grey border
            ),
          ),
          style: const TextStyle(color: Colors.white), // White input text color
          onChanged: _filterInstitutions,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: filteredInstitutions.length,
            itemBuilder: (context, index) {
              final institution = filteredInstitutions[index];
              final institutionName = institution['institution_name'] ?? 'Unknown Institution';
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800], // Dark grey background for list items
                  border: Border(
                    bottom: BorderSide(color: Colors.grey), // Light grey border
                  ),
                ),
                child: ListTile(
                  title: Text(
                    institutionName,
                    style: const TextStyle(color: Colors.white), // White text color
                  ),
                  onTap: () {
                    setState(() {
                      selectedInstitution = institutionName;
                    });
                  },
                  selected: selectedInstitution == institutionName,
                  selectedTileColor: Colors.grey[700], // Slightly lighter grey for selected item
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20), // Add space before the button
        SizedBox(
          height: 80, // Button height for consistency
          child: neopop.NeoPopTiltedButton(
            isFloating: true,
            decoration: const neopop.NeoPopTiltedButtonDecoration(
              color: Colors.white, // Button color (white)
              plunkColor: Color.fromARGB(255, 212, 212, 212), // Light gray for the plunk effect
              shadowColor: Color.fromARGB(255, 54, 54, 54), // Shadow color
            ),
            onTapUp: () {
              if (selectedInstitution != null && state != null && city != null) {
                widget.onNext(selectedInstitution!, shortName, state!, city!); // Pass required parameters to onNext
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 20), // Button padding
              child: Text(
                'Next', // Button label
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0), // Black text color
                  fontSize: 18, // Font size
                  fontWeight: FontWeight.bold, // Bold font weight
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}



class SummaryPage extends StatelessWidget {
  final Map<String, String?> data;

  SummaryPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data.entries.map((entry) {
          return Text('${entry.key}: ${entry.value ?? ''}');
        }).toList(),
      ),
    );
  }
}

class AgePage extends StatefulWidget {
  final ValueChanged<int> onNext;

  AgePage({required this.onNext});

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
                    if (selectedAge != null) { // Check if selectedAge is not null
                      widget.onNext(selectedAge); // Call the onNext function with selectedAge
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

  const GenderPage({required this.onNext, Key? key}) : super(key: key);

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
              _genderImage('Male', 'assets/male.png'),
              _genderImage('Female', 'assets/female.png'),
            ],
          ),
          const SizedBox(height: 10),
          Center(child: _genderImage('Other', 'assets/other.png')),
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
                ? LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.orange,
                      Colors.yellow,
                      Colors.green,
                      Colors.blue,
                      Colors.indigo,
                      Colors.purple,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
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
}}