import 'package:flutter/material.dart';
import 'ActiveTradesPage.dart';
import 'HistoryPage.dart';
import 'main.dart';

class PortfolioHistoryPage extends StatefulWidget {
  const PortfolioHistoryPage({super.key});

  @override
  _PortfolioHistoryPageState createState() => _PortfolioHistoryPageState();
}

class _PortfolioHistoryPageState extends State<PortfolioHistoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToHomePage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage(phoneNumber: "1234567890")),
      );
    });
  }
 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      elevation: 0.0, // Set elevation to 0 to remove shadow
      bottom: TabBar(
        controller: _tabController,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.6),
        labelStyle: const TextStyle(fontSize: 17),
        indicatorColor: Colors.white, // Set the indicator color to white
        indicatorWeight: 2.0, // Set the indicator weight to 2.0
        tabs: const [
          Tab(text: 'Active Trades'),
          Tab(text: 'History'),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: _navigateToHomePage,
      ),
    ),
    body: TabBarView(
      controller: _tabController,
      children: const [
        ActiveTradesPage(),
        HistoryPage(),
      ],
    ),
  );
}
}
