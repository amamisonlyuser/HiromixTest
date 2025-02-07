import 'package:flutter/material.dart';
import 'package:neopop/neopop.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HiromixAIPage extends StatefulWidget {
  const HiromixAIPage({super.key});

  @override
  State<HiromixAIPage> createState() => _HiromixAIPageState();
}

class _HiromixAIPageState extends State<HiromixAIPage> {
  double _sliderPosition = 130.0; // Initial centered position (150 - 20)
  final double _containerWidth = 300;

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black, // Ensure full black background
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Hiromix AI Logo
          Image.asset(
            'assets/HiromixAI.png', // Make sure this exists in assets
            width: 250,
            height: 100, // Adjust size as needed
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10), // Reduced space between image and button
          
          // NeoPop "0 Credit" Button
          SizedBox(
            width: 120, // Reduce width of the button
            child: NeoPopButton(
              color: const Color.fromARGB(255, 77, 158, 150),
              bottomShadowColor: const Color.fromARGB(255, 0, 100, 80),
              rightShadowColor: const Color.fromARGB(255, 0, 200, 83),
              animationDuration: const Duration(milliseconds: 300),
              depth: 8.0,
              onTapUp: () {},
              border: Border.all(
                color: const Color.fromARGB(255, 0, 200, 83),
                width: 2.0,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Adjust padding to fit size
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("0 Credits", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Image Comparison Box (unchanged)
          Container(
            width: _containerWidth,
            height: 380,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(0),
            ),
            child: Stack(
              children: [
                // Before Image (Left)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: ClipRect(
                      clipper: _LeftClipper(_sliderPosition),
                      child: Image.asset(
                        'assets/bg2.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // After Image (Right)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: ClipRect(
                      clipper: _RightClipper(_sliderPosition, _containerWidth),
                      child: Image.asset(
                        'assets/bg5.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Vertical Line
                Positioned(
                  left: _sliderPosition + 20, // Center line under slider
                  child: Container(
                    width: 2,
                    height: 400,
                    color: Colors.white,
                  ),
                ),

                // Slider Controller
                Positioned(
                  left: _sliderPosition,
                  top: 180,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        _sliderPosition += details.delta.dx;
                        _sliderPosition = _sliderPosition.clamp(-20.0, 300.0);
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black, // Border for slider
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.compare_arrows,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          NeoPopTiltedButton(
            decoration: NeoPopTiltedButtonDecoration(
              color: Colors.white,
              plunkColor: Colors.grey[300]!,
              shadowColor: Colors.black,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              child: Text(
                'Start',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTapUp: () {},
          ),
        ],
      ),
    ),
  );
}


}

class _LeftClipper extends CustomClipper<Rect> {
  final double width;
  _LeftClipper(this.width);

  @override
  Rect getClip(Size size) => Rect.fromLTRB(0, 0, width + 20, size.height);

  @override
  bool shouldReclip(covariant _LeftClipper oldClipper) => oldClipper.width != width;
}

class _RightClipper extends CustomClipper<Rect> {
  final double start;
  final double totalWidth;
  _RightClipper(this.start, this.totalWidth);

  @override
  Rect getClip(Size size) => Rect.fromLTRB(start + 20, 0, totalWidth, size.height);

  @override
  bool shouldReclip(covariant _RightClipper oldClipper) =>
      oldClipper.start != start || oldClipper.totalWidth != totalWidth;
}