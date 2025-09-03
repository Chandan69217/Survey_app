import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:survey_app/api_service/api_urls.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/widgets/CustomCircularIndicator.dart';
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
    return FutureBuilder<Map<String,dynamic>?>(
      future: _getElectionDetails(),
      builder: (context,snapshot){

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
                    top: 45,
                    left: 30,
                    right: 30,
                    child: FutureBuilder(
                      future: _getElectionDetails(),
                      builder: (context,snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: CustomCircularIndicator(),
                          );
                        }
                        if(snapshot.hasData && snapshot.data != null){
                          final data = snapshot.data!;
                          final List<dynamic> ElectionName = data['election_name']??<List<dynamic>>[];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _SliderCard(politicians: data['election_candidate'],),
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
                              Text('न भाषण, न बहाने – जनता मांगे प्रगति के प्रमाण।', style: TextStyle(color: Colors.green,fontSize: 10,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold),textAlign: TextAlign.center,maxLines: 2,),
                              const SizedBox(height: 4,),
                              Text('मतदान से पहले, सच्चाई जानना ज़रूरी है।', style: TextStyle(color: Colors.red,fontSize: 10,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold),textAlign: TextAlign.center,maxLines: 2,),
                              const SizedBox(height: 8.0,),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8,vertical: 12),
                                width: double.infinity,
                                height: 85,
                                decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.blue,)
                                ),
                                child: CarouselSlider(
                                  items: ElectionName.map((i)=>Column(
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
                                            Text(i['election_date'] != null ? DateFormat("d MMM yyyy").format(DateTime.parse(i['election_date'])): 'ELECTION TIME',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 11,color: Colors.white,),overflow: TextOverflow.ellipsis,maxLines: 1,textAlign: TextAlign.start,),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4,),
                                      Text(i['name'] != null ? i['name']:'कोई चुनाव विवरण उपलब्ध नहीं है',style: TextStyle(overflow: TextOverflow.ellipsis,fontSize: 12),maxLines: 2,textAlign: TextAlign.center,)
                                    ],
                                  )).toList(),
                                  options: CarouselOptions(
                                    aspectRatio: 2,
                                    viewportFraction: 1,
                                      scrollPhysics: const BouncingScrollPhysics(),
                                    autoPlay: ElectionName.isNotEmpty && ElectionName.length != 1
                                  ),

                                ),
                              ),
                            ],
                          );
                        }else{
                          return  Text('Nothing to display');
                        }
                      },
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

      },
    );
  }

  Future<Map<String,dynamic>?> _getElectionDetails()async{
    try{
      final url = Uri.https(Urls.baseUrl,Urls.politician_details);
      final response = await get(url,headers: {
        'Content-type' : 'application/json',
        'Client-source' : 'mobile'
      });
      print('Response code: ${response.statusCode}, body: ${response.body}');
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['success']??false;
        if(status){
          final data = body['data']??{};
          return data;
        }
      }
    }catch(exception,trace){
      print('Exception: $exception,Trace: $trace');
    }
    return null;
  }


}

class _SliderCard extends StatelessWidget {
  final List<dynamic> politicians;
  _SliderCard({required this.politicians});


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
      items: politicians.map((i) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomNetworkImage(
              width: 50,
              height:50,
              borderRadius: BorderRadius.circular(60),
              imageUrl: i['photo']??'',
              fit: BoxFit.cover,
            ),
            // const SizedBox(height: 2,),
            Text(i['name']??'N/A',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10,overflow: TextOverflow.ellipsis),maxLines: 1,),
            const SizedBox(height: 2,),
            Expanded(child: Text(i['slogan']??'N/A',style: TextStyle(fontSize: 10,height: 1,overflow: TextOverflow.ellipsis),maxLines: 2,textAlign: TextAlign.center,)),
          ],
        );
      }).toList(),
    );
  }
}
