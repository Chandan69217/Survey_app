import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SliderScreen extends StatefulWidget {
  const SliderScreen({super.key});

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  List imageList = [
    {
      "id": 1,
      "image_path": 'assets/images/slider.jpg',
      "title": "Better उम्मीदवार",
      "color": Colors.white,
    },
    {
      "id": 2,
      "image_path": 'assets/images/slider2.jpg',
      "title": "Bright भविष्य",
      "color": Colors.deepOrange,
    },
    {
      "id": 3,
      "image_path": 'assets/images/slider3.jpg',
      "title": "Happy परिवार और समाज",
      "color": Colors.green,
    },
  ];

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Stack(
          children: [
            InkWell(
              onTap: () {
                print(currentIndex);
              },
              child: CarouselSlider(
                items: imageList.map((item) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        item['image_path'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      Container(
                        color: Colors.black.withOpacity(0.7),
                      ),
                      Center(
                        child: Text(
                          item['title'],
                          style: TextStyle(
                            color: item['color'],
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            shadows: const [
                              Shadow(
                                color: Colors.black54,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  );
                }).toList(),
                options: CarouselOptions(
                  scrollPhysics: const BouncingScrollPhysics(),
                  autoPlay: true,
                  aspectRatio: 2,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imageList.asMap().entries.map((entry) {
                  return GestureDetector(
                   // onTap: () => carouselController.animateToPage(entry.key),
                    child: Container(
                      width: currentIndex == entry.key ? 17 : 7,
                      height: 7.0,
                      margin: const EdgeInsets.symmetric(horizontal: 3.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentIndex == entry.key
                            ? Colors.red
                            : Colors.teal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
