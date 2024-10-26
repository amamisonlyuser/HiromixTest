import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'send_otp_page.dart'; // Import your SendOtpPage here for navigation
import 'package:neopop/neopop.dart';

class ProfileTemplatePage extends StatelessWidget {
  final Map<String, dynamic> balances; // Change to Map<String, dynamic>

  const ProfileTemplatePage({super.key, required this.balances});

  @override
  Widget build(BuildContext context) {
    // Extract totalAmount from balances
    final totalAmount = balances['Total_balance']['amount'].toString(); // Get the amount as a string

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
        title: const Text('Profile', style: TextStyle(color: Color.fromARGB(255, 157, 157, 157))),
        actions: [
          IconButton(
            iconSize: 30.0,
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileTemplatePage(balances: balances), // Pass balances here
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(flex: 2),
            const Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Divider(
              color: Colors.white,
              thickness: 1,
            ),
            const SizedBox(height: 20),

            // Dynamic Amount Section with balances
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹$totalAmount', // Use the total amount here
                      style: const TextStyle(
                        fontSize: 35, // Change font size for visibility
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      'Total Balance',
                      style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 160, 160, 160)),
                    ),
                  ],
                ),
                const DepositButton(), // Keep the Deposit button as is
              ],
            ),

            const SizedBox(height: 20),
            _buildListTile('Help and Support'),
            _buildListTile('Terms and Conditions'),
            _buildListTile('Delete Account'),
            _buildListTile('Rate us!'),
            const Spacer(flex: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.instagram, color: Colors.white, size: 40),
                  onPressed: () {
                    // Handle Instagram action
                  },
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.twitter, color: Colors.white, size: 40),
                  onPressed: () {
                    // Handle Twitter action
                  },
                ),
              ],
            ),
            const Spacer(flex: 2),
            GestureDetector(
              onTap: () {
                // Logout logic
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SendOtpPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Logout',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class DepositButton extends StatelessWidget {
  const DepositButton({super.key});

  @override
  Widget build(BuildContext context) {
    return NeoPopTiltedButton(
      isFloating: true,
      decoration: const NeoPopTiltedButtonDecoration(
        color: Color.fromARGB(255, 12, 12, 12), // Button color (light brown in this example)
        plunkColor: Color.fromARGB(255, 22, 22, 22), // Secondary color (light gray in this example)
        shadowColor: Color.fromARGB(255, 68, 68, 68), // Shadow color (standard gray)
        showShimmer: true,
      ),
      onTapUp: () {
        // Handle onTap action here
        print('Deposit button tapped');
        // Add your logic for what should happen when the button is tapped
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15), // Adjust padding as needed
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Deposit', // Text label for the button
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255), // Text color (white in this example)
                fontSize: 16, // Text size
                fontWeight: FontWeight.bold, // Text weight
              ),
            ),
            SizedBox(width: 12), // Add space between text and icon
            Icon(
              Icons.circle,
              size: 12,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ],
        ),
      ),
    );
  }
}
