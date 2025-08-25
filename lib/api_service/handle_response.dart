import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:survey_app/utilities/custom_dialog/CustomMessageDialog.dart';


void handleApiResponse(BuildContext context, http.Response response) {

  String message = "Something went wrong. Please try again.";

  try {
    final data = jsonDecode(response.body);
    if (data is Map && data.containsKey("message")) {
      message = data["message"].toString();
    }
  } catch (_) {

  }

  switch (response.statusCode) {
    case 400:
      message = "Bad Request: $message";
      break;
    case 401:
      message = "Unauthorized! Please login again.";
      // Optionally redirect to login
      break;
    case 403:
      message = "Forbidden! You don’t have permission.";
      break;
    case 404:
      message = "Resource not found.";
      break;
    case 500:
      message = "Internal Server Error. Try again later.";
      break;
    default:
      message = "Error ${response.statusCode}: $message";
  }

  CustomMessageDialog.show(context, title: 'Error', message: message,buttonText: 'Ok',iconColor: Colors.red,icon: Icons.warning_rounded,);

}
