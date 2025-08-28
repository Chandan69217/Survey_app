import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/utilities/custom_dialog/SnackBarHelper.dart';
import 'package:url_launcher/url_launcher.dart';


class OurLegendaryLeadersScreen extends StatefulWidget {
  OurLegendaryLeadersScreen({super.key});

  @override
  State<OurLegendaryLeadersScreen> createState() => _OurLegendaryLeadersScreenState();
}

class _OurLegendaryLeadersScreenState extends State<OurLegendaryLeadersScreen> {
  int currentIndex = 0;
  final leaders = [
    {
      "name": "Mohandas Karamchand Gandhi",
      "title": "Father of the Nation",
      "desc": "Pioneer of non-violence and truth who led India's freedom struggle.",
      "image":
      "https://storage.googleapis.com/a1aa/image/37ef51bb-27d3-4f26-6644-72a2de038f50.jpg",
      "wiki": "https://en.wikipedia.org/wiki/Mahatma_Gandhi",
      "youtube": "https://www.youtube.com/watch?v=uibI7s5URiU", // Valid link :contentReference[oaicite:4]{index=4}
    },
    {
      "name": "Dr. Bhimrao Ramji Ambedkar",
      "title": "Architect of the Constitution",
      "desc": "Visionary of social justice and equality.",
      "image":
      "https://storage.googleapis.com/a1aa/image/b4a0218f-9c53-4d13-76ef-f5e99e3bbd53.jpg",
      "wiki": "https://en.wikipedia.org/wiki/B._R._Ambedkar",
      "youtube": "https://www.youtube.com/watch?v=Wf3VJCpNMqI", // Valid link :contentReference[oaicite:5]{index=5}
    },
    {
      "name": "Dr. A.P.J. Abdul Kalam",
      "title": "Missile Man of India",
      "desc":
      "Scientist, teacher & president who inspired youth with dreams of a developed India.",
      "image":
      "https://storage.googleapis.com/a1aa/image/fe6bf21a-9c47-4b5b-593b-f60faf3b75ef.jpg",
      "wiki": "https://en.wikipedia.org/wiki/A._P._J._Abdul_Kalam",
      "youtube": "https://www.youtube.com/watch?v=LEtP7HgGTu0", // Valid link :contentReference[oaicite:6]{index=6}
    },
    {
      "name": "Narendra Damodardas Modi",
      "title": "Prime Minister of India",
      "desc":
      "Global statesman leading India with strong governance, bold reforms, and a vision for a developed Bharat.",
      "image":
      "https://storage.googleapis.com/a1aa/image/03798e50-ff64-4d25-8a86-a27c1b13459b.jpg",
      "wiki": "https://en.wikipedia.org/wiki/Narendra_Modi",
      "youtube": "https://www.youtube.com/watch?v=OHteSVrRcSA", // Valid link :contentReference[oaicite:7]{index=7}
    },


    {
      "name": "Mohandas Karamchand Gandhi",
      "title": "Father of the Nation",
      "desc": "Pioneer of non-violence and truth who led India's freedom struggle.",
      "image":
      "https://storage.googleapis.com/a1aa/image/37ef51bb-27d3-4f26-6644-72a2de038f50.jpg",
      "wiki": "https://en.wikipedia.org/wiki/Mahatma_Gandhi",
      "youtube": "https://www.youtube.com/watch?v=uibI7s5URiU", // Valid link :contentReference[oaicite:4]{index=4}
    },
    {
      "name": "Dr. Bhimrao Ramji Ambedkar",
      "title": "Architect of the Constitution",
      "desc": "Visionary of social justice and equality.",
      "image":
      "https://storage.googleapis.com/a1aa/image/b4a0218f-9c53-4d13-76ef-f5e99e3bbd53.jpg",
      "wiki": "https://en.wikipedia.org/wiki/B._R._Ambedkar",
      "youtube": "https://www.youtube.com/watch?v=Wf3VJCpNMqI", // Valid link :contentReference[oaicite:5]{index=5}
    },
    {
      "name": "Dr. A.P.J. Abdul Kalam",
      "title": "Missile Man of India",
      "desc":
      "Scientist, teacher & president who inspired youth with dreams of a developed India.",
      "image":
      "https://storage.googleapis.com/a1aa/image/fe6bf21a-9c47-4b5b-593b-f60faf3b75ef.jpg",
      "wiki": "https://en.wikipedia.org/wiki/A._P._J._Abdul_Kalam",
      "youtube": "https://www.youtube.com/watch?v=LEtP7HgGTu0", // Valid link :contentReference[oaicite:6]{index=6}
    },
    {
      "name": "Narendra Damodardas Modi",
      "title": "Prime Minister of India",
      "desc":
      "Global statesman leading India with strong governance, bold reforms, and a vision for a developed Bharat.",
      "image":
      "https://storage.googleapis.com/a1aa/image/03798e50-ff64-4d25-8a86-a27c1b13459b.jpg",
      "wiki": "https://en.wikipedia.org/wiki/Narendra_Modi",
      "youtube": "https://www.youtube.com/watch?v=OHteSVrRcSA", // Valid link :contentReference[oaicite:7]{index=7}
    },
    {
      "name": "Mohandas Karamchand Gandhi",
      "title": "Father of the Nation",
      "desc": "Pioneer of non-violence and truth who led India's freedom struggle.",
      "image":
      "https://storage.googleapis.com/a1aa/image/37ef51bb-27d3-4f26-6644-72a2de038f50.jpg",
      "wiki": "https://en.wikipedia.org/wiki/Mahatma_Gandhi",
      "youtube": "https://www.youtube.com/watch?v=uibI7s5URiU", // Valid link :contentReference[oaicite:4]{index=4}
    },
    {
      "name": "Dr. Bhimrao Ramji Ambedkar",
      "title": "Architect of the Constitution",
      "desc": "Visionary of social justice and equality.",
      "image":
      "https://storage.googleapis.com/a1aa/image/b4a0218f-9c53-4d13-76ef-f5e99e3bbd53.jpg",
      "wiki": "https://en.wikipedia.org/wiki/B._R._Ambedkar",
      "youtube": "https://www.youtube.com/watch?v=Wf3VJCpNMqI", // Valid link :contentReference[oaicite:5]{index=5}
    },
    {
      "name": "Dr. A.P.J. Abdul Kalam",
      "title": "Missile Man of India",
      "desc":
      "Scientist, teacher & president who inspired youth with dreams of a developed India.",
      "image":
      "https://storage.googleapis.com/a1aa/image/fe6bf21a-9c47-4b5b-593b-f60faf3b75ef.jpg",
      "wiki": "https://en.wikipedia.org/wiki/A._P._J._Abdul_Kalam",
      "youtube": "https://www.youtube.com/watch?v=LEtP7HgGTu0", // Valid link :contentReference[oaicite:6]{index=6}
    },
    {
      "name": "Narendra Damodardas Modi",
      "title": "Prime Minister of India",
      "desc":
      "Global statesman leading India with strong governance, bold reforms, and a vision for a developed Bharat.",
      "image":
      "https://storage.googleapis.com/a1aa/image/03798e50-ff64-4d25-8a86-a27c1b13459b.jpg",
      "wiki": "https://en.wikipedia.org/wiki/Narendra_Modi",
      "youtube": "https://www.youtube.com/watch?v=OHteSVrRcSA", // Valid link :contentReference[oaicite:7]{index=7}
    },
  ];

