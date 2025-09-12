import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:survey_app/api_service/api_urls.dart';
import 'package:survey_app/main.dart';
import 'package:survey_app/utilities/consts.dart';
import 'package:survey_app/widgets/CustomCircularIndicator.dart';
import 'package:survey_app/widgets/ImageViewer.dart';
import 'package:survey_app/widgets/custom_network_image.dart';




class WithConstituencyQueryDetailsScreen extends StatelessWidget {
  final String id;
  final String constituencyId;

  const WithConstituencyQueryDetailsScreen({super.key, required this.id,required this.constituencyId});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Query Details",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
      ),
      body: FutureBuilder(future: _getQueryDetails(),
          builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return CustomCircularIndicator();
        }
        if(snapshot.hasData && snapshot.data != null){
          final data = snapshot.data!['data'] ?? {};
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Iconsax.note_text, size: 28, color: Colors.blue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        data['title'] ?? "Untitled",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Problem Description
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      data['problem'] ?? "No description available.",
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Status & Group Info
                Row(
                  children: [
                    Chip(
                      avatar: const Icon(Iconsax.warning_2,
                          size: 18, color: Colors.white),
                      label: Text(
                        (data['problem_status']?['label'] ?? "Unknown"),
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                    const SizedBox(width: 10),
                    Chip(
                      avatar: const Icon(Iconsax.people,
                          size: 18, color: Colors.white),
                      label: Text(
                        data['assigned_group']?['name'] ?? "Not Assigned",
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.grey.shade600,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Extra Info (name + photo if available)
                if (data['photo'] != null)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ImageViewerScreen(imageUrl: data['photo']??'') ));
                    },
                    child: CustomNetworkImage(
                      imageUrl: data['photo'],
                      width: double.infinity,
                      height: 200,
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     CustomNetworkImage(
                  //       imageUrl: data['photo'],
                  //       width: 40,
                  //       height: 40,
                  //     ),
                  //     const SizedBox(width: 10),
                  //     Expanded(
                  //       child: Text(
                  //         data['name'] ?? "Anonymous User",
                  //         style: const TextStyle(
                  //           fontSize: 15,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 20),
                ],

                // Meta Info
                if(data['name'] != null)
                  _infoTile(Iconsax.user, 'Created by', data['name']??'N/A'),
                _infoTile(Iconsax.calendar, "Created On",
                    data['created_at'] ?? "N/A"),
                _infoTile(Iconsax.clock, "Created At",
                    data['created_ago'] ?? "N/A"),
                _infoTile(Iconsax.document, "Solutions Added",
                    data['query_solutions'] ?? "0"),
              ],
            ),
          );
        }else{
          return Center(
            child: Text("Something went wrong !!"),
          );
        }
          }
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }


  Future<Map<String,dynamic>?> _getQueryDetails()async{
    try {
      final accessToken = prefs.getString(Consts.accessToken)??'';
      final url = Uri.https(Urls.baseUrl,'/api/raise-query/${constituencyId}/public-create/${id}/view/');
      final response = await get(url,headers: {
        'Authorization' : 'Bearer ${accessToken}',
        'Content-type' : 'application/json',
      });
      print('Response Code: ${response.statusCode} , Body: ${response.body}');
      if(response.statusCode == 200){
        final body  = json.decode(response.body) as Map<String,dynamic>;
        final status = body['success']??false;
        if(status){
          return body;
        }
      }
    }catch(exception,trace){
      print('Exception: ${exception}, Trace: ${trace}');
    }
    return null;
  }


}

