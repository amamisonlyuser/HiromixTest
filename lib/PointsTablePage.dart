import 'dart:async';
import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PointsTablePage extends StatefulWidget {
  final List<Map<String, String>> selectedOptions;

  const PointsTablePage({
    super.key,
    required this.selectedOptions,
  });

  @override
  _PointsTablePageState createState() => _PointsTablePageState();
}

class _PointsTablePageState extends State<PointsTablePage> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  // List to hold user data from API
  List<Map<String, String>> users = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    // Start the auto-scroll for the PageView
    _startPageAutoScroll();

    // Fetch leaderboard data from the API
    _fetchLeaderboardData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // Function to automatically scroll pages every 3 seconds
  void _startPageAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentPage = (_currentPage + 1) % 3; // Update page index
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  // Function to fetch leaderboard data from the API
  Future<void> _fetchLeaderboardData() async {
  final url = Uri.parse('https://innqn6dwv1.execute-api.ap-south-1.amazonaws.com/prod/User/leaderboard');
  final body = jsonEncode({
    "institution_short_name": "XIE",
    "poll_id": "7e7355d5-fc85-478e-a8f1-9f6f65da7c48"
  });

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      final data = jsonDecode(response.body);

      // Extract the options_data array from the response body
      final List<dynamic> optionsData = jsonDecode(data['body'])['options_data'];

      // Create a new users list from the options data
      List<Map<String, String>> fetchedUsers = [];

      for (var optionsGroup in optionsData) {
        for (var option in optionsGroup['options']) {
          fetchedUsers.add({
            'name': option['text'],
            'points': option['score'].toString(),
            'image': option['image'],  // Assuming image paths are returned as in assets folder
          });
        }
      }

      // Update the state with the new leaderboard data
      setState(() {
        users = fetchedUsers;
      });
    } else {
      print('Failed to fetch leaderboard data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    // Display a loading indicator while fetching data
    if (users.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    // Once the data is fetched, build the list
    return Column(
      children: users.map((user) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(4.0),
            boxShadow: [
              BoxShadow(
                color: Colors.white, // White glow border
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 0), // Shadow position
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(user['image']!),
            ),
            title: Text(
              user['name']!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  user['points']!,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Points',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _OptionBox extends StatelessWidget {
  final String text;
  final AssetImage image;
  final String points;

  const _OptionBox({
    required this.text,
    required this.image,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          backgroundImage: image,
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        Text(
          'Points $points',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