  @override
  Widget build(BuildContext context) {
    final pages = <List<Map<String, String>>>[];

    for(var i = 0 ; i< leaders.length;i+=4){
      pages.add(leaders.sublist(i,i+4>leaders.length ? leaders.length:i+4));
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
      decoration: BoxDecoration(
          color: CustColors.background1
      ),
      child: Column(
        children: [
          /// Header
          Column(
            children: const [
              Text(
                "Our Legendary Leaders",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Honoring the icons who ignited transformation, united the nation, and continue to inspire generations.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// Grid of Leaders
         CarouselSlider(
             items: pages.map((leaders)=>GridView.builder(
               shrinkWrap: true,
               physics: const NeverScrollableScrollPhysics(),
               itemCount: leaders.length,
               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: 2, // 2 per row on mobile
                 crossAxisSpacing: 12,
                 mainAxisSpacing: 12,
                 childAspectRatio: 0.75,
               ),
               itemBuilder: (context, index) {
                 final leader = leaders[index];
                 return LeaderCard(
                   videoURL: leader['youtube'],
                   webURL: leader['wiki'],
                   name: leader["name"]!,
                   title: leader["title"]!,
                   desc: leader["desc"]!,
                   image: leader["image"]!,
                 );
               },
             )).toList(),
           options: CarouselOptions(
             scrollPhysics: const BouncingScrollPhysics(),
             autoPlay: true,
             height: 550,
             aspectRatio: 2,
             viewportFraction: 1,
             onPageChanged: (index, reason) {
               setState(() {
                 currentIndex = index;
               });
             },
           ),
         ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: pages.asMap().entries.map((entry) {
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
        ],
      ),
    );
  }
}

class LeaderCard extends StatelessWidget {
  final String name;
  final String title;
  final String desc;
  final String image;
  final String? webURL;
  final String? videoURL;
  final String? voiceURL;

  const LeaderCard({
    super.key,
    required this.name,
    required this.title,
    required this.desc,
    required this.image,
    this.voiceURL,
    this.videoURL,
    this.webURL
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.05),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          /// Profile Image
          CircleAvatar(
            radius: 36,
            backgroundImage: NetworkImage(image),
            backgroundColor: Colors.amber,
          ),
          const SizedBox(height: 8),

          /// Name
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 14,
            ),
          ),

          /// Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.amber,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),

          /// Description
          Expanded(
            child: Text(
              desc,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
                height: 1.3,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 8),

          /// Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _iconButton(Icons.mic, context,onTap: ()async{
                SnackBarHelper.show(context, 'This feature is coming soon!');
              }),
              const SizedBox(width: 8),
              _iconButton(Icons.play_arrow, context,onTap: ()async{
                if(videoURL != null){
                  final Uri uri = Uri.parse(videoURL!);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch YouTube';
                  }
                }
              }),
              const SizedBox(width: 8),
              _iconButton(Icons.public, context,onTap: ()async{
                if(webURL != null){
                  final Uri uri = Uri.parse(webURL!);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch $webURL';
                  }
                }
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, BuildContext context,{VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.amber,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF002855)),
      ),
    );
  }
}
