import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neopop/neopop.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PollsPage extends StatefulWidget {
  final String phoneNumber;
  final Function(List<Map<String, String>> selectedOptions) onSelectionComplete;

  const PollsPage({
    super.key,
    required this.phoneNumber,
    required this.onSelectionComplete,
  });

  @override
  _PollsPageState createState() => _PollsPageState();
}

class _PollsPageState extends State<PollsPage> {
  int _currentQuestionIndex = 0;
  final List<Map<String, String>> selectedOptions = [];
  late AudioPlayer audioPlayer;
  String? selectedOptionId; // Track the currently selected option ID
  late PageController _pageController;
  late ScrollController _scrollController; // Scroll controller

  // Sample poll data
  final Map<String, dynamic> pollData = {"polls": [{"poll_id": "d8ccdc7c-f14c-403a-a1fc-8cd95347f28b", "questions": [{"question": "Radiates natural confidence?", "options": [{"id": "582dc067-1f5c-4d10-8953-ea96cabacc6b", "text": "Aarushi", "image": "assets/girl1.png"}, {"id": "490a3458-a2b5-4a9e-b8aa-910b46388997", "text": "Hiromix", "image": "assets/Hiromix.png"}, {"id": "4b8a17cc-2f0d-4ffb-ba92-339c8a63dfb6", "text": "Kavya", "image": "assets/girl3.png"}, {"id": "c6a275b1-8c1b-4545-af7a-8a306217c9a6", "text": "Meera", "image": "assets/girl4.png"}]}, {"question": "Sweetest couple on campus", "options": [{"id": "aef43243-10fe-4d4d-828e-26637845463d", "text": "Ananya and Sujal", "image": "assets/couple1.png"}, {"id": "f499424a-c408-4e02-96ad-291ef3683ade", "text": "Diya and Gourav", "image": "assets/couple2.png"}, {"id": "9eb8a901-97a6-46cf-b43a-bc77da2c428b", "text": "Niharika and Jatin", "image": "assets/couple3.png"}, {"id": "b544db46-0b81-4f08-b5d5-a9f135d9e3ae", "text": "Riya and Shreyan", "image": "assets/couple4.png"}]}, {"question": "Title of the best person goes to?", "options": [{"id": "5b643162-dd00-4c49-8083-f0ae81645e23", "text": "Shivam", "image": "assets/boy1.png"}, {"id": "32a511c0-da77-48f1-9f98-a0549b0398d2", "text": "Sneha", "image": "assets/girl10.png"}, {"id": "5ad721c1-ea68-44d8-a1ce-9e3e83d069bf", "text": "Goutam", "image": "assets/boy2.png"}, {"id": "3ebbd6c5-ac22-4bb8-acb0-ed2019468b0d", "text": "Vanya", "image": "assets/girl12.png"}]}, {"question": "Have a cool vibe?", "options": [{"id": "851091cd-0b6f-485f-aba0-639a94233c20", "text": "Sourav", "image": "assets/boy3.png"}, {"id": "3207662b-e6a8-4914-836e-9c22fd2815fd", "text": "Ayan", "image": "assets/boy4.png"}, {"id": "8bf348b6-6a4c-4052-aa14-6cbeb79a47c9", "text": "Abhishek", "image": "assets/boy5.png"}, {"id": "57ae55a2-493b-4fff-90b7-07c64c32d19f", "text": "Avinash", "image": "assets/boy6.png"}]}, {"question": "Makes everyone laugh?", "options": [{"id": "7bba9c5d-b9a6-4864-a612-97481302a41e", "text": "Kunal", "image": "assets/boy7.png"}, {"id": "6bbcd990-5909-4dec-839d-7a79fb7de8f9", "text": "Parav", "image": "assets/boy8.png"}, {"id": "7d97e06c-2fec-46ac-b873-5b560a49e8ff", "text": "Varun", "image": "assets/boy9.png"}, {"id": "52478c8f-3fd6-4fb5-a32a-22506fd883b0", "text": "Tarun", "image": "assets/boy10.png"}]}]}, {"poll_id": "fa6e4a25-4c67-469c-a61c-ccb04e346ea5", "questions": [{"question": "Radiates natural confidence?", "options": [{"id": "8c4e3494-b9d3-417b-8625-ea42ab2e8c12", "text": "Aarushi", "image": "assets/girl1.png"}, {"id": "b24bda8e-85de-400a-8d7c-fad00fac71bf", "text": "Hiromix", "image": "assets/Hiromix.png"}, {"id": "616a1c85-9d7d-448e-91b2-787ac65a585c", "text": "Kavya", "image": "assets/girl3.png"}, {"id": "8666652d-686e-4a36-948e-d78e0f489e4d", "text": "Meera", "image": "assets/girl4.png"}]}, {"question": "Sweetest couple on campus", "options": [{"id": "3191abc4-520a-4c17-b876-908e4d6eee7a", "text": "Ananya and Sujal", "image": "assets/couple1.png"}, {"id": "45a8c14b-8e94-41e3-a548-c8691254f582", "text": "Diya and Gourav", "image": "assets/couple2.png"}, {"id": "3743a055-95d7-4436-82c7-7d391b846e34", "text": "Niharika and Jatin", "image": "assets/couple3.png"}, {"id": "e02472e7-1b34-4ac5-8326-ab691a343f70", "text": "Riya and Shreyan", "image": "assets/couple4.png"}]}, {"question": "Title of the best person goes to?", "options": [{"id": "269ad378-1a6c-47ff-9dc9-dcf15df367bc", "text": "Shivam", "image": "assets/boy1.png"}, {"id": "db1c73fe-ee8d-4ffe-81ad-aaa1a4ebb3e6", "text": "Sneha", "image": "assets/girl10.png"}, {"id": "807816e3-27ab-437c-9df2-b4f94b150715", "text": "Goutam", "image": "assets/boy2.png"}, {"id": "3d103e17-0d16-4fe0-aba3-d4f83ca3e482", "text": "Vanya", "image": "assets/girl12.png"}]}, {"question": "Have a cool vibe?", "options": [{"id": "bdc6aee4-bc6a-4c4a-9af0-20d4b0a736b2", "text": "Sourav", "image": "assets/boy3.png"}, {"id": "c5e15b8c-81fa-41af-a684-1831e891e919", "text": "Ayan", "image": "assets/boy4.png"}, {"id": "dc1ad7ee-3469-4776-8928-88ff227a63ee", "text": "Abhishek", "image": "assets/boy5.png"}, {"id": "dcdb8628-12fc-41aa-a99a-1c8ab1819864", "text": "Avinash", "image": "assets/boy6.png"}]}, {"question": "Makes everyone laugh?", "options": [{"id": "6aa317c6-7607-482a-83bb-c529ed0df7a7", "text": "Kunal", "image": "assets/boy7.png"}, {"id": "8548aa8d-f3d9-4027-aeb5-558709cc2881", "text": "Parav", "image": "assets/boy8.png"}, {"id": "d37b1b7c-359d-4ae3-94b9-fe7d29350be3", "text": "Varun", "image": "assets/boy9.png"}, {"id": "3d93dc9d-7247-424b-88c3-b3a516c6cde8", "text": "Tarun", "image": "assets/boy10.png"}]}]}]};

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _pageController = PageController();
    _scrollController = ScrollController(); // Initialize the scroll controller
  }

  void _selectOption(String optionId) {
    setState(() {
      selectedOptionId = optionId; // Set the selected option ID
    });
  }

  void _submitVote() {
    if (selectedOptionId != null) {
      final currentQuestion = pollData['polls'][0]['questions'][_currentQuestionIndex];
      selectedOptions.add({
        'question': currentQuestion['question'],
        'selected_option': selectedOptionId!,
      });

      if (_currentQuestionIndex < pollData['polls'][0]['questions'].length - 1) {
        _currentQuestionIndex++;
        _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
        selectedOptionId = null; // Reset for the next question
      } else {
        widget.onSelectionComplete(selectedOptions);
        _showCompletionDialog();
      }
    }
  }

  Future<void> _playSound(String soundPath) async {
    try {
      await audioPlayer.stop(); // Stop any currently playing sound
      await audioPlayer.play(AssetSource(soundPath)); // Play the new sound
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void _vibrate() {
    Vibration.vibrate(duration: 100, amplitude: 128);
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Voting Completed!'),
          content: const Text('Congrats, you have completed the voting!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Additional logic can be added here
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = pollData['polls'][0]['questions'][_currentQuestionIndex];
    return Scaffold(
      
      body: Container(
        color: const Color.fromARGB(255, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
  child: Stack(
    alignment: Alignment.center,
    children: [
      // Background dots image
      Positioned.fill(
        child: Image.asset(
          'assets/dots_black.png',
          fit: BoxFit.cover,
        ),
      ),
      // Question box
      Container(
        height: 140,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 250, 215, 155), // Sample color
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color.fromARGB(255, 15, 15, 15), width: 2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                currentQuestion['question'],
                style: GoogleFonts.blackHanSans(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Positioned stars icon
            Positioned(
              top: 5, // Adjust this value to move the image down
              right: 0, // Adjust this value to move the image to the right
              child: SvgPicture.asset(
                'assets/starsfinal.svg',
                height: 50, // Adjust the size as needed
                width: 50,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),
           Expanded(
  child: PageView.builder(
    itemCount: currentQuestion['options'].length,
    controller: _pageController,
    onPageChanged: (index) {
      if (currentQuestion['options'].isNotEmpty) {
        _selectOption(currentQuestion['options'][index]['id']);
        _playSound('tick_tock_sound.mp3');
        _vibrate();
      } else {
        print("No options found for this poll."); // Or handle as needed
      }
    },
    itemBuilder: (context, index) {
      final option = currentQuestion['options'][index];
      final bool isSelected = selectedOptionId == option['id'];
      final double blurValue = isSelected ? 0.0 : 10.0; // Less blur for the selected card

      return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.haveDimensions) {
                        value = (_pageController.page ?? 0) - index;
                        value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
                      }

                      return Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          height: Curves.easeOut.transform(value) * 300,
                          width: Curves.easeOut.transform(value) * 250,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(option['image']),
                                        fit: BoxFit.cover,
                                      ),
                                      border: Border.all(
                                        color: isSelected ? const Color.fromARGB(255, 255, 255, 255) : Colors.transparent,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: Color.fromARGB(255, 92, 231, 145),
                                            size: 40,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: isSelected ? 20 : 10,
                                child: Text(
                                  option['text'],
                                  style: const TextStyle(fontSize: 18.0, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            Padding(
  padding: const EdgeInsets.fromLTRB(60.0, 20.0, 30.0, 70.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (_currentQuestionIndex == 0 && selectedOptionId == null)
        SizedBox(
          height: 50,
          child: Center( // Wrap with Center widget
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  '< SCROLL >',
                  style: const TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ),
          ),
        )
                  else if (selectedOptionId != null)
                    Center(
                          child: NeoPopTiltedButton(
                            isFloating: true,
                            onTapUp: _submitVote,
                            decoration: const NeoPopTiltedButtonDecoration(
                              color: Color.fromARGB(255, 253, 236, 209),
                              plunkColor: Color.fromARGB(255, 255, 231, 196),
                              shadowColor: Color.fromRGBO(36, 36, 36, 1),
                              showShimmer: true,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 70.0,
                                vertical: 15,
                              ),
                              child: Text('Select'),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
