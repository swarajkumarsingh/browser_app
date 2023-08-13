import 'package:flutter/material.dart';

class SuggestionListTile extends StatelessWidget {
  final String result;
  final String redirectUrl;
  const SuggestionListTile({
    super.key,
    required this.result,
    required this.redirectUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.all(8),
      leading: const Icon(Icons.search_outlined, size: 35),
      title: Text(result),
      trailing: const Icon(Icons.north_west_outlined, size: 30),
    );
  }
}
