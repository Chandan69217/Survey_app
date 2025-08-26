import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/model/AppUser.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/utilities/custom_dialog/SnackBarHelper.dart';
import 'package:survey_app/view/auth/CitizenLoginScreen.dart';
import 'package:survey_app/view/home/EmulatorMockup/EmulatorMockup.dart';
import 'package:survey_app/view/home/ProfileScreen.dart';
import 'package:survey_app/view/home/PublicRepresentative/PublicRepresentativeScreen.dart';
import 'package:survey_app/view/home/slider/slider_screen.dart';
import 'package:survey_app/widgets/custom_network_image.dart';
import 'PublicChatDialog/PublicChatDialog.dart';
import 'PublicRepresentative/PublicRepresentativeSlider.dart';
import 'RepresentativePartySlider.dart';
import 'RepresentativeSection.dart';
import 'StatsSection.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustColors.background2,
      appBar: AppBar(
        backgroundColor: CustColors.background1,
        centerTitle: true,
        title: Image.asset("assets/images/true-survey-logo.png", scale: 4.1),
        actions: [
      Consumer<AppUser>(
      builder: (context, user, child) {
        return user.isLogin ? Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
            onTap: ()async{
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
            },
            child: CustomNetworkImage(
              height: 45,
              width: 45,
              imageUrl: user.photo,
            ),
          ),
        ) :Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: TextButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CitizenLoginScreen()));
          },
            child: Text('Login'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
          ),
        );
    },
    ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 0),
                FadeInAnimation(
                  delay: 0.5,
                  child: SizedBox(height: 220, child: SliderScreen()),
                ),
                SlideInAnimation(
                  direction: SlideDirection.right,
                  delay: 0.7,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    color: const Color(0xFF123763),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'ईमानदार और पारदर्शी समीक्षा से लोकतंत्र को मजबूत बनाएं — एक बेहतर और ताकतवर देश के लिए मिलकर कदम बढ़ाएं।',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SlideInAnimation(
                              direction: SlideDirection.left,
                              delay: 0.9,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFB800),
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: const Text(
                                  "Explore Parties",
                                  style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SlideInAnimation(
                              direction: SlideDirection.right,
                              delay: 1.1,
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white),
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text("Contact Us", style: TextStyle(fontSize: 12, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                EmulatorMockup(),
                FadeInAnimation(delay: 1.3, child: StatsSection()),
                const SizedBox(height: 10),
                SlideInAnimation(
                  direction: SlideDirection.left,delay: 1.5,
                  child: PublicRepresentativeSlider(
                    onPressed: ()async{
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PublicRepresentativeScreen()));
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SlideInAnimation(direction: SlideDirection.up, delay: 1.6, child: const RepresentativeSection()),
                FadeInAnimation(delay: 1.7, child: RepresentativePartySlider()),
              ],
            ),
          ),
        ),
      ),

      // ✨ Floating Action Button (FAB)
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: const Color(0xFF123763),
        foregroundColor: Colors.white,
        overlayColor: Colors.black,
        overlayOpacity: 0.3,
        spacing: 10,
        spaceBetweenChildren: 8,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.question_mark),
            backgroundColor: const Color(0xFF0054D3),
            label: 'Raise Query',
            labelStyle: const TextStyle(fontSize: 14),
            onTap: () {
              _showRaiseProblemDialog(context);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.chat_bubble_outline),
            backgroundColor: const Color(0xFF00A97F),
            label: 'Public Chat',
            labelStyle: const TextStyle(fontSize: 14),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const PublicChatDialog(),
              );
            },

          ),
        ],
      ),
    );
  }
}

// Animation helper classes
enum SlideDirection { left, right, up, down }

class FadeInAnimation extends StatelessWidget {
  final Widget child;
  final double delay;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.delay = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: (500 + delay * 1000).toInt()),
      curve: Curves.easeInOut,
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }
}

class SlideInAnimation extends StatelessWidget {
  final Widget child;
  final SlideDirection direction;
  final double delay;

  const SlideInAnimation({
    super.key,
    required this.child,
    this.direction = SlideDirection.left,
    this.delay = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    Offset getBeginOffset() {
      switch (direction) {
        case SlideDirection.left:
          return const Offset(-100, 0);
        case SlideDirection.right:
          return const Offset(100, 0);
        case SlideDirection.up:
          return const Offset(0, 100);
        case SlideDirection.down:
          return const Offset(0, -100);
      }
    }

    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: getBeginOffset(), end: Offset.zero),
      duration: Duration(milliseconds: (600 + delay * 1000).toInt()),
      curve: Curves.easeOutQuart,
      builder: (BuildContext context, Offset value, Widget? child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: child,
    );
  }
} void _showRaiseProblemDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Raise New Problem',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Problem Title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Describe your problem...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            const Text(
              'Attach File (Optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                // Handle file selection
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.attach_file, size: 20),
                    SizedBox(width: 8),
                    Text('Choose file'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No file chosen',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Handle submit
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Problem submitted successfully')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}