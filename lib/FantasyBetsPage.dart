import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:neopop/neopop.dart'; // Ensure to import NeoPop package
import 'LeaderboardPage.dart';
import 'WalletTemplatePage.dart'; 
import 'ProfileTemplatePage.dart'; 
import 'PaymentSuccessPage.dart'; 
import 'dart:convert'; // For JSON encoding and decoding
import 'package:http/http.dart' as http;
import 'DummyResultsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shop.dart'; 

class FantasyBetsPage extends StatefulWidget {
  final List<Map<String, String>> selectedOptions;

  const FantasyBetsPage({super.key, required this.selectedOptions});

  @override
  _FantasyBetsPageState createState() => _FantasyBetsPageState();
}

class _FantasyBetsPageState extends State<FantasyBetsPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;
  late PageController _pageController;
  late PageController _teamController;
  int _currentPage = 0;
  bool _paymentSuccessful = false; 
  bool _resultsLive = false;
  Map<String, dynamic> _balances = {'totalBalance': {
    'amount': 0.0, // Ensure this is a double
  },}; // Track if results are live
  String _countdownText = '00:00:00';
  String? _errorMessage;
  Map<int, List<List<Map<String, dynamic>>>> _yourTeamRankingsData = {};
  bool _userWin = false;
  String? _userRank = '0';
 late AnimationController _animationController;
  bool _showLottieAnimation = false;
  int _currentImageIndex = 0;
  
  

  // Add this line in your state class
 // Each item in the list is a list of paragraphs (strings)
  // Image sequence and index
List<dynamic> _contentSequence = [

  'assets/1stwinners.png', 
  'assets/2ndwinners.png',  
  'assets/3rdwinners.png',  // Image
    // Lottie animation
   // Image
   // Lottie animation
    // Image
   // Lottie animation
];
  // Start the image sequence
  // Start the content sequence (image and Lottie animations)
  void _startContentSequence() {
    _playNextContent();
  }

    int _currentContentIndex = 0;

  // Play the next image in sequence
 /// Play the next content (image or animation) in sequence
 
 // Build the animation box to display images or Lottie animations in a sequence
  Widget _buildAnimationBox() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
  height: 225,
  width: 300,
  child: Center(
    child: _showLottieAnimation
        ? Lottie.asset(
            'assets/fire.json', // Replace with your Lottie animation path
            fit: BoxFit.cover,
            controller: _animationController,
            onLoaded: (composition) {
              _animationController.duration = composition.duration;
              _animationController.reset();
              _animationController.forward();
            },
          )
        : Transform.translate(
            offset: Offset(25, 0),  // Adjust this value to control the horizontal shift
            child: Image.asset(
              _contentSequence[_currentImageIndex],
              fit: BoxFit.cover,
            ),
          ),
  ),
),


        const SizedBox(height: 20),
        if (_resultsLive) ...[
          // Display 'Results Live' button if results are live
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Button background color (black)
              foregroundColor: const Color.fromARGB(255, 255, 255, 255), // Text color (white)
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
                side: const BorderSide(
                  color: Colors.white, // Border color
                  width: 1.0, // Border width
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding for the button
            ),
            onPressed: () {
              // Navigate to a dummy results page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DummyResultsPage(), // Replace with your results page
                ),
              );
            },
            child: const Text(
              'Results Live',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 255, 145), // Set the text color to green
              ),
            ),
          ),
        ] else if (_paymentSuccessful) ...[
          // Display 'Trade is live' button if payment is successful
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Button background color (black)
              foregroundColor: const Color.fromARGB(255, 29, 255, 153), // Text color (green)
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
                side: const BorderSide(
                  color: Colors.white, // Border color
                  width: 1.0, // Border width
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding for the button
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentSuccessPage(),
                ),
              );
            },
            child: const Text('Trade is live'),
          ),
        ] else ...[
         if (!_paymentSuccessful)
          NeoPopTiltedButton(
  isFloating: true,
  onTapUp: () {
    
   Navigator.push(
     context,
      MaterialPageRoute(builder: (context) => ShopPage()),
    );
  },
  decoration: const NeoPopTiltedButtonDecoration(
   color: Color.fromARGB(255, 253, 236, 209),
    plunkColor: Color.fromARGB(255, 255, 231, 196),
    shadowColor: Color.fromRGBO(36, 36, 36, 1),
    showShimmer: true,
  ),
  child: const Padding(
    padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 15),
   child: Text('splitwise'),
   ),
),
        ],
        if (_errorMessage != null) ...[
          const SizedBox(height: 20),
          Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ],
    );
  }
 void _playNextContent() {
    setState(() {
      // Update the index to display the next content
      _currentContentIndex = (_currentContentIndex + 1) % _contentSequence.length;
    });

    // Use a timer to control the duration each content is displayed
    Future.delayed(const Duration(seconds: 1), () {
      // Recursive call to play the next content
      _playNextContent();
    });
  }
  
 @override
