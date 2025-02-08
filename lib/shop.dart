import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';


class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final PageController _pageController = PageController();
  late Timer _autoScrollTimer;


  // Sample data
  List<String> imagePaths = [
    'assets/banner3.png',
    'assets/banner4.png',
    'assets/banner1.png',
    'assets/banner5.png',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_pageController.page?.toInt() ?? 0) + 1;
        if (nextPage >= imagePaths.length) {
          nextPage = 0; // Loop back to the first page
        }
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }


 
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Shop',
        style: GoogleFonts.playfairDisplay(
          color: Colors.white,  // Changed to white for better contrast
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.black,  // AppBar background color is set to black
      elevation: 0,
      centerTitle: true,
    ),
    body: Container(
      color: Colors.black,  // Set the background color of the entire page to black
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            

            // Banner Section (Highlighting featured products or offers)
            SizedBox(
              height: 250, 
              // Adjust height based on your banner image size
              child: _buildImageBanner(imagePaths), // Pass in the banner image paths
            ),

            SizedBox(height: 20),

            // Men Category Section
            MenCategoryWidget(),

            SizedBox(height: 20),

            // Women Category Section
            WomenCategoryWidget(),
          ],
        ),
      ),
    ),
  );
}



Widget _buildImageBanner(List<String> images) {
  return Center( // Center the container in its parent
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 2), // White border with thickness
        borderRadius: BorderRadius.circular(2), // Rounded corners for the image container
      ),
      width: 330.0, // Set the width for the banner container
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2), // Match the container's border radius
        child: SizedBox(
          height: 250, // Fixed height for the banner
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length, // Number of images in the slideshow
            itemBuilder: (context, index) {
              return Image.asset(
                images[index], // Access image from assets
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    ),
  );
}
}

class MenCategoryWidget extends StatefulWidget {
  const MenCategoryWidget({super.key});

  @override
  _MenCategoryWidgetState createState() => _MenCategoryWidgetState();
}

class _MenCategoryWidgetState extends State<MenCategoryWidget> {
  final List<String> bannerImages = [
    'assets/menbanner1.png',
    'assets/menbanner2.png',
    'assets/menbanner3.png',
    'assets/menbanner4.png',
  ];

  final List<Map<String, String>> menCategories = [
  {
    'image': 'assets/menitem1.png', // Changed image to asset
    'name': 'AMI Paris chest-print overshirt'
  },
  {
    'image': 'assets/menitem2.png', // Changed image to asset
    'name': 'Barbour collared wax jacket'
  },
  {
    'image': 'assets/menitem3.png', // Changed image to asset
    'name': 'Track pants'
  },
  {
    'image': 'assets/menitem4.png', // Changed image to asset
    'name': 'SANDRO zipped bomber jacket'
  },
  {
    'image': 'assets/menitem5.png', // Changed image to asset
    'name': 'Polo Ralph Lauren Bear print hoodie'
  },
  {
    'image': 'assets/menitem6.png', // Changed image to asset
    'name': 'Peserico zip up jacket'
  },
];


  // Index for controlling the banner transition
  int _currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _startBannerRotation();
  }

  // Function to rotate through banner images
  void _startBannerRotation() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _currentBannerIndex = (_currentBannerIndex + 1) % bannerImages.length;
      });
      _startBannerRotation();  // Continue the rotation indefinitely
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Menswear',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.white, // White color for text to stand out
            ),
          ),
        ),
        SizedBox(height: 30),

        // Fade effect for banner images
        SizedBox(
          height: 400,
          width: 320, // Adjust the height of the banner as needed
          child: AnimatedSwitcher(
            duration: Duration(seconds: 1), // Duration for the fade transition
            child: ClipRRect(
              key: ValueKey<int>(_currentBannerIndex), // Key to trigger the animation
              borderRadius: BorderRadius.circular(2.0),
              child: Image.asset(
                bannerImages[_currentBannerIndex],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ),

        SizedBox(height: 20),

        // GridView of products under Men category
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            childAspectRatio: 0.8,
          ),
          itemCount: menCategories.length,
          itemBuilder: (context, index) {
            return _buildmenProductCard(menCategories[index]);
          },
        ),
      ],
    );
  }
}

Widget _buildmenProductCard(Map<String, String> menCategories) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Section
        ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          child: Image.asset(
            menCategories['image']!,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 180,
                color: Colors.grey.shade200,
                child: Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 50,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        // Product Name Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            menCategories['name']!,
            style: GoogleFonts.playfairDisplay(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis, // Makes sure long text doesn't overflow
          ),
        ),
        SizedBox(height: 10),
      ],
    ),
  );
}

class WomenCategoryWidget extends StatefulWidget {
  const WomenCategoryWidget({super.key});

  @override
  _WomenCategoryWidgetState createState() => _WomenCategoryWidgetState();
}

// Women Category Widget
class _WomenCategoryWidgetState extends State<WomenCategoryWidget> {
 final List<Map<String, String>> womenCategories = [
  {
    'image': 'assets/womenitem1.png', // Changed image to asset
    'name': 'Sandro cropped Jacket'
  },
  {
    'image': 'assets/womenitem2.png', // Changed image to asset
    'name': 'Maje leather skort'
  },
  {
    'image': 'assets/womenitem3.png', // Changed image to asset
    'name': 'Tory Burch'
  },
  {
    'image': 'assets/womenitem4.png', // Changed image to asset
    'name': 'Valentino Garavani geometric-pattern mini dress'
  },
  {
    'image': 'assets/womenitem5.png', // Changed image to asset
    'name': 'ISABEL MARANT double-breasted coat'
  },
  {
    'image': 'assets/womenitem6.png', // Changed image to asset
    'name': 'Rachel Gilbert Mattie top'
  },
];


  final List<String> bannerImages = [
    'assets/womenbanner1.png',
    'assets/womenbanner2.png',
    'assets/womenbanner3.png',
    'assets/womenbanner4.png',
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % bannerImages.length;
      });
    });
  }

 @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Womenswear',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.white, // White color for text to stand out
            ),
          ),
        ),
        SizedBox(height: 30),

        // Fade effect for banner images
        SizedBox(
          height: 400,
          width: 320, // Adjust the height of the banner as needed
          child: AnimatedSwitcher(
            duration: Duration(seconds: 1), // Duration for the fade transition
            child: ClipRRect(
              key: ValueKey<int>(_currentIndex), // Key to trigger the animation
              borderRadius: BorderRadius.circular(2.0),
              child: Image.asset(
                bannerImages[_currentIndex],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ),

        SizedBox(height: 20),

        // GridView of products under Men category
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            childAspectRatio: 0.8,
          ),
          itemCount: womenCategories.length,
          itemBuilder: (context, index) {
            return _buildmenProductCard(womenCategories[index]);
          },
        ),
      ],
    );
  }
}

Widget _buildwomenProductCard(Map<String, String> menCategories) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Section
        ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          child: Image.asset(
            menCategories['image']!,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 180,
                color: Colors.grey.shade200,
                child: Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 50,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        // Product Name Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            menCategories['name']!,
            style: GoogleFonts.playfairDisplay(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis, // Makes sure long text doesn't overflow
          ),
        ),
        SizedBox(height: 10),
      ],
    ),
  );
}
