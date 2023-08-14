import 'package:flutter/material.dart';

import '../../../core/constants/color.dart';

class PlusIconWidget extends StatelessWidget {
  const PlusIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.blue,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.add_outlined,
        color: Colors.white,
        weight: 1000,
        size: 25,
      ),
    );
  }
}

class TabsNavigationIcon extends StatelessWidget {
  const TabsNavigationIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 0.5,
        horizontal: 6,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2.5,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: const Text(
        "1",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SearchNavigationIcon extends StatelessWidget {
  const SearchNavigationIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.search,
      size: 28,
    );
  }
}
