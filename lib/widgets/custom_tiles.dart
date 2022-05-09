import 'package:flutter/material.dart';

class CustomTileWidget extends StatelessWidget {
  const CustomTileWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Center(
        child: Text(''),
      ),
    );
  }
}
