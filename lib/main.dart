import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PortfolioHistoryPage.dart';

import 'PollsPage.dart';
import 'ProfileTemplatePage.dart';
import 'WalletTemplatePage.dart';
import 'FantasyBetsPage.dart';
import 'custom_navigator.dart';
import 'send_otp_page.dart';
import 'SelectedOptionsProvider.dart';
import 'GlobalData.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalData()),
        ChangeNotifierProvider(create: (_) => SelectedOptionsProvider()), // Add SelectedOptionsProvider here
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

        // Hardcode the entire text theme to use Inria Serif
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'InriaSerif', // Set Inria Serif globally
          ),
          bodyMedium: TextStyle(
            fontFamily: 'InriaSerif',
          ),
          bodySmall: TextStyle(
            fontFamily: 'InriaSerif',
          ),
          displayLarge: TextStyle(
            fontFamily: 'InriaSerif',
          ),
          displayMedium: TextStyle(
            fontFamily: 'InriaSerif',
          ),
          displaySmall: TextStyle(
            fontFamily: 'InriaSerif',
          ),
          headlineLarge: TextStyle(
            fontFamily: 'InriaSerif',
          ),
          headlineMedium: TextStyle(
            fontFamily: 'InriaSerif',
          ),
          headlineSmall: TextStyle(
            fontFamily: 'InriaSerif',
          ),
          titleLarge: TextStyle(
            fontFamily: 'InriaSerif',
          ),
          titleMedium: TextStyle(
            fontFamily: 'InriaSerif',
          ),
          titleSmall: TextStyle(
            fontFamily: 'InriaSerif',
          ),
          labelLarge: TextStyle(
            fontFamily: 'InriaSerif',
          ),
          labelMedium: TextStyle(
            fontFamily: 'InriaSerif',
          ),
          labelSmall: TextStyle(
            fontFamily: 'InriaSerif',
          ),
        ),
      ),
      home: const RootPage(), // Define your home page here
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
  int _selectedIndex = 2; // Set Home Page as the default page
  late String phoneNumber;

  @override
  void initState() {
    super.initState();
    phoneNumber = widget.phoneNumber;
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
    final selectedOptionsProvider = Provider.of<SelectedOptionsProvider>(context);
   // Initialize as an empty map or with default values
Map<String, dynamic> balances = {
  'totalBalance': {
    'amount': 0.0, // Ensure this is a double
  },
  // Add other balances here if needed
};

// Ensure the pages accept the entire balances map
final List<Widget> pages = <Widget>[
  ProfileTemplatePage(balances: balances), // Pass the entire balances map
  
  PollsPage(
    phoneNumber: phoneNumber,
    onSelectionComplete: (options) {
      selectedOptionsProvider.updateSelectedOptions(options);
    },
  ),
  const PortfolioHistoryPage(),
  WalletTemplatePage(balances: balances), // Pass the entire balances map
  FantasyBetsPage(selectedOptions: selectedOptionsProvider.selectedOptions),
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