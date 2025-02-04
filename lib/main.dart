import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PollsPage.dart';
import 'ProfileTemplatePage.dart';
import 'WalletTemplatePage.dart';
import 'custom_navigator.dart';
import 'send_otp_page.dart';
import 'GlobalData.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalData()),
        // Add other providers as needed
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.grey,
        ).copyWith(secondary: Colors.white),
        useMaterial3: true,
        textTheme: const TextTheme().apply(fontFamily: 'InriaSerif'),
      ),
      home: const RootPage(), // Use RootPage to check auth status
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthenticationStatus();
  }

  void _checkAuthenticationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isAuthenticated = prefs.getBool('isAuthenticated') ?? false;

    if (isAuthenticated) {
      String phoneNumber = prefs.getString('phoneNumber') ?? "1234567890";
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(phoneNumber: phoneNumber)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SendOtpPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String phoneNumber;

  const MyHomePage({super.key, required this.phoneNumber});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1; // Set PollsPage as the initial index
  late String phoneNumber;
  Map<String, dynamic> balances = {
    'totalBalance': {'amount': 0.0}, // Default value for initialization
  };

  @override
  void initState() {
    super.initState();
    phoneNumber = widget.phoneNumber;
  }

  void _loadBalances() {
    // Fetch balances from a service or database if needed
    setState(() {
      balances = {
        'totalBalance': {'amount': 100.0}, // Replace with actual fetch logic
      };
    });
  }

  final List<IconData> _bottomNavBarIcons = [
    Icons.person,
    Icons.leaderboard,
    Icons.home,
    Icons.folder,
    Icons.wallet,
    Icons.attach_money // Icon for Fantasy Bets Page
  ];





  @override
  Widget build(BuildContext context) {

    final List<Widget> pages = <Widget>[
      ProfileTemplatePage(balances: balances),
      PollsPage(
        phoneNumber: phoneNumber,
        institution_short_name:"XIE", 
      ),
      WalletTemplatePage(balances: balances),
      
    ];

    return CustomScaffold(
      body: pages[_selectedIndex],
      selectedIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RootPage()),
    );
  }
}
