import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/widgets/spaces.dart';

void showSpeechDialog({
  required WidgetRef ref,
  required BuildContext context,
  required VoidCallback? function,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      const text = "";

      return SingleChildScrollView(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0,
          title: const Center(child: Text("Google")),
          content: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 159, 203, 239),
                ),
                child: Center(
                  child: IconButton(
                    onPressed: function,
                    icon: const Icon(Icons.mic),
                  ),
                ),
              ),
              const VerticalSpace(height: 30),
              const Text(
                text == "" ? "Try saying something" : text,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
