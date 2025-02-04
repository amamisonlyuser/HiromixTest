import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neopop/neopop.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'AnimationPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class PollsPage extends StatefulWidget {
  final String phoneNumber;
  final String institution_short_name;

  const PollsPage({
    super.key,
    required this.phoneNumber,
     required this.institution_short_name,
    
  });

  @override
  _PollsPageState createState() => _PollsPageState();
}

class _PollsPageState extends State<PollsPage> {
  int _currentPollIndex = 0;
  final List<Map<String, String>> _selectedOptions = [];
  late AudioPlayer audioPlayer; // Track the currently selected option ID
  late PageController _pageController;
  late ScrollController _scrollController;
  bool optionScrolled = false; // Scroll controller

  // Variable to store poll data
  List<dynamic> pollData = [];

  @override
  void initState() {
    super.initState();

    // Initialize the audio player
    audioPlayer = AudioPlayer();

    // Initialize the ScrollController
    _scrollController = ScrollController();

    // Initialize the PageController with custom settings
    _pageController = PageController(
      viewportFraction: 0.5, // Pages take up half the screen width
      initialPage: 0, // Start at the first page
    );

    _fetchPollData(); // Fetch poll data on initialization
  }

  // Function to fetch poll data from API
 


Future<void> _fetchPollData() async {
  final apiUrl = 'https://innqn6dwv1.execute-api.ap-south-1.amazonaws.com/prod/User/GetPoll';
  
  // Retrieve data from widget properties
  String? institutionShortName = widget.institution_short_name;
  String? phoneNumber = widget.phoneNumber;
  
  // Log the data being passed to the API
  print("Sending data to API: ");
  print("Institution Short Name: $institutionShortName");
  print("Phone Number: $phoneNumber");

  // Define the JSON body to send to the API
  final data = {
    "institution_short_name": institutionShortName,
    "phone_number": phoneNumber,
  };
  
  // Log the complete JSON body
  print("Request body: ${json.encode(data)}");

  try {
  // Make the POST request to the API
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(data),
  );

  // Log the response from the server
  print("Response Status: ${response.statusCode}");
  print("Response Body: ${response.body}");

  // Check if the request was successful
  if (response.statusCode == 200) {
    // Decode the response
    final decodedResponse = json.decode(response.body);

    // Check if 'polls' key exists and is a list
    if (decodedResponse is Map && decodedResponse.containsKey('polls')) {
      final pollsList = decodedResponse['polls'];

      // Check if 'polls' is a list and is not empty
      if (pollsList is List && pollsList.isNotEmpty) {
        // Retrieve the poll_id from the first item in the 'polls' list
        String? pollId = pollsList[0]['poll_id'];
        print("Extracted Poll ID: $pollId");

        // Update pollData with fetched polls
        setState(() {
          pollData = pollsList; 
        });

        if (pollId != null) {
          // Save poll_id to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('poll_id', pollId);
          print("Poll ID saved to SharedPreferences: $pollId");
        } else {
          print("Poll ID not found in response.");
        }

        // Log the updated poll data
        print("Poll Data: $pollData");
      } else {
        print("Error: 'polls' is not a list or is empty.");
      }
    } else {
      print("Error: Response does not contain 'polls' key or is not a valid object.");
    }
  } else {
    // Log error if status code is not 200
    print('Error: ${response.statusCode}, Response: ${response.body}');
  }
} catch (e) {
  // Log any errors encountered during the request
  print('Error: $e');
}

}


  void _onOptionSelected(dynamic option) {
  if (option is Map<String, dynamic>) {
    setState(() {
      Map<String, String> selectedOption = {
        'text': option['text'] as String,
        'image': option['image'] as String,
        'option_id': option['id'] as String,

      };

      if (_selectedOptions.length > _currentPollIndex) {
        _selectedOptions[_currentPollIndex] = selectedOption;
      } else {
        _selectedOptions.add(selectedOption);
      }
    });
  } else {
    print("Option is not of expected type"); // Handle unexpected types
  }
}
 void _submitVote() async {
  await _playSound('buttonpressed.mp3');
  setState(() {
    if (_currentPollIndex < pollData[0]['questions'].length - 1) {
      // Check if no option has been selected for the current question
      if (_selectedOptions.isEmpty || 
          _selectedOptions.length <= _currentPollIndex ||
          _selectedOptions[_currentPollIndex].isEmpty) {
        
        // Select the middle option if it's not already selected
        final currentQuestion = pollData[0]['questions'][_currentPollIndex];
        if (currentQuestion['options'].isNotEmpty) {
          final middleOption = currentQuestion['options'][currentQuestion['options'].length ~/ 2]; // Get the middle option
          _onOptionSelected(middleOption);  // Select it automatically
        }
      }

      // Now move to the next poll question
      _currentPollIndex++;
      optionScrolled = false;
    } else {
      // If it's the last question, check if options are selected
      if (_selectedOptions.isNotEmpty) {
        _playSound('button_final.mp3');
        optionScrolled = false;

        // Update selectedOptionsProvider with selectedOptions if needed

        // Navigate to AnimationPage with selectedOptions
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AnimationPage(selectedOptions: _selectedOptions),
          ),
        );
      } else {
        print("No options selected"); // Handle case where no option is selected
      }
    }
  });
}


  Future<void> _playSound(String soundPath) async {
    try {
      await audioPlayer.stop(); // Stop any currently playing sound
      await audioPlayer.play(AssetSource(soundPath)); // Play the new sound
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void _vibrate() {
    Vibration.vibrate(duration: 100, amplitude: 128);
  }

  @override
  void dispose() {
    _pageController.dispose();
    audioPlayer.dispose();
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Voting Completed!'),
          content: const Text('Congrats, you have completed the voting!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Additional logic can be added here
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


 final List<Color> _colorList = [
    Color.fromARGB(255, 255, 135, 165), 
    Color.fromARGB(255, 255, 135, 251), 
    Color.fromARGB(255, 135, 255, 203), 
    Color.fromARGB(255, 255, 223, 135), 
    Color.fromARGB(255, 137, 218, 255), 
  ];

   @override
Widget build(BuildContext context) {
  if (pollData.isEmpty) {
    return Center(child: CircularProgressIndicator()); // Show loading indicator if pollData is empty
  }
  final currentQuestion = pollData[0]['questions'][_currentPollIndex];
   
  return Scaffold(
    appBar: AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the dots
        children: List.generate(
          pollData[0]['questions'].length, // Number of questions
          (index) {
            Color dotColor; // Define color for each dot
            if (_currentPollIndex > index) {
              dotColor = Colors.yellow[700]!; // Deep yellow for completed questions
            } else if (_currentPollIndex == index) {
              dotColor = const Color.fromARGB(255, 255, 249, 199); // Light yellow for current question
            } else {
              dotColor = Colors.grey; // Grey for upcoming questions
            }
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0), // Spacing between dots
              width: 12.0,
              height: 12.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor, // Set the color based on the index
              ),
            );
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Set the app bar color to black
      iconTheme: const IconThemeData(color: Colors.grey), // Grey icon color
    ),
      body: Container(
        color: const Color.fromARGB(255, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
  child: Stack(
    alignment: Alignment.center,
    children: [
      // Background dots image
     
      // Question box
      Container(
                  height: 140,
                  padding: const EdgeInsets.all(0.0),
                 decoration: BoxDecoration(
                color: _colorList[_currentPollIndex % _colorList.length], // Change color
                borderRadius: BorderRadius.circular(0),
              ),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0), // Inner gap of 5px
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 255, 230, 230), // Inner border color
                          width: 6, // Inner border width
                        ),
                        borderRadius: BorderRadius.circular(2.0), // Rounded corners for inner border
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Custom Grid Texture
                          CustomPaint(
                            size: Size(double.infinity, double.infinity), // Fill the entire container
                            painter: GridPainter(),
                          ),

                          // Centered Question Text
                          Center(
                            child: Text(
                              currentQuestion['question'],
                              style: GoogleFonts.playfairDisplay(
                                color: const Color.fromARGB(255, 0, 0, 0), // Luxury black
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          Positioned(
                            top: 0, // Adjust for vertical positioning
                            right: 5, // Adjust for horizontal positioning
                            child: SvgPicture.asset(
                              'assets/starsfinal.svg',
                              height: 40, // Size of the star icon
                              width: 40,
                            )
                          )
          
          
        ],
      ),
    ),
  ),
)


    ],
  ),
),
           Expanded(
  child: PageView.builder(
    itemCount: currentQuestion['options'].length,
    controller: _pageController,
     // Flag to track if the option has been scrolled or selected manually

onPageChanged: (index) {
  // Ensure the current question has options
  if (currentQuestion['options'].isNotEmpty) {

     setState(() {
      optionScrolled = true;  // User has scrolled to an option
    });
    // Set the selected option
    _onOptionSelected(currentQuestion['options'][index]);

    // Play sound and vibrate for feedback
    _playSound('tick_tock_sound.mp3');
    _vibrate();
    
    // Mark that the user has manually scrolled and selected an option
   
  } else {
    print("No options found for this poll."); // Handle as needed
  }
},
itemBuilder: (context, index) {
  final option = currentQuestion['options'][index];
  
  // Check if this option is selected
  final bool isSelected = _selectedOptions.isNotEmpty &&
      _selectedOptions.length > _currentPollIndex &&
      _selectedOptions[_currentPollIndex]['text'] == option['text'];

  final double blurValue = isSelected ? 0.0 : 10.0; // Less blur for the selected card

      return AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          double value = 1.0;
          // Ensure the controller has dimensions
          if (_pageController.position.haveDimensions) {
            value = (_pageController.page ?? 0) - index;
            value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
          }

          return Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              height: Curves.easeOut.transform(value) * 300,
              width: Curves.easeOut.transform(value) * 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(option['image']),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: isSelected ? const Color.fromARGB(255, 255, 255, 255) : Colors.transparent,
                            width: 2.0,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check_circle,
                                color: const Color.fromARGB(255, 14, 255, 187),
                                size: 40,
                              )
                            : null,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: isSelected ? 20 : 10,
                    child: Text(
                      option['text'],
                      style: const TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  ),
),


            Padding(
  padding: const EdgeInsets.fromLTRB(60.0, 20.0, 30.0, 70.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (_currentPollIndex == 0 && _selectedOptions.isEmpty & !optionScrolled)
        SizedBox(
          height: 50,
          child: Center( // Wrap with Center widget
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  '< SCROLL >',
                  style: const TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ),
          ),
        )
        else if (!optionScrolled)
        SizedBox(
          height: 50,
          child: Center( // Wrap with Center widget
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  '< SCROLL >',
                  style: const TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ),
          ),
        )
                  else if (_selectedOptions.isNotEmpty & optionScrolled )
                    Center(
                          child: NeoPopTiltedButton(
                            isFloating: true,
                            onTapUp: _submitVote,
                            decoration: const NeoPopTiltedButtonDecoration(
                              color: Color.fromARGB(255, 253, 236, 209),
                              plunkColor: Color.fromARGB(255, 255, 231, 196),
                              shadowColor: Color.fromRGBO(36, 36, 36, 1),
                              showShimmer: true,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 70.0,
                                vertical: 15,
                              ),
                              child: Text('Select'),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 17, 17, 17).withOpacity(0.2) // White grid lines with slight opacity for subtle effect
      ..strokeWidth = 1.0;

    double rowSpacing = 20.0; // Spacing between rows
    double colSpacing = 20.0; // Spacing between columns

    // Drawing vertical lines
    for (double x = 0; x < size.width; x += colSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Drawing horizontal lines
    for (double y = 0; y < size.height; y += rowSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // No need to repaint the grid lines
  }
}