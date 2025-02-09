import 'dart:io';
import 'package:flutter/material.dart';
import 'package:neopop/neopop.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:html' as html; // For web
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For kIsWeb
import 'package:image_picker/image_picker.dart';



class HiromixAIPage extends StatefulWidget {
  const HiromixAIPage({super.key});

  @override
  State<HiromixAIPage> createState() => _HiromixAIPageState();
}

class _HiromixAIPageState extends State<HiromixAIPage> {
  double _sliderPosition = 130.0;
  final double _containerWidth = 300;
  int _credits = 0; // Store fetched credits
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedImageBytes; // For web image storage
  bool _imageSelected = false; // Add this to your state class




Future<void> _pickImage() async {
  if (kIsWeb) {
    // Web-specific implementation
    final html.FileUploadInputElement input = html.FileUploadInputElement()
      ..accept = 'image/*';
    input.click();

    input.onChange.listen((e) async {
      final file = input.files!.first;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((event) async {
        final bytes = reader.result as Uint8List;
        setState(() {
          _selectedImageBytes = bytes; // Add Uint8List _selectedImageBytes to your state
        });
      });
    });
  }    else {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _imageSelected = true;
      });
    }
  }
}
  

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
  }

  Future<void> _saveImage(BuildContext context) async {
  try {
    // Load image from assets
    final ByteData data = await rootBundle.load('assets/bg5.png');
    final Uint8List bytes = data.buffer.asUint8List();

    if (!kIsWeb) { // Mobile (Android & iOS)
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission denied!')),
        );
        return;
      }

      final directory = await getTemporaryDirectory();
      final String filePath = '${directory.path}/downloaded_image.png';
      final io.File file = io.File(filePath);
      await file.writeAsBytes(bytes);

      final result = await ImageGallerySaver.saveFile(file.path);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image saved: $result')),
      );
    } else { // Web
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "image.png")
        ..click();
      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image downloaded!')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error saving image: $e')),
    );
  }
}

 @override
  void initState() {
    super.initState();
    
    _fetchCredits();
  }
  // Function to fetch credits from the API
  Future<void> _fetchCredits() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? phoneNumber = prefs.getString('phone_number'); // Retrieve phone number

    if (phoneNumber == null) {
      print('No phone number found in SharedPreferences');
      return;
    }

    final response = await http.post(
      Uri.parse('https://innqn6dwv1.execute-api.ap-south-1.amazonaws.com/prod/User/Credit'),
      body: jsonEncode({'phone_number': phoneNumber}), // Send phone number in body
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      int fetchedCredits = data['credits'] ?? 0;

      // Save to SharedPreferences
      await prefs.setInt('credits', fetchedCredits);

      // Update UI
      setState(() {
        _credits = fetchedCredits;
      });

      print('Credits updated: $_credits');
      print(' ${response.body}');
    } else {
      print('Failed to fetch credits: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching credits: $e');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/HiromixAI.png',
              width: 200,
              height: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),

            // NeoPop Button with Credits Display
            SizedBox(
              width: 120,
              child: NeoPopButton(
                color: const Color.fromARGB(255, 77, 158, 150),
                bottomShadowColor: const Color.fromARGB(255, 0, 100, 80),
                rightShadowColor: const Color.fromARGB(255, 0, 200, 83),
                animationDuration: const Duration(milliseconds: 300),
                depth: 8.0,
                onTapUp: _fetchCredits, // Fetch credits when tapped
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 200, 83),
                  width: 2.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("$_credits Credits", style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

         // Image Comparison Box
Container(
  width: _containerWidth,
  height: 380,
  decoration: BoxDecoration(
    border: Border.all(color: Colors.white, width: 2),
    borderRadius: BorderRadius.circular(0),
  ),
  child: Stack(
    children: [
      // Left Image (Before Image)
      // Add this in your Stack widget for the left image
Positioned.fill(
  child: ClipRRect(
    borderRadius: BorderRadius.circular(0),
    child: ClipRect(
      clipper: _sliderPosition >= _containerWidth - 5
          ? null 
          : _LeftClipper(_sliderPosition),
      child: Stack(
        children: [
          if (_selectedImage != null || _selectedImageBytes != null)
            kIsWeb
                ? Image.memory(
                    _selectedImageBytes!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
          else
            Image.asset(
              'assets/bg2.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          
          // Add X button only when image is selected
          if (_imageSelected && (_selectedImage != null || _selectedImageBytes != null))
            Positioned(
              left: 10,
              top: 10,
              child: GestureDetector(
           onTap: () async {
  final newPickedFile = await _picker.pickImage(source: ImageSource.gallery);

  if (newPickedFile != null) {
    if (kIsWeb) {
      final bytes = await newPickedFile.readAsBytes(); // Read bytes for web
      setState(() {
        _selectedImageBytes = bytes;
        _selectedImage = null; // Ensure mobile image is cleared
        _imageSelected = true;
      });
    } else {
      setState(() {
        _selectedImage = File(newPickedFile.path);
        _selectedImageBytes = null; // Ensure web image is cleared
        _imageSelected = true;
      });
    }
  } else {
    // If user cancels, keep the existing image to prevent null errors
    setState(() {}); 
  }
},

                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  ),
),

      // Right Image (After Image) - Only visible when user hasn't selected a new image
      if (_selectedImage == null && !_imageSelected)
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: ClipRect(
              clipper: _RightClipper(_sliderPosition, _containerWidth),
              child: Stack(
                children: [
                  Image.asset('assets/bg6.png', fit: BoxFit.cover),

                  // Download Icon on Right Image
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => _saveImage(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.download, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      // Vertical Line - Aligned with Slider
      Positioned(
        left: _sliderPosition - 1, // Align with slider
        child: Container(
          width: 2,
          height: 380,
          color: Colors.white,
        ),
      ),

      // Slider Controller (Moveable)
      Positioned(
        left: _sliderPosition - 20, // Center on split
        top: 170, // Center vertically
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _sliderPosition += details.delta.dx;
              _sliderPosition = _sliderPosition.clamp(0.0, _containerWidth);
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
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

          if (!_imageSelected)
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
              onTapUp: () {
                _pickImage(); // Trigger image selection
                setState(() {
                  _imageSelected = true;
                });
              },
            ),

          if (_imageSelected)
            SizedBox(
              width: 150,
              child: NeoPopButton(
                color: Colors.pinkAccent,
                bottomShadowColor: Colors.purple,
                rightShadowColor: Colors.red,
                depth: 8.0,
                onTapUp: () {
                  // Add glow up functionality
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Text(
                    'Glow Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
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
  Rect getClip(Size size) => Rect.fromLTRB(0, 0, width, size.height);

  @override
  bool shouldReclip(covariant _LeftClipper oldClipper) => oldClipper.width != width;
}

class _RightClipper extends CustomClipper<Rect> {
  final double start;
  final double totalWidth;
  _RightClipper(this.start, this.totalWidth);

  @override
  Rect getClip(Size size) => Rect.fromLTRB(start, 0, totalWidth, size.height);

  @override
  bool shouldReclip(covariant _RightClipper oldClipper) =>
      oldClipper.start != start || oldClipper.totalWidth != totalWidth;
}