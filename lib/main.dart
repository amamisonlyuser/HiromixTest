
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'send_otp_page.dart';
import 'HiromixAi.dart';
import 'Pollspage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import'RatingPollPage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
  final String phoneNumber = prefs.getString('phone_number') ?? "";
  
  runApp(MyApp(isAuthenticated: isAuthenticated, phone_number: phoneNumber));
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
  String event_poll_type = "None";
  bool showPollsTab = false;
  int _selectedIndex = 0;

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
        String pollType = bodyData['event_poll_type'] ?? 'None';

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('institution_short_name', institutionShortName);
        await prefs.setString('event_poll_type', pollType);

        setState(() {
          institution_short_name = institutionShortName;
          event_poll_type = pollType;

          // Show Poll tab if the event_poll_type is valid
          showPollsTab = event_poll_type == "Question_Poll" || event_poll_type == "Rating_Poll";

          _selectedIndex = (showPollsTab) ? 1 : 0;

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
        event_poll_type = 'None';
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
    // If there's no valid event poll type, show HiromixAIPage only
    if (!showPollsTab) {
      return const HiromixAIPage();
    }

    // Determine which poll page to show
    Widget pollPage;
    if (event_poll_type == "Question_Poll") {
      pollPage = PollsPage(phone_number: widget.phone_number, institution_short_name: institution_short_name);
    } else if (event_poll_type == "Rating_Poll") {
      pollPage = RatingPollPage(phone_number: widget.phone_number, institution_short_name: institution_short_name);
    } else {
      pollPage = const HiromixAIPage();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: _selectedIndex == 0 ? const HiromixAIPage() : pollPage,
      bottomNavigationBar: BottomAppBar(
        color: Colors.black.withOpacity(0.5),
        elevation: 0,
        child: SizedBox(
          height: 50, // Adjusted height for better UI
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.star, color: _selectedIndex == 0 ? Colors.white : Colors.grey),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.gamepad,
                  color: _selectedIndex == 1 ? Colors.white : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}