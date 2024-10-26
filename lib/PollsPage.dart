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
import 'GlobalData.dart';

class PollsPage extends StatefulWidget {
  final String phoneNumber;
  final Function(List<Map<String, String>> selectedOptions) onSelectionComplete;

  const PollsPage({
    super.key,
    required this.phoneNumber,
    required this.onSelectionComplete,
  });

  @override
  _PollsPageState createState() => _PollsPageState();
}

class _PollsPageState extends State<PollsPage> {
  int _currentPollIndex = 0;
  final List<Map<String, String>> _selectedOptions = [];
  late AudioPlayer audioPlayer; // Track the currently selected option ID
  late PageController _pageController;
  late ScrollController _scrollController; // Scroll controller

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
    GlobalData globalData = GlobalData();
    String? institutionShortName = globalData.getInstitutionShortName(); // Assuming this method exists
    String? phoneNumber = globalData.getPhoneNumber(); 
    // Define the JSON body
    final data = {
      "institution_short_name": institutionShortName,
      "phone_number": phoneNumber
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        setState(() {
          pollData = json.decode(response.body)['polls']; // Update pollData with fetched polls
        });
      } else {
        print('Error: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
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
    if (_selectedOptions.isNotEmpty) {
      // Play sound for regular button press
      await _playSound('buttonpressed.mp3');

      if (_currentPollIndex < pollData[0]['questions'].length - 1) {
        _currentPollIndex++;
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        _selectedOptions.isNotEmpty; // Reset for the next question
      } else {
        // Play final submission sound
        await _playSound('buttonfinal.mp3');

        // Update selectedOptionsProvider with selectedOptions

        // Navigate directly to AnimationPage with selectedOptions
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AnimationPage(selectedOptions: _selectedOptions),
          ),
        );
      }
    } else {
      print("No options selected"); // Handle case where no option is selected
    }
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
      backgroundColor: Colors.black, // Set the app bar color to black
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
      Positioned.fill(
        child: Image.asset(
          'assets/dots_black.png',
          fit: BoxFit.cover,
        ),
      ),
      // Question box
      Container(
        height: 140,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 250, 215, 155), // Sample color
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color.fromARGB(255, 15, 15, 15), width: 2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                currentQuestion['question'],
                style: GoogleFonts.blackHanSans(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Positioned stars icon
            Positioned(
              top: 5, // Adjust this value to move the image down
              right: 0, // Adjust this value to move the image to the right
              child: SvgPicture.asset(
                'assets/starsfinal.svg',
                height: 40, // Adjust the size as needed
                width: 40,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),
           Expanded(
  child: PageView.builder(
    itemCount: currentQuestion['options'].length,
    controller: _pageController,
    onPageChanged: (index) {
  // Ensure the current question has options
  if (currentQuestion['options'].isNotEmpty) {
    // Set the selected option
    _onOptionSelected(currentQuestion['options'][index]);

    // Play sound and vibrate for feedback
    _playSound('tick_tock_sound.mp3');
    _vibrate();
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
                                color: Color.fromARGB(255, 92, 231, 145),
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
      if (_currentPollIndex == 0 && _selectedOptions.isEmpty)
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
                  else if (_selectedOptions.isNotEmpty)
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