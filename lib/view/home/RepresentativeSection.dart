import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class RepresentativeSection extends StatefulWidget {
  const RepresentativeSection({super.key});

  @override
  State<RepresentativeSection> createState() => _RepresentativeSectionState();
}

class _RepresentativeSectionState extends State<RepresentativeSection> {
  final List<Map<String, String>> representatives = const [
    {
      "name": "Narendra Modi",
      "party": "Bharatiya Janata Party (BJP)",
      "description": "Prime Minister of India since 2014...",
      "image": "assets/images/party/modi.png",
      "partyLogo": "assets/images/party/bjp-logo.png"
    },
    {
      "name": "Amit Shah",
      "party": "Bharatiya Janata Party (BJP)",
      "description": "Union Home Minister of India...",
      "image": "assets/images/party/amit.jpeg",
      "partyLogo": "assets/images/party/bjp-logo.png"
    },
    {
      "name": "Rahul Gandhi",
      "party": "Indian National Congress (INC)",
      "description": "Former President of INC...",
      "image": "assets/images/party/rahul.jpeg",
      "partyLogo": "assets/images/party/inc-logo.png"
    },
    {
      "name": "Arvind Kejriwal",
      "party": "Aam Aadmi Party (AAP)",
      "description": "Chief Minister of Delhi...",
      "image": "assets/images/party/amit.jpeg",
      "partyLogo": "assets/images/party/bjp-logo.png"
    },
  ];

  int currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSwitch();
  }

  void _startAutoSwitch() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % representatives.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rep = representatives[currentIndex];

    return  Padding(
        padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 16),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'LEADERSHIP',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Chip(
                    label:  Text(
                      "View More",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  )

                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'REPRESENTATIVE LEADERS',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF001253),
                ),
              ),
            ],
          ),
        ),
      const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: RepresentativeCard(
              key: ValueKey(currentIndex),
              name: rep['name']!,
              party: rep['party']!,
              description: rep['description']!,
              imagePath: rep['image']!,
              partyLogoPath: rep['partyLogo']!,
            ),
          ),
        ),
       
      ],
    ));
  }
}



class RepresentativeCard extends StatelessWidget {
  final String name;
  final String party;
  final String description;
  final String imagePath;
  final String partyLogoPath;

  const RepresentativeCard({
    super.key,
    required this.name,
    required this.party,
    required this.description,
    required this.imagePath,
    required this.partyLogoPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & Party Logo
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Image.asset(
                      partyLogoPath,
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  party,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Get Review", style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Show Details", style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}



