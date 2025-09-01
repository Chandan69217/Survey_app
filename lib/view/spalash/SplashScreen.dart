import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:survey_app/main.dart';
import 'package:survey_app/utilities/consts.dart';
import '../home/homescreen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration)async{
      final bool isOnboarded =  prefs.getBool(Consts.isOnBoarded)??false;
      Future.delayed(const Duration(seconds: 2), ()async{
       try{
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (context) => isOnboarded ? HomeScreen() : OnboardingScreen()),
         );
       }catch(excption,trace){
         print('Exception: $excption ,Trace: $trace');
       }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A4D8F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/splash/vote_icon.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 20),
            const Text(
              'Election Survey',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: "Better Candidate",
      subtitle: "बेहतर उम्मीदवार",
      description: "ईमानदार और पारदर्शी समीक्षा से लोकतंत्र को मजबूत बनाएं",
      icon: Iconsax.profile_2user,
      color: const Color(0xFF1A4D8F),
    ),
    OnboardingPage(
      title: "Bright Future",
      subtitle: "उज्जवल भविष्य",
      description: "एक बेहतर और ताक़तवर देश के लिए मिलकर कदम बढ़ाएं",
      icon: Iconsax.sun_1,
      color: const Color(0xFF4CAF50),
    ),
    OnboardingPage(
      title: "Happy Family and Society",
      subtitle: "सशक्त राष्ट्र",
      description: "सही चुनाव से सशक्त समाज और खुशहाल परिवार",
      icon: Iconsax.home_hashtag,
      color: const Color(0xFFE91E63),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400; // phone
    final isTablet = size.width >= 600; // tablet or large

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPageWidget(
                page: _pages[index],
                isSmall: isSmall,
                isTablet: isTablet,
                size: size,
              );
            },
          ),
          Positioned(
            bottom: isSmall ? 20 : 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                        (index) => buildDot(index: index),
                  ),
                ),
                const SizedBox(height: 30),
                // Button
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 80 : 40,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _pages.length - 1) {
                        prefs.setBool(Consts.isOnBoarded, true);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _pages[_currentPage].color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(double.infinity, isSmall ? 48 : 56),
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1
                          ? "Get Started"
                          : "Next",
                      style: TextStyle(
                        fontSize: isSmall ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? _pages[index].color : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;
  final bool isSmall;
  final bool isTablet;
  final Size size;

  const OnboardingPageWidget({
    super.key,
    required this.page,
    required this.isSmall,
    required this.isTablet,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: page.color.withValues(alpha: 0.1),
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 48 : 24,
        vertical: isSmall ? 60 : 0
      ),
      child: Column(
        mainAxisAlignment: isSmall ? MainAxisAlignment.start :MainAxisAlignment.center,
        children: [
          // Icon circle
          Container(
            width: isTablet ? 150 : 120,
            height: isTablet ? 150 : 120,
            decoration: BoxDecoration(
              color: page.color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: isTablet ? 80 : 60,
              color: page.color,
            ),
          ),
          SizedBox(height: isTablet ? 50 : 40),
          // Title
          Text(
            page.title,
            style: TextStyle(
              fontSize: isSmall ? 18 : (isTablet ? 26 : 20),
              fontWeight: FontWeight.bold,
              color: page.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            page.subtitle,
            style: TextStyle(
              fontSize: isSmall ? 18 : (isTablet ? 24 : 20),
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              page.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmall ? 14 : 16,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: isTablet ? 60 : 40),
          // Image
          Image.asset(
            'assets/onboarding/onboarding_${_getImageIndex(page.title)}.png',
            height: isTablet ? size.height * 0.35 : 200,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  int _getImageIndex(String title) {
    switch (title) {
      case "Better Candidate":
        return 1;
      case "Bright Future":
        return 2;
      case "Happy Family and Society":
        return 3;
      default:
        return 1;
    }
  }

}


