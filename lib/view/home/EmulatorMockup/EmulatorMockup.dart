import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/widgets/custom_network_image.dart';

class EmulatorMockup extends StatefulWidget {
  const EmulatorMockup({Key? key}) : super(key: key);

  @override
  State<EmulatorMockup> createState() => _EmulatorMockupState();
}

class _EmulatorMockupState extends State<EmulatorMockup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -15, end: 15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      color: CustColors.background1,
      child: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animation.value),
              child: child,
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Emulator phone image
              Image.asset(
                'assets/images/emulator_phone.webp',
                fit: BoxFit.contain,
              ),

              Positioned(
                top: 45, // adjust according to your phone image
                left: 30,
                right: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _SliderCard(),
                    const SizedBox(height: 4,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Image.asset('assets/images/vote.webp',width: 18,height: 18,fit: BoxFit.contain,),
                      const SizedBox(width: 6,),
                        Image.asset('assets/images/young-boy.webp',width: 18,height: 18,fit: BoxFit.contain,),
                      const SizedBox(width: 6,),
                        Image.asset('assets/images/woman.webp',width: 18,height: 18,fit: BoxFit.contain,),
                    ],),
                    const SizedBox(height: 8,),
                    Text('वादों का नहीं, अब वोटिंग होगा काम के आधार पर !',style: TextStyle(color: Colors.blue,fontSize: 10,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold),maxLines: 2,textAlign: TextAlign.center,),
                    const SizedBox(height: 4,),
                    Text('न भाषण, न बहाने – जनता मांगे प्रगति के प्रमाण।', style: TextStyle(color: Colors.green,fontSize: 10,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                    const SizedBox(height: 4,),
                    Text('मतदान से पहले, सच्चाई जानना ज़रूरी है।', style: TextStyle(color: Colors.red,fontSize: 10,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                    const SizedBox(height: 8.0,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 12),
                      width: double.infinity,
                      height: 95,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue,)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Iconsax.wallet,size: 12,color:Colors.white,),
                                Text('ELECTION TIME',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 11,color: Colors.white),),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Text('कोई चुनाव विवरण उपलब्ध नहीं है',style: TextStyle(overflow: TextOverflow.ellipsis,fontSize: 12),maxLines: 2,textAlign: TextAlign.center,)
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              Positioned(
                bottom: 30,
                  child: Container(
                width: 60,
                height: 3,
                decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12)
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class _SliderCard extends StatelessWidget {
  final List<Map<String, dynamic>> _politicians = const [
    {
      'photoUrl': "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSeEW2IGItl_ojrFfYlawT24s132t0D0U7KbcWDqhqvVhwjIVJ3",
      'name': "Amit Shah",
      'nara': "जनता की सेवा ही हमारा धर्म है।",
    },
    {
      'photoUrl': "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTKqIg3pZGnGVuDbO7piYwe2EBzDMOcMohDv5sIWQ-tnD7ruRla",
      'name': "Narendra Modi",
      'nara': "शिक्षा और स्वास्थ्य सबके लिए।",
    },
    {
      'photoUrl': "https://encrypted-tbn3.gstatic.com/licensed-image?q=tbn:ANd9GcTSvIDS_M5iPfNmGrtHIqaeGF2K2N6YleReqLRnIZ0MgzOkRkTcjHwh-iNkhrMfj9LvAPHAP7WZFiP2PI4",
      'name': "Rahul Gandhi",
      'nara': "युवा शक्ति, देश की शक्ति।",
    },
    {
      'photoUrl': "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQUcjGVGpILcmInPmmLRBnJhgOAHfukeJzzzmTqnxZJnM95GE77",
      'name': "Sonia Gandhi",
      'nara': "समानता और न्याय सभी के लिए।",
    },
    {
      'photoUrl': "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlBwOqvMU47ta9vxgT-P3ntukWllMQrcG67hkk7nWu5eDN5Ch2",
      'name': "Akhilesh Yadav",
      'nara': "किसानों की खुशहाली, देश की मजबूती।",
    },
    {
      'photoUrl': "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpvxwd9xHXjqGYOrhedt7qCK82_V5-68JJCInZpjq5i7HibSVwhJ_sHJ4FpenFjnxRCg6Tr3_xgbKJteP1--8Dbw",
      'name': "Mamata Banerjee",
      'nara': "गरीबों की आवाज़ हमारी ताक़त है।",
    },
    {
      'photoUrl': "https://www.hindustantimes.com/ht-img/img/2024/09/15/1600x900/Delhi-chief-minister-Arvind-Kejriwal---File-Photo-_1726390332646.jpg",
      'name': "Arvind Kejriwal",
      'nara': "ईमानदार राजनीति, सबके लिए।",
    },
    {
      'photoUrl': "https://c.ndtvimg.com/2024-11/qq96dhgg_mayawati_625x300_16_November_24.jpg?im=FeatureCrop,algorithm=dnn,width=1200,height=738",
      'name': "Mayawati",
      'nara': "दलितों और पिछड़ों की आवाज़ बुलंद।",
    },
    {
      'photoUrl': "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQsIJFBTzjNv7kBP2u_wN3sXsOzDaLAY8IFPFt2zV-HEMRJOT9V",
      'name': "Nitish Kumar",
      'nara': "सुशासन ही प्रगति का आधार है।",
    },
    {
      'photoUrl': "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSd0iXV2SOM5xu4tAunv4ZsNtuPgGzSY9u2YdN1gQjeCYEDO-6qZui54FSHYybeHXxnPteErDsNWPIgKmwmGsFkdQ",
      'name': "Lalu Prasad Yadav",
      'nara': "समानता और भाईचारा ही असली ताक़त है।",
    },
    {
      'photoUrl': "https://encrypted-tbn2.gstatic.com/licensed-image?q=tbn:ANd9GcQQLlA-EDpH3ucf9ZpqbuicYtnYRo5u4pD4JHGIfBKQzaFsFULM3-oJ-nKYzeZB2BzC-0f6TYNAwiPXUxU",
      'name': "Yogi Adityanath",
      'nara': "धर्म और संस्कृति से देश का उत्थान।",
    },
  ];


  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 90,
        viewportFraction: 1,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeCenterPage: false,
        scrollDirection: Axis.horizontal,
      ),
      items: _politicians.map((i) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomNetworkImage(
              width: 50,
              height:50,
              borderRadius: BorderRadius.circular(60),
              imageUrl: i['photoUrl']??'',
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 2,),
            Text(i['name']??'N/A',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10,overflow: TextOverflow.ellipsis),maxLines: 1,),
            const SizedBox(height: 2,),
            Text(i['nara']??'N/A',style: TextStyle(fontSize: 10,overflow: TextOverflow.ellipsis),maxLines: 1,),
          ],
        );
      }).toList(),
    );
  }
}
