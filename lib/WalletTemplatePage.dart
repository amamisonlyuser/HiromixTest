import 'package:flutter/material.dart';
import 'package:neopop/neopop.dart';

class WalletTemplatePage extends StatelessWidget {
  final Map<String, dynamic> balances;  // Change to Map<String, dynamic>

  const WalletTemplatePage({super.key, required this.balances});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Wallet', style: TextStyle(color: Color.fromARGB(255, 132, 132, 132))),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kToolbarHeight - 20),
            AmountSection(totalAmount: balances['Total_balance']['amount'].toString()), // Ensure this is a string
            const SizedBox(height: 20),
            BalanceSection(balance: balances['Cash_balance']['amount'].toString()), // Ensure this is a string
            const SizedBox(height: 20),
            RewardSection(reward: balances['Rewards']['amount'].toString()), // Ensure this is a string
            const SizedBox(height: 20),
            TransactionHistorySection(),
          ],
        ),
      ),
    );
  }
}




class AmountSection extends StatelessWidget {
  final String totalAmount; // Add this line to accept the total amount

  const AmountSection({super.key, required this.totalAmount}); // Update constructor

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '₹$totalAmount', // Use the total amount here
                style: const TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 0),
              const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Total Amount',
                  style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 163, 163, 163)),
                ),
              ),
            ],
          ),
          const DepositButton(),
        ],
      ),
    );
  }
}




class BalanceSection extends StatelessWidget {
  final String balance;

  // Remove the `const` keyword here
  const BalanceSection({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      height: 110,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 50, 50, 50), Color.fromARGB(255, 19, 19, 19)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: Color.fromARGB(255, 69, 228, 122),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Balance',
                      style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                // Use the passed balance variable
                Text(
                  '₹$balance', // Use the balance variable directly
                  style: TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 140,
            child: ElevatedButton(
              onPressed: () {
                // Handle cash out action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(
                  color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
                  width: 1,
                ),
                shadowColor: Colors.transparent,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Cash out',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 47, 236, 164),
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.circle,
                    size: 12,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class RewardSection extends StatelessWidget {
  final String reward; // Add this line to accept the reward amount

  const RewardSection({super.key, required this.reward}); // Update constructor

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      height: 80,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 50, 50, 50), Color.fromARGB(255, 19, 19, 19)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.card_giftcard,
                    color: Color.fromARGB(255, 255, 159, 159),
                  ),
                  SizedBox(width: 10),
                  const Text(
                    'Rewards',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              // Update to show the dynamic reward
              Text(
                '₹$reward', // Use the reward amount here
                style: const TextStyle(
                  fontSize: 24,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 143,
            child: ElevatedButton(
              onPressed: () {
                // Handle earn more action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                side: BorderSide(
                  color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
                  width: 1,
                ),
                shadowColor: Colors.transparent,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Get more',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.circle,
                    size: 12,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionHistorySection extends StatelessWidget {
  const TransactionHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 20.0), // Add top padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                'See transaction history',
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward,
            color: Colors.white,
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
                color: Color.fromARGB(255, 255, 255, 255), // Text color (black in this example)
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