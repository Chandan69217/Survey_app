import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:survey_app/api_service/api_urls.dart';
import 'package:survey_app/providers/LocationFilterData.dart';
import 'package:survey_app/utilities/custom_dialog/CustomMessageDialog.dart';
import 'package:survey_app/utilities/custom_dialog/SnackBarHelper.dart';
import 'package:survey_app/utilities/location_permisson_handler/LocationPermissionHandler.dart';



class PoliticianDetailsAPI {
  final BuildContext context;
  PoliticianDetailsAPI({required this.context});

  Future<List<dynamic>?> getDefaultPoliticianDetails()async{
    try{
      final url = Uri.https(Urls.baseUrl,Urls.defaultPolitician);
      final response = await get(url,headers: {
        'Content-type' : 'Application/json',
        'Client-source' : 'mobile',
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
        'content-type' : 'Application/json',
        'Client-source' : 'mobile',
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
        "constituency": LocationFilterData.selectedConstituencyType,
        "constituency_category": LocationFilterData.selectedConstituency,
        "state": LocationFilterData.selectedState,
        "district": LocationFilterData.selectedDistrict,
        "city": LocationFilterData.selectedCity,
        "block": LocationFilterData.selectedBlock,
        "panchayat": LocationFilterData.selectedPanchayat
      };

      final response = await post(url,headers: {
        'content-type' : 'Application/json',
        'Client-source' : 'mobile',
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
        'content-type' : 'Application/json',
        'Client-source' : 'mobile',
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

  Future<Map<String,dynamic>?> createPoliticianFeedback({String? name,required String rating, required String comment,required String politicianId,})async{
    final permissionStatus = await getLocationPermission(context);
    if(!(permissionStatus == LocationPermissionStatus.granted)){
     CustomMessageDialog.show(context, title: 'Location Permission', message: 'Location permission is required, please allow to submit your feedback');
    }
    final position = await Geolocator.getCurrentPosition();
    final latitude = position.latitude.toStringAsFixed(6);
    final longitude = position.longitude.toStringAsFixed(6);
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    final deviceId = deviceInfo.data['id']??'';
    try{
      final url = Uri.https(Urls.baseUrl,Urls.create_politician_feedback);
      final body = {
        "name":name,
        "politician": politicianId,
        "comment": comment,
        "rating": rating,
        "latitude": latitude,
        "longitude": longitude,
        "device_id": deviceId,
        "app_name": "mobile"
      };
      final response = await post(url,body: json.encode(body),headers: {
        'content-type' : 'application/json',
        'Client-source' : 'mobile',
      });
      print('Response code: ${response.statusCode},Body: ${response.body}');
      if(response.statusCode == 200 || response.statusCode == 201){
        final data = json.decode(response.body) as Map<String,dynamic>;
        final status = data['success']??false;
        if(status){
          return data;
        }
      }else{
        SnackBarHelper.show(context, 'Something went wrong !!');
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }
    return null;
  }
  
  Future<Map<String,dynamic>?> getPoliticianFeedbackList({required String id,required String page})async{
    try{
      final url = Uri.https(Urls.baseUrl,'/api/politician-feedback/${id}/list/',{'page' : page});
      final response = await get(url,headers: {
        'content-type' : 'application/json',
        'Client-source' : 'mobile',
      });
      print('Response code: ${response.statusCode}, Body: ${response.body}' );
      if(response.statusCode == 200){
        final data = json.decode(response.body) as Map<String,dynamic>;
        final status = data['success']??false;
        if(status){
          return data;
        }
      }
    }catch(exception,trace){
      print('Exception: ${exception}Trace: ${trace}');
    }
    return null;
  }
  
}