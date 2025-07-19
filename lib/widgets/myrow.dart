import 'package:flutter/material.dart';

class MyRow extends StatelessWidget {
  const MyRow({super.key, required this.text, required this.textButton});

  final String text;
  final TextButton textButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontFamily: "bold",
            fontSize: 14,
          ),
        ),
        textButton,
      ],
    );
  }
}
