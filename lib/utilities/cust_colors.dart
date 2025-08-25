import 'dart:ui';

import 'package:flutter/material.dart';

class CustColors{
  CustColors._();
  static const Color background1 = Color(0xFF123763);
  static final Color background2 = Colors.grey[300]??Colors.grey;
  static const Color soft_indigo = Color(0xFF5f6ac4);
  static const Color soft_indigo100 = Color(0xFF8a90d6);
  static const Color grey100 = Color(0xFFe5e7eb);
  static const Color grey200 = Color(0xFFf9f9fb);
  static const LinearGradient background_gradient = LinearGradient(
    colors: [
      const Color(0xFF123763), // base deep blue
      const Color(0xFF3A5BA0), // medium blue
      const Color(0xFF5DADE2), // light sky blue
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}