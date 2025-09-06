import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Widget BuildDropdown(
    String label,
    List<DropdownMenuItem<String>>? data, {
      String? value,
      Function(String? value)? onChange,
    }) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            hint: Text("Select $label"),
            items: [
              DropdownMenuItem(
                value: null,
                child: Text('Select $label'),
              ),
              ...data??[],
            ],
            onChanged: onChange,
          ),
        ),
      ],
    ),
  );
}