void initState() {
  super.initState();
  // Start by showing the first image

  // Initialize AnimationController
   // Initialize the animation controller for fade
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));

 
// Timer to toggle between Lottie animation and image
  Timer.periodic(const Duration(milliseconds:2500 ), (timer) {
    setState(() {
      _showLottieAnimation = !_showLottieAnimation;
      if (!_showLottieAnimation) {
        _currentImageIndex = (_currentImageIndex + 1) % _contentSequence.length; // Loop through the images
      }
    });
  });

  _pageController = PageController();
  _teamController = PageController();
  

  // Start the animation sequence
  _animationController.forward(); 


  // Check if results are live and initialize the auto-scroll
  if (!_resultsLive) {
    _startPageAutoScroll();
  }

  // Fetch API data and perform additional setup
  _fetchApiData();
  _checkResultsAndFetchLeaderboard();
  _startContentSequence();

}

@override
void dispose() {
  // Properly dispose of all controllers and cancel any active timers
  _controller.dispose();
  _pageController.dispose();
  _teamController.dispose();
  _animationController.dispose();
  _timer?.cancel();
  super.dispose();
}




 // Start the image sequence
 



void _initializeCountdownTimer(DateTime endTime) {
  _timer?.cancel(); // Cancel any existing timer
  const duration = Duration(seconds: 1);
  
  _timer = Timer.periodic(duration, (timer) {
    final now = DateTime.now();
    final difference = endTime.difference(now);
    
    if (difference.isNegative) {
      _timer?.cancel();
      setState(() {
        _countdownText = 'Time\'s up!';
      });
    } else {
      setState(() {
        _countdownText = _formatDuration(difference);
      });
    }
  });
}

// Format duration to hours:minutes:seconds
String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String hours = twoDigits(duration.inHours);
  String minutes = twoDigits(duration.inMinutes.remainder(60));
  String seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$hours:$minutes:$seconds';
}

