import 'package:flutter/material.dart';
import 'package:animated_check/animated_check.dart';

class PaymentSuccessPage extends StatefulWidget {
  const PaymentSuccessPage({super.key});

  @override
  _PaymentSuccessPageState createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> with TickerProviderStateMixin {
  AnimationController? _checkAnimationController;
  Animation<double>? _scaleAnimation;
  bool _isAnimationCompleted = false;

  @override
  void initState() {
    super.initState();

    // Checkmark animation controller
    _checkAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Animation for scaling the checkmark
    _scaleAnimation = CurvedAnimation(
      parent: _checkAnimationController!,
      curve: Curves.easeInOut,
    );

    // Start animation when page loads
    _checkAnimationController!.forward().then((value) {
      setState(() {
        _isAnimationCompleted = true;
      });

      // Navigate to Fantasy Bets Page after the animation is complete
      
    });
  }

  @override
  void dispose() {
    _checkAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Checkmark
            ScaleTransition(
              scale: _scaleAnimation!,
              child: Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.greenAccent,
                ),
                child: AnimatedCheck(
                  progress: const AlwaysStoppedAnimation(1), // Full checkmark completed
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Payment Successful Text
            if (_isAnimationCompleted)
              const Text(
                "Payment Successful",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 20),

            // Confirmation Text
            if (_isAnimationCompleted)
              const Text(
                "Your payment has been processed successfully.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            const SizedBox(height: 40),

            // Go Back Button
            if (_isAnimationCompleted)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // This will navigate back to the previous screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent, // Button color
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: const Text(
                  "Go Back",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}