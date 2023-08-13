import 'package:flutter/material.dart';

import '../../../data/local/search_suggestions.dart';
import 'search_suggestion_list_tile.dart';

class ShowSuggestionsDialog extends StatelessWidget {
  final String value;
  const ShowSuggestionsDialog({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      height: 370,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 0.1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: ListView(
        children: [
          Text(
            "Search Result for $value on web",
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          ...fakeSearchSuggestions.map(
            (e) => SuggestionListTile(
                result: e.result, redirectUrl: e.redirectUrl),
          ),
        ],
      ),
    );
  }
}
