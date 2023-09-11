import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../core/constants/color.dart';
import '../../../utils/functions/functions.dart';
import '../../../utils/text_utils.dart';
import '../../viewModel/search_screen_view_model.dart';

class SearchScreenTextfieldWidget extends StatelessWidget {
  const SearchScreenTextfieldWidget({
    super.key,
    required TextEditingController textEditingController,
    required this.ref,
    required this.context,
    required this.mounted,
  }) : _textEditingController = textEditingController;

  final TextEditingController _textEditingController;
  final WidgetRef ref;
  final BuildContext context;
  final bool mounted;

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _textEditingController,
        onChanged: (value) {},
        onSubmitted: (String _) => functions.popToWebviewScreen(
            ref: ref, context: context, url: _, mounted: mounted),
        decoration: InputDecoration(
          filled: true,
          hintMaxLines: 1,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? const Color.fromARGB(255, 83, 32, 172)
              : colors.homeTextFieldColor,
          hintText: 'Search or type Web address',
          contentPadding:
              const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
          suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => _textEditingController.clear()),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
      ),
      suggestionsCallback: (keyword) async {
        if (textUtils.isEmpty(keyword)) {
          return [];
        }
        return await functions.fetchSuggestions(keyword);
      },
      onSuggestionSelected: (String value) =>
          searchScreenViewModel.onSubmitted(ref, value),
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
    );
  }
}
