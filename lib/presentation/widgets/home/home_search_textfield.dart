import '../../../core/constants/color.dart';
import '../../view/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeSearchTextField extends StatelessWidget {
  const HomeSearchTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: InkWell(
        onTap: () => appRouter.push(const SearchScreen()),
        child: TextField(
          readOnly: true,
          enabled: false,
          canRequestFocus: false,
          keyboardType: TextInputType.none,
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.homeTextFieldColor,
            hintText: 'Search or Enter address',
            prefixIcon: const Icon(FontAwesomeIcons.google),
            contentPadding: const EdgeInsets.symmetric(vertical: 6.0),
            suffixIcon: InkWell(
                onTap: () => logger.error("Mic button pressed"),
                child: const Icon(Icons.mic)),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                Radius.circular(32),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
