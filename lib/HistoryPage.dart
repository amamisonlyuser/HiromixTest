import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color.fromARGB(255, 212, 186, 137), Color.fromARGB(255, 122, 71, 13)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Portfolio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '₹250',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Investment',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '₹1250',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Returns',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Closed Trades',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          const SizedBox(height: 10),
          const Center(
            child: PollCardhistory(isShimmering: true),
          ),
        ],
      ),
    );
  }

  
}



class PollCardhistory extends StatefulWidget {
  final bool isShimmering;

  const PollCardhistory ({super.key, required this.isShimmering});

  @override
  _PollCardhistoryState createState() => _PollCardhistoryState();
}

class _PollCardhistoryState extends State<PollCardhistory> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Faster animation
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.isShimmering ? 10 : 4, // Elevate the highlighted card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 1, // Ensure it fits within screen width
        height: 170, // Set a fixed height
        padding: const EdgeInsets.all(8), // Added padding to ensure contents fit within the card
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0), // Background color
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color.fromARGB(255, 253, 231, 216),
            width: 1, // Border width
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 253, 231, 216).withOpacity(0.6), // Glow color
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 0), // No offset for centered glow
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand, // Ensure the stack takes up all available space
          children: [
            Positioned.fill(
              child: Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.1),
                highlightColor: Colors.grey,
                period: Duration(seconds: widget.isShimmering ? 4 : 2), // Faster shimmer for shimmering cards
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 250, 249, 249).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            // Other elements inside the PollCard
            const Positioned(
              top: 20,
              left: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '10X/5X/2X Wins',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13, // Reduced font size
                      color: Color.fromARGB(255, 57, 196, 161), // Text color
                    ),
                  ),
                  Text(
                    '1st/2nd/3rd Rank Teams pickers',
                    style: TextStyle(
                      fontSize: 13, // Reduced font size
                      color: Color.fromARGB(255, 255, 255, 255), // Text color
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),
            Positioned(
              bottom: 55,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                height: 30,
                width: 100, // Increased width for better text and icon fit
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 253, 231, 216),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 19.0), // Add padding to move the text a bit to the middle
                      child: Text(
                        '₹250',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.circle,
                      size: 12,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20), // Adjusted padding
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
            'Winnings:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            ' Rs 2500', 
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 26, 255, 133),
              shadows: [
                Shadow(blurRadius: 3.0, color: Color(0xFFFFF5E8), offset: Offset(0, 0)),
                Shadow(blurRadius: 6.0, color: Color(0xFFE0C9B5), offset: Offset(0, 0)),
                Shadow(blurRadius: 10.0, color: Color(0xFF9A634A), offset: Offset(0, 0)),
              ],
            ),
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
}

