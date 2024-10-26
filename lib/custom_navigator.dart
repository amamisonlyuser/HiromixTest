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
      Icons.leaderboard,
      Icons.home,
      Icons.folder,
      Icons.wallet,
      Icons.attach_money
    ];

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
                    ? 'Activity'
                    : index == 2
                        ? 'Home'
                        : index == 3
                            ? 'Portfolio'
                            : index == 4
                                ? 'Wallet'
                                : 'Fantasy',
          ),
        ),
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: const Color.fromARGB(255, 189, 189, 189),
        unselectedItemColor: const Color.fromARGB(255, 65, 65, 65),
        onTap: onItemTapped,
      ),
    );
  }
}
