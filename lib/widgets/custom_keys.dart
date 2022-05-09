import 'package:flutter/material.dart';

class CustomKey extends StatelessWidget {
  final double height;
  final double width;
  final String text;
  final Color backgoundColor;
  final VoidCallback onTap;
  const CustomKey(
      {Key? key,
      required this.text,
      required this.onTap,
      required this.backgoundColor,
      this.height = 45,
      this.width = 45})
      : super(key: key);

  factory CustomKey.delete({
    required VoidCallback onTap,
  }) =>
      CustomKey(
        text: 'DEL',
        onTap: onTap,
        backgoundColor: Colors.grey,
        width: 90,
      );

  factory CustomKey.enter({
    required VoidCallback onTap,
  }) =>
      CustomKey(
        text: 'ENTER',
        onTap: onTap,
        backgoundColor: Colors.lightBlue,
        width: 90,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: backgoundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      margin: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
