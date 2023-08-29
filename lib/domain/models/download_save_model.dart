// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DownloadSaveModel {
  final String filename;
  final String? size;
  final String type;
  final String savedPath;
  DownloadSaveModel({
    required this.filename,
    required this.size,
    required this.type,
    required this.savedPath,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'filename': filename,
      'size': size,
      'type': type,
      'savedPath': savedPath,
    };
  }

  factory DownloadSaveModel.fromMap(Map<String, dynamic> map) {
    return DownloadSaveModel(
      filename: map['filename'] as String,
      size: map['size'] != null ? map['size'] as String : null,
      type: map['type'] as String,
      savedPath: map['savedPath'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DownloadSaveModel.fromJson(String source) => DownloadSaveModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
