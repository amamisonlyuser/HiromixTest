import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeaderboardPage extends StatefulWidget {
  final Map<int, List<List<Map<String, dynamic>>>> teamRankingsData;

  const LeaderboardPage({super.key, required this.teamRankingsData});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<int> _currentPageIndexes = []; // List to track current page index for each team
  late PageController _pageController;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeCurrentPageIndexes(); // Initialize the current page indexes
  }

  void _initializeCurrentPageIndexes() {
    _currentPageIndexes = List.generate(widget.teamRankingsData.length, (_) => 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

int _calculateTotalScore(List<Map<String, dynamic>> team) {
    return team.fold<int>(0, (total, member) {
      var score = member['option_score'];
      return total + (score is num ? score.toInt() : 0);
    });
  }

  Widget _buildMainPageView(List<List<Map<String, dynamic>>> teams, int rankIndex) {
    return Column(
      children: [
        Container(
          height: 220, // Reduced height
          width: 290, // Reduced width
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          child: PageView.builder(
            controller: _pageController,
            itemCount: teams.length, // Number of teams
            onPageChanged: (index) {
              setState(() {
                _currentPageIndexes[rankIndex] = index; // Update the current page index for the specific rank
              });
            },
            itemBuilder: (context, index) {
              return _buildTeamContainer(teams[index]);
            },
          ),
        ),
        const SizedBox(height: 8), // Space between PageView and dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(teams.length, (index) => _buildDot(index, rankIndex)),
        ),
      ],
    );
  }

  Widget _buildDot(int index, int rankIndex) {
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
        width: 8, // Reduced dot size
        height: 8, // Reduced dot size
        margin: const EdgeInsets.symmetric(horizontal: 4), // Reduced margin
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentPageIndexes[rankIndex] == index
              ? const Color.fromARGB(255, 255, 232, 26) // Yellow color for active page
              : const Color.fromARGB(255, 170, 170, 170), // Grey color for inactive pages
        ),
      ),
    );
  }

  Widget _buildTeamContainer(List<Map<String, dynamic>> team) {
    return Container(
      width: 290, // Reduced width
      height: 180, // Reduced height
      margin: const EdgeInsets.symmetric(vertical: 5), // Reduced margin between teams
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 170, 170, 170), width: 1),
        borderRadius: BorderRadius.circular(5),
        color: const Color.fromARGB(255, 0, 0, 0),
      ),
      child: Column(
        children: [
          const SizedBox(height: 5),
          Wrap(
            alignment: WrapAlignment.center, // Center items horizontally
            spacing: 10.0, // Reduced space between items horizontally
            runSpacing: 10.0, // Reduced space between items vertically
            children: team.map((member) {
              return _OptionBox(
                text: member['option_text'] ?? 'N/A', // Safety check for text
                image: member['option_image'] != null
                    ? AssetImage(member['option_image']!)
                    : const AssetImage('assets/default_image.png'), // Fallback image
                points: member['option_score']?.toString() ?? '?', // Display points
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Leaderboard',
          style: TextStyle(color: Color.fromARGB(255, 109, 109, 109)),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: widget.teamRankingsData.length,
        itemBuilder: (context, rankIndex) {
          int rank = widget.teamRankingsData.keys.toList()[rankIndex];
          List<List<Map<String, dynamic>>> teams = widget.teamRankingsData[rank]!;

          // Calculate total score for each team
          int totalScore = _calculateTotalScore(teams[0]); // Assuming you want the total score for the first team

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.black,
              elevation: 4.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          _getRankIcon(rank),
                          width: 70, // Reduced SVG size
                          height: 70, // Reduced SVG size
                        ),
                      ],
                    ),
                  ),
                  // Space between SVG and text
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Points: ',
                          style: TextStyle(
                            fontFamily: 'InriaSerif', // Font for 'Points'
                            fontSize: 18, // Reduced font size
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: '$totalScore',
                          style: TextStyle(
                            fontFamily: 'Digital-7', // Change this to your desired font for the score
                            fontSize: 18, // Reduced font size
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 21, 255, 220), // Adjust the color as needed
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6), // Reduced space below the points text
                  _buildMainPageView(teams, rankIndex),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getRankIcon(int rank) {
    switch (rank) {
      case 1:
        return 'assets/1st.svg'; // Path for 1st rank
      case 2:
        return 'assets/2nd.svg'; // Path for 2nd rank
      case 3:
        return 'assets/3rd.svg'; // Path for 3rd rank
      default:
        return 'assets/default.svg'; // Default icon for ranks beyond 3rd
    }
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
          backgroundImage: image,
          radius: 25, // Reduced CircleAvatar radius
        ),
        const SizedBox(height: 6), // Reduced space below CircleAvatar
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12, // Reduced font size
          ),
        ),
        Text(
          points,
          style: const TextStyle(
            color: Color.fromARGB(255, 21, 255, 220),
            fontSize: 14, // Reduced font size
            fontFamily: 'Digital-7',
          ),
        ),
      ],
    );
  }
}

// Method to parse leaderboard data
Map<int, List<List<Map<String, dynamic>>>> parseLeaderboardData(Map<String, dynamic> leaderboardData) {
  final teamRankings = leaderboardData['team_rankings'];

  Map<int, List<List<Map<String, dynamic>>>> parsedData = {};

  for (var ranking in teamRankings) {
    int rank = (ranking['rank'] as num).toInt();
    List<List<Map<String, dynamic>>> teams = List<List<Map<String, dynamic>>>.from(
      ranking['teams'].map<List<Map<String, dynamic>>>(
        (team) => List<Map<String, dynamic>>.from(
          team.map<Map<String, dynamic>>((member) => Map<String, dynamic>.from(member)),
        ),
      ),
    );
    parsedData[rank] = teams;
  }

  return parsedData;
}