import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:survey_app/api_service/PoliticianDetailsAPI.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/widgets/CustomCircularIndicator.dart';


import 'PublicRepresentativeScreen.dart';

class PublicRepresentativeSlider extends StatelessWidget {
  final VoidCallback? onPressed;

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
        FutureBuilder(
            future: PoliticianDetailsAPI(context: context).getDefaultPoliticianDetails(),
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return CustomCircularIndicator();
              }
              if(snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty){
                final representatives = snapshot.data!;
                return CarouselSlider(
                  options: CarouselOptions(
                    height: 430,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.95,
                    enableInfiniteScroll: true,
                  ),
                  items: representatives.map((value) {
                    final rep = value['politician']??{};
                    return Builder(
                      builder: (BuildContext context) {
                        return RepresentativeCard(
                          id: rep['id'].toString(),
                          name: rep["name"]??'N/A',
                          party: rep["party_name"]??'',
                          role: rep["constituency_category"]??'',
                          desc: rep["about"]??'',
                          imageUrl: rep["party_logo"]??'',
                          avatarUrl: rep["photo"]??'',
                          rating: rep["rating"].toString(),
                          comments: rep["comment_count"].toString(),
                          performance: rep["performance"].toString(),
                        );
                      },
                    );
                  }).toList(),
                );
              }else{
                return Center(
                  child: Text('No data available',style: TextStyle( fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,),),
                );
              }
        })
      ],
    );
  }


}
