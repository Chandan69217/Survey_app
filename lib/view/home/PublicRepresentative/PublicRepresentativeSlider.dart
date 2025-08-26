import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


import 'PublicRepresentativeScreen.dart';

class PublicRepresentativeSlider extends StatelessWidget {
  final VoidCallback? onPressed;
  final List<Map<String, String>> representatives =  [
    {
      "name": "John Doe",
      "party": "Democratic Party",
      "role": "MLA",
      "desc": "Committed to education and healthcare reforms.",
      "imageUrl": "https://picsum.photos/400/200",
      "avatarUrl": "https://picsum.photos/50",
      "rating": "4.5",
      "comments": "120",
      "performance": "80%",
    },
    {
      "name": "Jane Smith",
      "party": "Republic Party",
      "role": "MP",
      "desc": "Working towards sustainable energy and jobs.",
      "imageUrl": "https://picsum.photos/400/201",
      "avatarUrl": "https://picsum.photos/51",
      "rating": "4.2",
      "comments": "95",
      "performance": "75%",
    },
  ];

  PublicRepresentativeSlider({super.key,this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'REPRESENTATIVES',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                  GestureDetector(
                    onTap: onPressed,
                    child: Chip(
                      label:  Text(
                        "View More",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  )

                ],
              ),
              const SizedBox(height: 4),
              const Text(
                "PUBLIC REPRESENTATIVES",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF001a44),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10,),
        /// Slider
        CarouselSlider(
          options: CarouselOptions(
            height: 430,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.95,
            enableInfiniteScroll: true,
          ),
          items: representatives.map((rep) {
            return Builder(
              builder: (BuildContext context) {
                return RepresentativeCard(
                  name: rep["name"]!,
                  party: rep["party"]!,
                  role: rep["role"]!,
                  desc: rep["desc"]!,
                  imageUrl: rep["imageUrl"]!,
                  avatarUrl: rep["avatarUrl"]!,
                  rating: rep["rating"]!,
                  comments: rep["comments"]!,
                  performance: rep["performance"]!,
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }


}
