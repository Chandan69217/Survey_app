import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:survey_app/api_service/api_urls.dart';

class GetLocationDetailsAPI{
  GetLocationDetailsAPI._();
  GetLocationDetailsAPI();

  static Future<List<dynamic>> getConstituencyTypeList()async{
    try{
      final url = Uri.https(Urls.baseUrl,Urls.constituency_type);
      final response = await get(url,headers: {
        'Content-type' : 'application/json',
        'Client-source' : 'mobile'
      });
      print('Response Code: ${response.statusCode},Body: ${response.body}');
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['success']??false;
        if(status){
          return body['data']??<List<dynamic>>[];
        }
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }
    return [];
  }

  static Future<List<dynamic>> getStateList()async{
    try{
      final url = Uri.https(Urls.baseUrl,Urls.state_list);
      final response = await get(url,headers: {
        'Content-type' : 'application/json',
        'Client-source' : 'mobile'
      });
      print('Response Code: ${response.statusCode},Body: ${response.body}');
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['success']??false;
        if(status){
          return body['data']??<List<dynamic>>[];
        }
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }
    return [];
  }

  static Future<List<dynamic>> getConstituencyList({required String constituencyTypeID,required String stateId})async{
    try{
      final url = Uri.https(Urls.baseUrl,'/api/constituency-list/${stateId}/${constituencyTypeID}/');
      final response = await get(url,headers: {
        'Content-type' : 'application/json',
        'Client-source' : 'mobile'
      });
      print('Response Code: ${response.statusCode},Body: ${response.body}');
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['success']??false;
        if(status){
          return body['data']??[];
        }
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }
    return <List<dynamic>>[];
  }

  static Future<List<dynamic>>  getDistrictList({required String stateId})async{
    try{
      final url = Uri.https(Urls.baseUrl,'/api/district-list/${stateId}/');
      final response = await get(url,headers: {
        'Content-type' : 'application/json',
        'Client-source' : 'mobile'
      });
      print('Response code: ${response.statusCode},Body: ${response.body}');
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['success']??false;
        if(status){
          return body['data']??<List<dynamic>>[];
        }
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }
    return <List<dynamic>>[];
  }

  static Future<List<dynamic>>  getCityList({required String districtId})async{
    try{
      final url = Uri.https(Urls.baseUrl,'/api/city-list/${districtId}/');
      final response = await get(url,headers: {
        'Content-type' : 'application/json',
        'Client-source' : 'mobile'
      });
      print('Response code: ${response.statusCode},Body: ${response.body}');
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['success']??false;
        if(status){
          return body['data']??<List<dynamic>>[];
        }
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }
    return <List<dynamic>>[];
  }

  static Future<List<dynamic>>  getBlockList({required String districtId})async{
    try{
      final url = Uri.https(Urls.baseUrl,'/api/block-list/${districtId}/');
      final response = await get(url,headers: {
        'Content-type' : 'application/json',
        'Client-source' : 'mobile'
      });
      print('Response code: ${response.statusCode},Body: ${response.body}');
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['success']??false;
        if(status){
          return body['data']??<List<dynamic>>[];
        }
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }
    return <List<dynamic>>[];
  }

  static Future<List<dynamic>>  getPanchayatList({required String districtId})async{
    try{
      final url = Uri.https(Urls.baseUrl,'/api/panchayat-list/${districtId}/');
      final response = await get(url,headers: {
        'Content-type' : 'application/json',
        'Client-source' : 'mobile'
      });
      print('Response code: ${response.statusCode},Body: ${response.body}');
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['success']??false;
        if(status){
          return body['data']??<List<dynamic>>[];
        }
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }
    return <List<dynamic>>[];
  }

}