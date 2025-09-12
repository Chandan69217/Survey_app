import 'package:flutter/cupertino.dart';


class LoginUser with ChangeNotifier{

  LoginUser();

  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  Data? status;
  String? photo;
  dynamic role;
  ConstituencyName? constituencyName;
  Data? state;
  Data? district;
  Data? city;
  String? pinCode;
  String? address;
  Data? appName;


  LoginUser.fromJson(Map<String, dynamic> json){
    this.id = json["id"];
    this.firstName = json["first_name"];
    this.lastName = json["last_name"];
    this.email = json["email"];
    this.phoneNumber = json["phone_number"];
    this.status = json["status"] == null ? null : Data.fromJson(json["status"]);
    this.photo = json["photo"];
    this.role = json["role"];
    this.constituencyName = json["constituency_name"] == null ? null : ConstituencyName.fromJson(json["constituency_name"]);
    this.state = json["state"] == null ? null : Data.fromJson(json["state"]);
    this.district = json["district"] == null ? null : Data.fromJson(json["district"]);
    this.city = json["city"] == null ? null : Data.fromJson(json["city"]);
    this.pinCode = json["pin_code"];
    this.address = json["address"];
    this.appName = json["app_name"] == null ? null : Data.fromJson(json["app_name"]);
  }


  void update(Map<String, dynamic> json) {
    this.id = json["id"];
    this.firstName = json["first_name"];
    this.lastName = json["last_name"];
    this.email = json["email"];
    this.phoneNumber = json["phone_number"];
    this.status = json["status"] == null ? null : Data.fromJson(json["status"]);
    this.photo = json["photo"];
    this.role = json["role"];
    this.constituencyName = json["constituency_name"] == null
        ? null
        : ConstituencyName.fromJson(json["constituency_name"]);
    this.state = json["state"] == null ? null : Data.fromJson(json["state"]);
    this.district = json["district"] == null ? null : Data.fromJson(json["district"]);
    this.city = json["city"] == null ? null : Data.fromJson(json["city"]);
    this.pinCode = json["pin_code"];
    this.address = json["address"];
    this.appName = json["app_name"] == null ? null : Data.fromJson(json["app_name"]);
    notifyListeners();
  }


}


class Data {
  Data({
    required this.id,
    required this.name,
  });

  final int? id;
  final String? name;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["id"],
      name: json["name"],
    );
  }

}

class ConstituencyName {
  ConstituencyName({
    required this.id,
    required this.name,
    required this.state,
    required this.status,
    required this.category,
  });

  final int? id;
  final String? name;
  final String? state;
  final bool? status;
  final Data? category;

  factory ConstituencyName.fromJson(Map<String, dynamic> json){
    return ConstituencyName(
      id: json["id"],
      name: json["name"],
      state: json["state"],
      status: json["status"],
      category: json["category"] == null ? null : Data.fromJson(json["category"]),
    );
  }

}
