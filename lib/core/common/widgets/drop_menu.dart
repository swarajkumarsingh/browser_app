import '../../../utils/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DropMenu extends ConsumerWidget {
  const DropMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: PopupMenuButton(
        color: Colors.white,
        itemBuilder: (context) => [
          PopupMenuItem(
            child: GestureDetector(
              onTap: () => functions.navigateToWebviewScreen(
                  ref: ref,
                  url: "https://github.com/swarajkumarsingh",
                  mounted: true),
              child: const Text("Github"),
            ),
          ),
          PopupMenuItem(
            child: GestureDetector(
              onTap: () => functions.navigateToWebviewScreen(
                  ref: ref,
                  url: "https://instagram.com/swaraj_singh_4444",
                  mounted: true),
              child: const Text("Instagram"),
            ),
          ),
          PopupMenuItem(
            child: GestureDetector(
              onTap: () => functions.navigateToWebviewScreen(
                  ref: ref,
                  url:
                      "https://www.linkedin.com/in/swaraj-kumar-singh-a65ab922a/",
                  mounted: true),
              child: const Text("Linkedin"),
            ),
          ),
        ],
        child: const Icon(
          Icons.more_vert_outlined,
          size: 25,
          color: Colors.black,
        ),
      ),
    );
  }
}
