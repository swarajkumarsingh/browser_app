import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';

import '../../../core/common/widgets/spaces.dart';
import '../../../utils/context.dart';

void showDownloadDialog(
    {BuildContext? context,
    String? title,
    String? fileName,
    required String fileType,
    required String fileSize,
    String? btnText,
    required String storageLocation,
    required VoidCallback function,
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
                  hintText: ".$fileType",
                ),
              ),
              const VerticalSpace(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.filter),
                  const HorizontalSpace(width: 10),
                  Text("File Size: ${fileSize}MB"),
                ],
              ),
              const VerticalSpace(height: 10),
              Row(
                children: [
                  const Icon(Icons.edit),
                  const HorizontalSpace(width: 10),
                  Text(
                    maxLines: 3,
                    softWrap: true,
                    storageLocation,
                    overflow: TextOverflow.ellipsis,
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
              onPressed: function,
              child: Text(btnText ?? "Download"),
            ),
          ],
        ),
      );
    },
  );
}
