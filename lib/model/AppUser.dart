import 'package:flutter/material.dart';
import 'package:survey_app/main.dart';
import 'package:survey_app/utilities/consts.dart';


class AppUser with ChangeNotifier {
  bool isOnBoarded = false;
  bool performed = false;
  String? accessToken = 'N/A';
  String? name = 'N/A';
  bool isStaff = false;
  bool isActive = false;
  bool isLogin = false;
  String? photo = 'N/A';
  String? phoneNumber;


  AppUser.fromPrefs(Map<String, dynamic> data) {
    isOnBoarded = data[Consts.isOnBoarded]??false;
    performed = data[Consts.performed]??false;
    accessToken = data[Consts.accessToken]??'N/A';
    name = data[Consts.name]??'N/A';
    isStaff = data[Consts.isStaff] ?? false;
    isActive = data[Consts.isActive] ?? false;
    isLogin = data[Consts.isLogin]??false;
    photo = data[Consts.photo]??'N/A';
    phoneNumber = data[Consts.phoneNumber]??'N/A';
  }

  AppUser();

  void update({
    bool? isOnBoarded,
    bool? performed,
    String? accessToken,
    String? name,
    bool? isStaff,
    bool? isActive,
    String? photo,
    bool? isLogin,
    String? phoneNumber,
  }) {
    this.isOnBoarded = isOnBoarded ?? this.isOnBoarded;
    this.performed = performed ?? this.performed;
    this.accessToken = accessToken ?? this.accessToken;
    this.name = name ?? this.name;
    this.isStaff = isStaff ?? this.isStaff;
    this.isActive = isActive ?? this.isActive;
    this.photo = photo ?? this.photo;
    this.isLogin = isLogin??this.isLogin;
    this.phoneNumber = phoneNumber??this.phoneNumber;
    notifyListeners();
  }

  void reset()async{
    this.isLogin = false;
    this.photo = 'N/A';
    this.performed = false;
    this.name ='N/A';
    this.accessToken = 'N/A';
    this.isOnBoarded = true;
    this.isStaff = false;
    this.isActive = false;
    this.phoneNumber = 'N/A';
    await prefs.clear();
    prefs.setBool(Consts.isOnBoarded, true);
    notifyListeners();
  }

  Map<String, dynamic> toMap() {
    return {
      'is_on_boarded': isOnBoarded,
      'performed': performed,
      'access_token': accessToken,
      'name': name,
      'is_staff': isStaff,
      'is_active': isActive,
      'photo': photo,
      'phone_number' : phoneNumber,
    };
  }

}
