
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'send_otp_page.dart';
import 'HiromixAi.dart';
import 'Pollspage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
  final String phone_number = prefs.getString('phone_number') ?? "";
  
  runApp(MyApp(isAuthenticated: isAuthenticated, phone_number: phone_number));
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  final String phone_number;

  const MyApp({super.key, required this.isAuthenticated, required this.phone_number});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isAuthenticated ? HomePage(phone_number: phone_number) : const SendOtpPage(),
    );
  }
}



class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.phone_number});
  final String phone_number;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String institution_short_name = "None";
  bool showPollsTab = false;
  int _selectedIndex = 0;
  bool Poll_live = false; 

  @override
  void initState() {
    super.initState();
    _fetchInstitutionShortName();
  }

  void _fetchInstitutionShortName() async {
    try {
      final response = await http.post(
        Uri.parse('https://innqn6dwv1.execute-api.ap-south-1.amazonaws.com/prod/User/HomePage'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "phone_number": widget.phone_number,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final bodyData = json.decode(responseData['body']);
        String institutionShortName = bodyData['institution_short_name'] ?? 'None';
        bool pollLive = bodyData['Poll_live'] ?? false;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('institution_short_name', institutionShortName);

        setState(() {
          institution_short_name = institutionShortName;
          Poll_live = pollLive;

          // Show navigation bar only if institutionShortName is valid
          showPollsTab = institutionShortName.isNotEmpty && institutionShortName != "None";
          _selectedIndex = (showPollsTab && pollLive) ? 1 : 0; 

          // Only initialize _tabController if showPollsTab is true
          if (showPollsTab) {
            _tabController = TabController(
              length: 2,
              vsync: this,
              initialIndex: _selectedIndex,
            );
          }

          
        });

        print('Response: ${response.body}');
      } else {
        print('Failed to fetch institution name: ${response.body}');
      }
    } catch (e) {
      setState(() {
        institution_short_name = 'Error: $e';
        Poll_live = false;
        showPollsTab = false;
        _selectedIndex = 0;
        
      });
      print('Error occurred: $e');
    }
  }

  @override
  void dispose() {
    if (showPollsTab) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while fetching data
    

    // If institution_short_name is "None", directly show HiromixAIPage without bottom navigation
    if (!showPollsTab) {
      return const HiromixAIPage();
    }

    // Show bottom navigation if institution_short_name is valid
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isAuthenticated', false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SendOtpPage()),
              );
            },
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? const HiromixAIPage()
          : PollsPage(phone_number: widget.phone_number, institution_short_name: institution_short_name),
      
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "AI",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: "Play",
          ),
        ],
      ),
    );
  }
}
