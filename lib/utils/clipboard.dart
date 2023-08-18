import 'package:flutter/services.dart';

final clipBoard = _ClipBoard();
class _ClipBoard {
  Future<bool> setData(dynamic data) async {
    try {
      await Clipboard.setData(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> getData() async {
    try {
      final _clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      return _clipboardData!.text ?? "";
    } catch (e) {
      return "";
    }
  }
}
