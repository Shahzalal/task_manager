import 'package:flutter/material.dart';
import 'package:taskmanager/widgets/textstyle.dart';

InputDecoration textFieldDecoration(String hinttext) => InputDecoration(
  hintText: hinttext,
  hintStyle: subText,
  fillColor: Colors.white,
  filled: true,
  border: OutlineInputBorder(borderSide: BorderSide.none),
);
