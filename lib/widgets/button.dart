import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? text;

  const MyButton({super.key, required this.onTap, this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFA1045A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: text != null
            ? Text(text!, style: TextStyle(color: Colors.white, fontSize: 18))
            : Icon(
                Icons.arrow_circle_right_outlined,
                size: 30,
                color: Colors.white,
              ),
      ),
    );
  }
}
