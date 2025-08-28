import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:survey_app/api_service/api_urls.dart';
import 'package:survey_app/api_service/handle_response.dart';

class PoliticianDetailsAPI {
  final BuildContext context;
  PoliticianDetailsAPI({required this.context});

  Future<List<dynamic>?> getDefaultPoliticianDetails()async{
    try{
      final url = Uri.https(Urls.baseUrl,Urls.defaultPolitician);
      final response = await get(url,headers: {
        'Content-type' : 'Application/json'
      });
      print('Response Code: ${response.statusCode}, Body: ${response.body}');
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['success']??false;
        if(status){
          final politicianList = body['data']??[];
          return politicianList;
        }
      }
    }catch(exception,trace){
      print('Exception: ${exception}, Trace: ${trace}');
    }
    return null;
  }

  Future<Map<String,dynamic>?> getPoliticianList({required String pageNo})async{
    try{
      final url = Uri.https(
        Urls.baseUrl,
        Urls.politicianList,
        {'page': pageNo.toString()},
      );
      final response = await get(url,headers: {
        'content-type' : 'Application/json'
      },);

      print('Response Code: ${response.statusCode}, Body: ${response.body}');
      if(response.statusCode == 200){
        final body =  json.decode(response.body) as Map<String,dynamic>;
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


  Future<Map<String,dynamic>?> getPoliticianListByFilter({required String pageNo,})async{

    try{
      final url = Uri.https(
        Urls.baseUrl,
        Urls.politicianList,
        {'page': pageNo.toString()},
      );
      final body = {
        "constituency": 1,
        "constituency_category": 2,
        "state": 5,
        "district": 12,
        "city": 8,
        "block": 3,
        "panchayat": 7
      };

      final response = await post(url,headers: {
        'content-type' : 'Application/json'
      },
        body: json.encode(body)
      );

      print('Response Code: ${response.statusCode}, Body: ${response.body}');
      if(response.statusCode == 200){
        final body =  json.decode(response.body) as Map<String,dynamic>;
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

  Future<Map<String,dynamic>?> getPoliticianDetails({required String id})async{
    try{
      final url = Uri.https(Urls.baseUrl,'/api/politician-details/${id}/detail-view/');
      final response = await get(url,headers: {
        'content-type' : 'Application/json'
      });
      print('Response code: ${response.statusCode} Body: ${response.body}');
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['success']??false;
        if(status){
          final data = body['data'];
          return data;
        }
      }
    }catch(exception,trace){
      print('Exception: ${exception} , Trace:  ${trace}');
    }
    return null;
  }

  
}