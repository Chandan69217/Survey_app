import 'package:flutter/material.dart';
import 'package:survey_app/utilities/consts.dart';


class AppUser with ChangeNotifier {
  bool isOnBoarded = false;
  bool performed = false;
  String? accessToken;
  String? name;
  bool isStaff = false;
  bool isActive = false;
  bool isLogin = false;
  String? photo;


  AppUser.fromPrefs(Map<String, dynamic> data) {
    isOnBoarded = data[Consts.isOnBoarded];
    performed = data[Consts.performed];
    accessToken = data[Consts.accessToken];
    name = data[Consts.name];
    isStaff = data[Consts.isStaff] ?? false;
    isActive = data[Consts.isActive] ?? false;
    isLogin = data[Consts.isLogin]??false;
    photo = data[Consts.photo];
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
    bool? isLogin
  }) {
    this.isOnBoarded = isOnBoarded ?? this.isOnBoarded;
    this.performed = performed ?? this.performed;
    this.accessToken = accessToken ?? this.accessToken;
    this.name = name ?? this.name;
    this.isStaff = isStaff ?? this.isStaff;
    this.isActive = isActive ?? this.isActive;
    this.photo = photo ?? this.photo;
    this.isLogin = isLogin??this.isLogin;
    notifyListeners(); // 🔥 Notify all consumers
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
    };
  }

}
