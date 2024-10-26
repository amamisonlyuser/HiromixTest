import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'send_otp_page.dart';

class ActiveTradesPage extends StatelessWidget {
  const ActiveTradesPage({super.key});

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
                colors: [Color.fromARGB(255, 137, 212, 143), Color.fromARGB(255, 4, 83, 53)],
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Portfolio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
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
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Active Trades',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          const SizedBox(height: 10),
          const Center(
            child: PollCardActiveTrades(isShimmering: true),
          ),
          const SizedBox(height: 20),
          // Logout button
          GestureDetector(
            onTap: () {
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
                  SizedBox(width: 5),
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
    );
  }

  Widget _buildResultsContainer() {
    return Container();
  }
}

class PollCardActiveTrades extends StatefulWidget {
  final bool isShimmering;

  const PollCardActiveTrades({super.key, required this.isShimmering});

  @override
  _PollCardActiveTradesState createState() => _PollCardActiveTradesState();
}

class _PollCardActiveTradesState extends State<PollCardActiveTrades> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
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
      elevation: widget.isShimmering ? 10 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 170,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color.fromARGB(255, 253, 231, 216),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 253, 231, 216).withOpacity(0.6),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.1),
                highlightColor: Colors.grey,
                period: Duration(seconds: widget.isShimmering ? 4 : 2),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 250, 249, 249).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
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
                      fontSize: 13,
                      color: Color.fromARGB(255, 57, 196, 161),
                    ),
                  ),
                  Text(
                    '1st/2nd/3rd Rank Teams pickers',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 255, 255, 255),
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
                width: 100,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 253, 231, 216),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 19.0),
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
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Results in:',
                      style: TextStyle(
                        fontFamily: 'Digital-7',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      ' 10:00:00',
                      style: TextStyle(
                        fontFamily: 'Digital-7',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 232, 26),
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
