import 'package:flutter/material.dart';

/// A custom widget that displays a cover tile.
class CoverTile extends StatelessWidget {
  /// Creates a [CoverTile].
  ///
  /// The [child] parameter specifies the [Widget] to be used as the cover.
  const CoverTile({Key? key, required this.child}) : super(key: key);

  /// The [Widget] to be used as the cover.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: child,
    );
  }
}
