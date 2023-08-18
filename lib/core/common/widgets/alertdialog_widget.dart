import 'package:browser_app/core/common/widgets/spaces.dart';
import 'package:browser_app/utils/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';

void showDialogWidget(
    context, String title, String content, String btnText, Function function) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              child: Text(btnText),
              onPressed: () {
                function();
                Navigator.of(context).pop();
              }),
          ElevatedButton(
            child: const Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showDownloadDialog(
    {BuildContext? context,
    String? title,
    String? fileName,
    String? fileSize,
    String? btnText,
    String? storageLocation,
    required Function function,
    required TextEditingController controller}) {
  showDialog(
    context: context ?? contextUtils.getContext()!,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0,
          title: Text(title ?? "Download file"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: fileName ?? "image.jpg",
                ),
              ),
              const VerticalSpace(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.filter),
                  const HorizontalSpace(width: 10),
                  Text("File Size: ${fileSize ?? 0}KB"),
                ],
              ),
              const VerticalSpace(height: 10),
              Row(
                children: [
                  const Icon(Icons.edit),
                  const HorizontalSpace(width: 10),
                  SizedBox(
                    width: 200,
                    child: Text(
                      storageLocation ??
                          "Storage: /storage/emulator/0/Download/image.jpg",
                      maxLines: 3,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => appRouter.pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => function,
              child: Text(btnText ?? "Download"),
            ),
          ],
        ),
      );
    },
  );
}
