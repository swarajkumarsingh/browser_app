import 'package:browser_app/core/common/widgets/spaces.dart';
import 'package:browser_app/utils/speech_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/provider/state_providers.dart';

void showSpeechDialog({
  required WidgetRef ref,
  required BuildContext context,
  required VoidCallback? function,
}) {
  speechService.openSpeechDialog(ref);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      final text = ref.watch(transcribedTextProvider);
      final showDialog = ref.watch(showSpeechDialogProvider);

      return showDialog
          ? Center(
              child: SingleChildScrollView(
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
                      Text(
                        text == "" ? "Try saying something" : text,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox();
    },
  );
}
