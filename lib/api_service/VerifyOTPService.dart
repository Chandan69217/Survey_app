import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:survey_app/api_service/api_urls.dart';
import 'package:survey_app/api_service/handle_response.dart';



class VerifyOTPService {
  final BuildContext context;
  VerifyOTPService({required this.context});
  Future<Map<String,dynamic>?> verifyForRegister()async{
    return null;
  }

  Future<Map<String,dynamic>?> verifyOTP(String number,String OTP)async{
    try{
      final url = Uri.https(Urls.baseUrl,Urls.verifyOTP);
      final body = json.encode({
        'phone_number' : number,
        'otp' : OTP
      });
      print('Body: ${body}');
      final response = await post(url,body: body,headers: {
        'content-type':'Application/json',
        'Client-source' : 'mobile',
      } );
      print('Response Code: ${response.statusCode},Response Body: ${response.body}');
      if(response.statusCode == 200){
        final data = jsonDecode(response.body) as Map<String,dynamic>;
        return data;
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }
    return null;
  }

  Future<Map<String,dynamic>?> sendOTPForRegister(String number)async{
    try{
      final url = Uri.https(Urls.baseUrl,Urls.sendOTP);
      final body = json.encode({
        'phone_number' : number,
        'action_type' : 'register'
      });
      print('Body: ${body}');
      final response = await post(url,body: body,headers: {
        'content-type':'Application/json',
        'Client-source' : 'mobile',
      } );
      print('Response Code: ${response.statusCode},Response Body: ${response.body}');
      if(response.statusCode == 200){
        final data = jsonDecode(response.body) as Map<String,dynamic>;
        return data;
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }
    return null;
  }

  Future<Map<String,dynamic>?> sendOTPForReset(String number)async{
    try{
      final url = Uri.https(Urls.baseUrl,Urls.sendOTP);
      final body = json.encode({
        'phone_number' : number,
        'action_type' : 'reset'
      });
      print('Body: ${body}');
      final response = await post(url,body: body,headers: {
        'content-type':'Application/json',
        'Client-source' : 'mobile',
      } );
      print('Response Code: ${response.statusCode},Response Body: ${response.body}');
      if(response.statusCode == 200){
        final data = jsonDecode(response.body) as Map<String,dynamic>;
        return data;
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }
    return null;
  }

  Future<Map<String,dynamic>?> register({required String number,required String otp,required String name,required String password})async{
    try{
      final url = Uri.https(Urls.baseUrl,Urls.register);
      final body = json.encode({
        "phone_number": number,
        "otp": otp,
        "name": name,
        "password": password,
        "app_name": "mobile"
      });
      print('Body: ${body}');
      final response = await post(url,body: body,headers: {
        'content-type':'Application/json',
        'Client-source' : 'mobile',
      } );
      print('Response Code: ${response.statusCode},Response Body: ${response.body}');
      if(response.statusCode == 200){
        final data = jsonDecode(response.body) as Map<String,dynamic>;
        return data;
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }
    return null;
  }


}