import 'package:flutter/material.dart';


class CustomScaffold extends StatelessWidget {
  final Widget body;
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomScaffold({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final List<IconData> bottomNavBarIcons = [
      Icons.person,  
      Icons.home,     // Profile
      Icons.wallet,       // Wallet
               // Home (PollsPage)
      Icons.attach_money  // Fantasy
    ];

    // Check if selectedIndex is within valid range
    int safeSelectedIndex = selectedIndex;
    if (safeSelectedIndex < 0 || safeSelectedIndex >= bottomNavBarIcons.length) {
      safeSelectedIndex = 0;  // Default to the first index if invalid
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        items: List.generate(
          bottomNavBarIcons.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(bottomNavBarIcons[index], color: const Color.fromARGB(255, 128, 128, 128)),
            label: index == 0
                ? 'Profile'
                : index == 1
                    ? 'Home'
                    : index == 2
                        ? 'Wallet'
                        : 'Fantasy',
          ),
        ),
        currentIndex: safeSelectedIndex,  // Use safeSelectedIndex
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: const Color.fromARGB(255, 189, 189, 189),
        unselectedItemColor: const Color.fromARGB(255, 65, 65, 65),
        onTap: onItemTapped,
      ),
    );
  }
}

