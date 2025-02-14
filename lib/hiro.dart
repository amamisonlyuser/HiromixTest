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
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For kIsWeb
import 'package:image_picker/image_picker.dart';
import 'send_otp_page.dart';




class HiromixAIPage extends StatefulWidget {
  const HiromixAIPage({super.key});

  @override
  State<HiromixAIPage> createState() => _HiromixAIPageState();
}

class _HiromixAIPageState extends State<HiromixAIPage> {
  double _sliderPosition = 130.0;
  final double _containerWidth = 220; // Store fetched credits
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedImageBytes; // For web image storage
  bool _imageSelected = false; // Add this to your state class
  String? _processedImageUrl; // Add this
  bool _isProcessing = false;
  bool _showBanner = true; // Controls banner visibility
  int _credits = 0;


  
void _buyCredits(int amount) {
    setState(() {
      _credits += amount; // Add credits
      _showBanner = false; // Hide banner after purchase
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You bought $amount credits!'))
    );
  }




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
        // In your _pickImage method:
setState(() {
  _selectedImageBytes = bytes;
  _selectedImage = null;
  _imageSelected = true;
  _processedImageUrl = null; // Add this
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


Future<void> _saveProcessedImage(BuildContext context) async {
  if (_processedImageUrl == null) return;

  try {
    final response = await http.get(Uri.parse(_processedImageUrl!));
    final bytes = response.bodyBytes;

    if (kIsWeb) {
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "processed_image.png")
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/processed_image.png');
      await file.writeAsBytes(bytes);
      await ImageGallerySaver.saveFile(file.path);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image downloaded!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Download failed: $e')),
    );
  }
}

Future<String?> uploadToLambda(Uint8List imageBytes) async {
  try {
    // Detect Image Format using Magic Bytes
    String mimeType = "unknown";
    if (imageBytes.length > 4) {
      if (imageBytes[0] == 0xFF && imageBytes[1] == 0xD8) {
        mimeType = "image/jpeg"; // JPEG
      } else if (imageBytes[0] == 0x89 &&
          imageBytes[1] == 0x50 &&
          imageBytes[2] == 0x4E &&
          imageBytes[3] == 0x47) {
        mimeType = "image/png"; // PNG
      } else if (imageBytes[0] == 0x52 &&
          imageBytes[1] == 0x49 &&
          imageBytes[2] == 0x46 &&
          imageBytes[3] == 0x46) {
        mimeType = "image/webp"; // WebP
      }
    }

    if (mimeType == "unknown") {
      print("❌ Unsupported image format.");
      return null;
    }

    // Convert image to Base64
    String base64String = base64Encode(imageBytes);
    String dataUri = "data:$mimeType;base64,$base64String";

    // Wrap inside "body" field
    String requestBody = jsonEncode({
      "body": jsonEncode({"image_data": dataUri})
    });

    print("📡 Sending Request with MIME Type: $mimeType");

    // Send request to Lambda
    final response = await http.post(
      Uri.parse("https://innqn6dwv1.execute-api.ap-south-1.amazonaws.com/prod/User/HiromixAIImage"),
      headers: {"Content-Type": "application/json"},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Decode the "body" field which is itself a JSON string
      final responseBody = jsonDecode(responseData["body"]);

      if (responseBody.containsKey("upscaled_image_url")) {
        // Extract and clean up the URL
        String imageUrl = responseBody["upscaled_image_url"].replaceAll(r'\', '').trim();
        print("✅ Processed Image URL: $imageUrl");

        // TODO: Use the image URL as needed
        return imageUrl;
      } else {
        print("⚠️ API Success but missing 'upscaled_image_url' in response: ${response.body}");
        return null;
      }
    } else {
      print("❌ API Error (${response.statusCode}): ${response.body}");
      return null;
    }
  } catch (e) {
    print("🚨 Upload Error: $e");
    return null;
  }
}

    // Handle API response


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.black,
      body: Stack( // 1. Wrap entire body in Stack
      children: [
        Center(child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Image.asset(
              'assets/HiromixAI.png',
              width: 200,
              height: 80,
              fit: BoxFit.contain,
            ),
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
  height: 280,
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
                    fit: BoxFit.fill, // Changed from cover to fill
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Image.file(
                    _selectedImage!,
                    fit: BoxFit.fill, // Changed from cover to fill
                    width: double.infinity,
                    height: double.infinity,
                  )
          else
            Image.asset(
              'assets/bg2.png',
              fit: BoxFit.fill, // Ensure it fully covers
              width: double.infinity,
              height: double.infinity,
            ),
          // Add X button only when image is selected
            Positioned(
              left: 10,
              top: 10,
              child: GestureDetector(
                onTap: () async {
                  final newPickedFile = await _picker.pickImage(source: ImageSource.gallery);
                  
                  if (newPickedFile != null) {
                    if (kIsWeb) {
                      final bytes = await newPickedFile.readAsBytes();
                      setState(() {
                        _selectedImageBytes = bytes;
                        _selectedImage = null;
                        _imageSelected = true;
                      });
                    } else {
                      setState(() {
                        _selectedImage = File(newPickedFile.path);
                        _selectedImageBytes = null;
                        _imageSelected = true;
                      });
                    }
                  } else {
                    setState(() {}); // Prevent null errors
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

Positioned.fill(
  child: ClipRRect(
    borderRadius: BorderRadius.circular(0),
    child: ClipRect(
      clipper: _RightClipper(_sliderPosition, _containerWidth),
      child: Stack(
        children: [
          if (_isProcessing)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          else if (_processedImageUrl != null)
            Image.network(
              _processedImageUrl!,
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/bg5.png',
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                );
              },
            )
          else
            Image.asset(
              'assets/bg5.png',
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),

          // Download Icon
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => _saveProcessedImage(context),
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
          width: 1,
          height: 380,
          color: Colors.white,
        ),
      ),

      // Slider Controller (Moveable)
      Positioned(
        left: _sliderPosition - 20, // Center on split
        top: 130, // Center vertically
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
              color: const Color.fromARGB(255, 64, 64, 64).withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromARGB(255, 34, 34, 34),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.0),
                  spreadRadius: 0,
                  blurRadius: 0,
                )
              ],
            ),
            child: const Icon(
              Icons.compare_arrows,
              color: Color.fromARGB(255, 255, 255, 255),
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

          if (_imageSelected && !_isProcessing)
           
            // Modified Glow Up Button
SizedBox(
  width: 150,
  child: NeoPopButton(
    color: Colors.pinkAccent,
    bottomShadowColor: Colors.purple,
    rightShadowColor: Colors.red,
    depth: 8.0,
    onTapUp: () async {
    if (_selectedImageBytes == null || _selectedImageBytes!.isEmpty) {
      print("No image selected!");
      return;
    }

    setState(() {
      _isProcessing = true;
      _processedImageUrl = null;
    });

    // ✅ Correct way to call uploadToLambda()
    String? imageUrl = await uploadToLambda(_selectedImageBytes!);

    if (imageUrl != null) {
      setState(() {
        _processedImageUrl = imageUrl;
      });
    } else {
      print("Image processing failed.");
    }

    setState(() {
      _isProcessing = false;
    });
  },
    child: const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Text(
        '  Glow Up',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),



),
if (_credits == 0)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.9),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: 300,
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Credits Depleted!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Purchase credits to continue:',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 25),
                        _buildCreditOption(10, 99),
                        const SizedBox(height: 15),
                        _buildCreditOption(20, 149),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    ),

      ],
  
    ),
    );


  }


 Widget _buildCreditOption(int credits, int price) {
  return SizedBox(
    width: double.infinity,
    child: NeoPopButton(
      color: Colors.pinkAccent,
      bottomShadowColor: Colors.pink[800]!,
      rightShadowColor: Colors.pink[400]!,
      depth: 5,
      onTapUp: () => _purchaseCredits(credits),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Buy $credits Credits',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '₹$price',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
void _purchaseCredits(int amount) {
  // Implement your purchase logic here
  setState(() {
    _credits += amount; // Update credits after purchase
  });
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




