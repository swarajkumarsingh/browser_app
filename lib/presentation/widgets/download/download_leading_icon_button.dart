import 'package:flutter/material.dart';

import '../../../core/constants/color.dart';

class DownloadScreenLeadingIconButton extends StatelessWidget {
  const DownloadScreenLeadingIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_rounded,
        color: colors.black,
        size: 35,
      ),
      onPressed: () => Navigator.pop(context),
    );
  }
}
