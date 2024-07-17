import 'package:flutter/material.dart';

class BoldText extends StatelessWidget {
  final String text;

  const BoldText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }
}
