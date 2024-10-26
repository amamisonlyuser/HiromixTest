import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'FantasyBetsPage.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimationPage extends StatefulWidget {
  final List<Map<String, String>> selectedOptions;

  const AnimationPage({super.key, required this.selectedOptions});

  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> with SingleTickerProviderStateMixin {
  bool showHeading = false;
  bool showImages = false;
  bool showFireworks = false; // Added state for controlling fireworks

  late AnimationController _controller;
  late Animation<double> _headingAnimation;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();

    if (widget.selectedOptions.isEmpty) {
      // Handle the case where no options were selected (e.g., show a message)
      return;
    }

    // Initialize audio player
    _audioPlayer = AudioPlayer();
  
    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Create heading animation
    _headingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Start heading animation after 1 second delay and play sound
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _controller.forward();
        _playHeadingSound();
        setState(() {
          showHeading = true;
        });
      }
    });

    // Simulate delayed appearance of images after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _playImageSound();
        setState(() {
          showImages = true;
        });
      }
    });

    // Set fireworks to show after 3 seconds and navigate to FantasyBetsPage after 7 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showFireworks = true;
        });
      }
    });

    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FantasyBetsPage(
              selectedOptions: widget.selectedOptions,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playHeadingSound() async {
    const soundPath = 'game-level-complete-143022.mp3';
    await _audioPlayer.play(AssetSource(soundPath));
  }

  void _playImageSound() async {
    const soundPath = 'playful-casino-slot-machine-jackpot-2-183923.mp3';
    await _audioPlayer.play(AssetSource(soundPath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background animation
          Center(
            child: Lottie.asset(
              'assets/Animation_lights_bg.json',
              onLoaded: (composition) {
                // Use Lottie animation's duration to navigate to FantasyBetsPage when the animation is complete
                Future.delayed(composition.duration, () {
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FantasyBetsPage(
                          selectedOptions: widget.selectedOptions,
                        ),
                      ),
                    );
                  }
                });
              },
            ),
          ),

          // Animated heading and selected options display
          AnimatedOpacity(
  duration: const Duration(milliseconds: 500),
  opacity: showHeading ? 1 : 0,
  child: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
  animation: _headingAnimation,
  builder: (context, child) {
    return Opacity(
      opacity: _headingAnimation.value,
      child: Transform.translate(
        offset: Offset(0.0, 50.0 * (1 - _headingAnimation.value)),
        child: Text(
          'Your Team',
          style: GoogleFonts.openSans(
            fontSize: 40,
            color: Color.fromARGB(255, 213, 216, 57),
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(3.0, 3.0),
                blurRadius: 3.0,
                color: Color.fromARGB(255, 248, 153, 36),
              ),
            ],
          ),
        ),
      ),
    );
  },
),
                  const SizedBox(height: 20),

                  // Display selected options
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: showImages ? 1 : 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: widget.selectedOptions.length > 2
                                ? widget.selectedOptions
                                    .sublist(0, 3)
                                    .map((option) => _buildImageItem(option['image']!, option['text']!))
                                    .toList()
                                : [],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: widget.selectedOptions.length > 4
                                ? widget.selectedOptions
                                    .sublist(3, 5)
                                    .map((option) => _buildImageItem(option['image']!, option['text']!))
                                    .toList()
                                : [],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Firework Lottie animation with a delay of 3 seconds
          Visibility(
            visible: showFireworks,
            child: Positioned(
              top: 110, // Adjust this value to position it below the "Your Team" text
              left: 0,
              right: 0,
              child: SizedBox(
                width: 200, // Ensure it's 500x500 as per your requirement
                height: 200,
                child: Lottie.asset(
                  'assets/Firework_confetti.json',
                  repeat: false, // Ensure it plays only once
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageItem(String imagePath, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adjust spacing here
      child: Column(
        children: [
          Container(
            width: 70,
            height: 130,
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromARGB(255, 129, 129, 129), width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}