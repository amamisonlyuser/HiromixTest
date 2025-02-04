import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PollsPage.dart';
import 'ProfileTemplatePage.dart';
import 'WalletTemplatePage.dart';
import 'custom_navigator.dart';
import 'send_otp_page.dart';
import 'GlobalData.dart';
import 'verify_otp_page.dart';
import 'errorpage.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// Add these to pubspec.yaml:
// dependencies:
//   go_router: ^13.0.0
//   flutter_web_plugins: 
//     sdk: flutter

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalData()),
      ],
      child: const MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.grey,
        ).copyWith(secondary: Colors.white),
        useMaterial3: true,
        textTheme: const TextTheme().apply(fontFamily: 'InriaSerif'),
      ),
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Numeric pattern route (must come first)
    GoRoute(
      path: '/:phoneNumber([0-9]+)/:otp([0-9]+)',
      pageBuilder: (context, state) {
        final phoneNumber = state.pathParameters['phoneNumber']!;
        final otp = state.pathParameters['otp']!;
        return MaterialPage(
          key: state.pageKey,
          child: VerifyOtpPage(phoneNumber: phoneNumber, otp: otp),
        );
      },
    ),
    // Root page and other routes
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const RootPage(),
      ),
      routes: [
        GoRoute(
          path: 'home',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const MyHomePageWrapper(),
          ),
        ),
        GoRoute(
          path: 'sendOtp',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const SendOtpPage(),
          ),
        ),
      ],
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) async {
    final prefs = await SharedPreferences.getInstance();
    final isAuthenticated = prefs.getBool('isAuthenticated') ?? false;

    // Check if we're already on a valid numeric route
    if (state.matchedLocation.contains('/${state.pathParameters['phoneNumber']}/${state.pathParameters['otp']}')) {
      return null; // Allow numeric pattern route to handle
    }

   // Handle redirect logic
    if (state.uri.path == '/') {
      return isAuthenticated ? '/home' : '/sendOtp';
    }

    return null;
  },
);

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
    final prefs = await SharedPreferences.getInstance();
    final isAuthenticated = prefs.getBool('isAuthenticated') ?? false;

    if (isAuthenticated) {
      context.go('/home');
    } else {
      context.go('/sendOtp');
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

class MyHomePageWrapper extends StatelessWidget {
  const MyHomePageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = Provider.of<SharedPreferences>(context);
    final phoneNumber = prefs.getString('phoneNumber') ?? "1234567890";
    return MyHomePage(phoneNumber: phoneNumber);
  }
}

class MyHomePage extends StatefulWidget {
  final String phoneNumber;

  const MyHomePage({super.key, required this.phoneNumber});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;
  late String phoneNumber;
  Map<String, dynamic> balances = {'totalBalance': {'amount': 0.0}};

  @override
  void initState() {
    super.initState();
    phoneNumber = widget.phoneNumber;
    _loadLastVisitedPage();
  }

  Future<void> _loadLastVisitedPage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIndex = prefs.getInt('lastVisitedPage') ?? 1;
    });
  }

  Future<void> _saveLastVisitedPage(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastVisitedPage', index);
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    _saveLastVisitedPage(index);
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
    await prefs.remove('lastVisitedPage');
    context.go('/');
  }

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
}