// Auto-scroll functionality for the pages
void _startPageAutoScroll() {
  if (_resultsLive) {
    // If results are live, jump directly to page 1
    _pageController.jumpToPage(1);
  } else {
    // Use a periodic timer to auto-scroll the pages
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < 2) {
        setState(() {
          _currentPage++;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        _timer?.cancel(); // Cancel the timer when the last page is reached
      }
    });
  }
}

 Future<void> _fetchApiData() async {
  try {
    // Retrieve the required values from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? institutionShortName = prefs.getString('institution_short_name');
    String? phoneNumber = prefs.getString('phone_number');
    String? pollId = prefs.getString('poll_id');

    // Check if any required value is missing
    if (institutionShortName == null || phoneNumber == null || pollId == null) {
      print('Error: Missing required data from SharedPreferences');
      // Log which values are missing
      if (institutionShortName == null) print('Missing institution_short_name');
      if (phoneNumber == null) print('Missing phone_number');
      if (pollId == null) print('Missing poll_id');
      return;
    }

    // Prepare the request body with values from SharedPreferences
    final body = jsonEncode({
      'institution_short_name': institutionShortName,
      'phone_number': phoneNumber,
      'poll_id': pollId,
    });

    const url = 'https://innqn6dwv1.execute-api.ap-south-1.amazonaws.com/prod/User/GetRank';

    // Make the API request
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('Response body: ${response.body}'); // Log the response for debugging
    print('Request body: $body'); // Log the request body for debugging

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); // Decode the main response body

      if (data['body'] != null) {
        // The 'body' field contains a string that needs to be decoded again into JSON
        final responseBody = jsonDecode(data['body']); // Decode 'body' into Map<String, dynamic>

        if (responseBody is Map<String, dynamic>) {
          // Extract values from responseBody
          bool resultsLive = responseBody['Results_live'] ?? false;
          String endTimeString = responseBody['end_time'] ?? '';
          Map<String, dynamic> balances = responseBody['balances'] ?? {};

          // Check for Active_trades status
          bool activeTrades = responseBody['Active_trades'] ?? false;

          // Set _paymentSuccessful based on Active_trades
          bool _paymentSuccessful = activeTrades;

          // Optional: Extract nested balances if needed
          

          // Update the UI using setState and perform further logic
          setState(() {
            _resultsLive = resultsLive;
            _balances = balances;

            // Handle countdown if results are not live
            if (!resultsLive && endTimeString.isNotEmpty) {
              DateTime endTime = DateTime.parse(endTimeString);
              _initializeCountdownTimer(endTime);
            }

            // Handle page navigation after 5 seconds if results are live
            if (_resultsLive) {
              Future.delayed(const Duration(seconds: 5), () {
                _pageController.jumpToPage(1); // Jump to page 1 directly
              });
            }
          });

          // Optionally log or handle _paymentSuccessful if needed
          print('_paymentSuccessful is set to: $_paymentSuccessful');
        } else {
          print('Error: Expected a Map<String, dynamic> for responseBody');
        }
      } else {
        print('Error: Body is null');
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (error) {
    print('Error making API request: $error');
  }
}

 // This function will check if results are live and fetch leaderboard data if they are
Future<void> _checkResultsAndFetchLeaderboard() async {
  try {
    // Retrieve the required values from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? institutionShortName = prefs.getString('institution_short_name');
    String? phoneNumber = prefs.getString('phone_number');
    String? pollId = prefs.getString('poll_id');

    // Check if any required value is missing
    if (institutionShortName == null || phoneNumber == null || pollId == null) {
      print('Error: Missing required data from SharedPreferences');
      // Log which values are missing
      if (institutionShortName == null) print('Missing institution_short_name');
      if (phoneNumber == null) print('Missing phone_number');
      if (pollId == null) print('Missing poll_id');
      return;
    }

    // Define the payload for the POST request
    final Map<String, dynamic> payload = {
      "institution_short_name": institutionShortName,
      "phone_number": phoneNumber,
      "poll_id": pollId,
    };

    // Make the API request
    final response = await http.post(
      Uri.parse('https://innqn6dwv1.execute-api.ap-south-1.amazonaws.com/prod/User/leaderboard'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      // Decode the response body
      final decodedResponse = json.decode(response.body);

      // Decode the response body which is a JSON string
      final leaderboardData = json.decode(decodedResponse['body']);

      // Check if 'leaderboardData' is valid and not a String or null
      if (leaderboardData != null && leaderboardData is! String) {
        // Parse the leaderboard data if it's not a String or null
        setState(() {
          _yourTeamRankingsData = parseLeaderboardData(leaderboardData);
        });
      } else {
        // Handle the case where data is invalid (either a String or null)
        setState(() {
          _yourTeamRankingsData = {}; // or some default/empty data structure
        });
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    setState(() {
      _errorMessage = 'An error occurred: $e';
    });
    print('Exception: $e');
  }
}

 // Function to handle payment page navigation
void _paymentPage(BuildContext context) async {
  try {
    // Retrieve the required values from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? institutionShortName = prefs.getString('institution_short_name');
    String? phoneNumber = prefs.getString('phone_number');
    String? pollId = prefs.getString('poll_id');

    // Check if any required value is missing
    if (institutionShortName == null || phoneNumber == null || pollId == null) {
      print('Error: Missing required data from SharedPreferences');
      // Log which values are missing
      if (institutionShortName == null) print('Missing institution_short_name');
      if (phoneNumber == null) print('Missing phone_number');
      if (pollId == null) print('Missing poll_id');
      return;
    }

    // Define the payload for the POST request
    final Map<String, dynamic> payload = {
      "institution_short_name": institutionShortName,
      "phone_number": phoneNumber,
      "poll_id": pollId,
      "User_Amount": "250" // You can adjust this value based on your requirement
    };

    // Make the POST request
    final response = await http.post(
      Uri.parse('https://innqn6dwv1.execute-api.ap-south-1.amazonaws.com/prod/User/Payment'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    // Check if the status code is 200 to determine success
    if (response.statusCode == 200) {
      // If status code is 200, set _paymentSuccessful to true and navigate to PaymentSuccessPage
      setState(() {
        _paymentSuccessful = true;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PaymentSuccessPage(),
        ),
      );
    } else {
      // If the status code is not 200, display error on the screen
      setState(() {
        _paymentSuccessful = false;
        _errorMessage = 'Payment failed. Please try again.';
      });
    }
  } catch (e) {
    // Handle any errors during the request
    setState(() {
      _paymentSuccessful = false;
      _errorMessage = 'Error: $e';
    });
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      
      title: const Text(
        'Fantasy Zone',
        style: TextStyle(color: Color.fromARGB(255, 135, 135, 135)),
      ),
      actions: [
      IconButton(
  iconSize: 30.0,
  icon: const Icon(Icons.account_circle, color: Colors.white),
  onPressed: () {
    // Pass the entire balances map
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileTemplatePage(balances: _balances), // Pass the entire balances map
      ),
    );
  },
),

IconButton(
  iconSize: 30.0,
  icon: const Icon(Icons.account_balance_wallet, color: Colors.white),
  onPressed: () {
    // Pass the entire balances map
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WalletTemplatePage(balances: _balances), // Pass the entire balances map
      ),
    );
  },
),

        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/dots.png'),
                  fit: BoxFit.cover,
                  repeat: ImageRepeat.repeatY,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  _buildAnimationBox(),
                  const SizedBox(height: 20),
                  _buildMainPageView(),
                  const SizedBox(height: 20),
                  _buildNeoPopPlayButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

int _currentPageIndex = 0; // Add this state variable to track the current page

// Updated method to build the main PageView with navigation dots
Widget _buildMainPageView() {
  return Column(
    children: [
      Container(
        height: 230,
        width: 310,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index; // Update the current page index when the page changes
            });
          },
          children: [
            _buildTeamContainer(),
            _buildScoreBox(),
            _buildCountdownBox(),
          ],
        ),
      ),
      const SizedBox(height: 10), // Space between PageView and dots
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDot(0),
          const SizedBox(width: 10), // Space between dots
          _buildDot(1),
          const SizedBox(width: 10),
          _buildDot(2),
        ],
      ),
    ],
  );
}
// Widget to build each dot
Widget _buildDot(int index) {
  return GestureDetector(
    onTap: () {
      // Set the page manually when user taps on the dot
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    },
    child: Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPageIndex == index
            ? const Color.fromARGB(255, 255, 232, 26) // Yellow color for active page
            : const Color.fromARGB(255, 170, 170, 170), // Grey color for inactive pages
      ),
    ),
  );
}




  Widget _buildCountdownBox() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color.fromARGB(255, 0, 0, 0),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'R e s u l t s   i n:',
            style: TextStyle(
              fontFamily: 'Digital-7',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _countdownText,  // Use the countdown text here
            style: const TextStyle(
              fontFamily: 'Digital-7',
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 232, 26),
              shadows: [
                Shadow(blurRadius: 3.0, color: Color(0xFFFFF5E8), offset: Offset(0, 0)),
                Shadow(blurRadius: 6.0, color: Color(0xFFE0C9B5), offset: Offset(0, 0)),
                Shadow(blurRadius: 10.0, color: Color(0xFF9A634A), offset: Offset(0, 0)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBox() {
  // Determine the user rank value based on whether the results are live
  String userRank = _resultsLive ? _userRank.toString() : '?'; // Assuming _userRank holds the user's rank value

  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: const Color.fromARGB(255, 0, 0, 0),
      border: Border.all(color: Colors.white, width: 1),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'T e a m   R a n k',
          style: TextStyle(
            fontFamily: 'Digital-7',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            userRank, // Use the determined user rank here
            style: const TextStyle(
              fontFamily: 'Digital-7',
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 232, 26),
              shadows: [
                Shadow(blurRadius: 3.0, color: Color(0xFFFFF5E8), offset: Offset(0, 0)),
                Shadow(blurRadius: 6.0, color: Color(0xFFE0C9B5), offset: Offset(0, 0)),
                Shadow(blurRadius: 10.0, color: Color(0xFF9A634A), offset: Offset(0, 0)),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}



 // Team container displaying user's selected team with PageView
Widget _buildTeamContainer() {
  return Container(
    width: 310,
    height: 190,
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 1),
      borderRadius: BorderRadius.circular(5),
      color: const Color.fromARGB(255, 0, 0, 0),
    ),
    child: PageView.builder(
      controller: _teamController, // Controller for page scrolling
      itemCount: (widget.selectedOptions.length + 4) ~/ 5, // Correct page count logic
      itemBuilder: (context, pageIndex) {
        int startIndex = pageIndex * 5;
        int endIndex = (startIndex + 5 <= widget.selectedOptions.length)
            ? startIndex + 5
            : widget.selectedOptions.length;

        // Handle potential empty page scenario
        if (startIndex >= widget.selectedOptions.length) {
          return Center(
            child: const Text(
              "No Options",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
        }

        // Returning team display for the page
        return Container(
          padding: const EdgeInsets.all(10), // Padding inside container
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color.fromARGB(255, 170, 170, 170),
              width: 1,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                const Text(
                  'Y o u r   T e a m',
                  style: TextStyle(
                    fontFamily: 'Digital-7',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                Wrap(
                  alignment: WrapAlignment.center, // Center items horizontally
                  spacing: 15.0, // Space between items horizontally
                  runSpacing: 20.0, // Space between items vertically
                  children: widget.selectedOptions
                      .sublist(startIndex, endIndex)
                      .map((option) => _OptionBox(
                            text: option['text'] ?? 'N/A', // Safety check for text
                            image: option['image'] != null
                                ? AssetImage(option['image']!)
                                : const AssetImage('assets/default_image.png'), // Fallback image
                            points: '?', // Default points display
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}


Widget _buildNeoPopPlayButton() {
  if (!_resultsLive) {
    // If results are not live, return an empty container or any other widget you prefer
    return SizedBox.shrink(); // This creates a widget with no size
  }

  return SizedBox(
    width: 150, // Adjust the width as needed
    child: NeoPopButton(
      color: const Color.fromARGB(255, 77, 158, 150), // Replace with your color
      bottomShadowColor: const Color.fromARGB(255, 0, 100, 80), // Replace with your color
      rightShadowColor: const Color.fromARGB(255, 0, 200, 83), // Replace with your color
      animationDuration: const Duration(milliseconds: 300),
      depth: 8.0,
      onTapUp: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LeaderboardPage(
              teamRankingsData: _yourTeamRankingsData// Pass the actual data here
            ),
          ),
        );
      },
      border: Border.all(
        color: const Color.fromARGB(255, 0, 200, 83), // Replace with your color
        width: 2.0,
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Leaderboard", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    ),
  );
}

  // Animation box displaying the sequence of animations and NeoPop button
  // Animation box displaying the sequence of animations and conditional button


Widget _build3DText(List<String> paragraphs) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: paragraphs.map((paragraph) {
      return Stack(
        children: [
          // Shadow behind the main text to create a 3D effect
          Positioned(
            top: 2.0,
            left: 2.0,
            child: Text(
              paragraph,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey, // Shadow color
              ),
            ),
          ),
          // Main text
          Text(
            paragraph,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent, // Main color of the text
              shadows: [
                Shadow(
                  blurRadius: 4.0,
                  color: Colors.black38,
                  offset: Offset(2.0, 2.0), // Position of the shadow
                ),
              ],
            ),
          ),
        ],
      );
    }).toList(),
  );
}


}



// Reusable widget for displaying an option with an image and text
class _OptionBox extends StatelessWidget {
  final String text;
  final AssetImage image;
  final String points;

  const _OptionBox({required this.text, required this.image, required this.points});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: image,
          radius: 20,
        ),
        const SizedBox(height: 3),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

