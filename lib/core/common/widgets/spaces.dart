import 'package:flutter/material.dart';

class VerticalSpace extends StatelessWidget {
  const VerticalSpace({super.key, this.height = 10});
  final int height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.toDouble(),
    );
  }
}

class HorizontalSpace extends StatelessWidget {
  const HorizontalSpace({super.key, this.width = 10});
  final int width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.toDouble(),
    );
  }
}
