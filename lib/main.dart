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
      home: const RootPage(),
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
  int _selectedIndex = 1; // Default to PollsPage
  late String phoneNumber;
  Map<String, dynamic> balances = {
    'totalBalance': {'amount': 0.0},
  };

  @override
  void initState() {
    super.initState();
    phoneNumber = widget.phoneNumber;
    _loadLastVisitedPage();  // Load the last visited page when the app starts
  }

  Future<void> _loadLastVisitedPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIndex = prefs.getInt('lastVisitedPage') ?? 1; // Default to PollsPage if nothing is saved
    });
  }

  Future<void> _saveLastVisitedPage(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastVisitedPage', index);
  }

  void _loadBalances() {
    setState(() {
      balances = {
        'totalBalance': {'amount': 100.0},
      };
    });
  }

  final List<IconData> _bottomNavBarIcons = [
    Icons.person,
    Icons.leaderboard,
    Icons.home,
    Icons.folder,
    Icons.wallet,
    Icons.attach_money,
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      ProfileTemplatePage(balances: balances),
      PollsPage(phoneNumber: phoneNumber, institution_short_name: "XIE"),
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
    _saveLastVisitedPage(index);  // Save the selected index when the user navigates
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
    await prefs.remove('lastVisitedPage'); // Clear saved page on logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RootPage()),
    );
  }
}
