// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DownloadingModel {
  final String taskId;
  final String filename;
  final String? size;
  final String url;
  int progress;
  DownloadingModel({
    required this.size,
    required this.filename,
    required this.progress,
    required this.taskId,
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taskId': taskId,
      'filename': filename,
      'size': size,
      'url': url,
      'progress': progress,
    };
  }

  factory DownloadingModel.fromMap(Map<String, dynamic> map) {
    return DownloadingModel(
      taskId: map['taskId'] as String,
      filename: map['filename'] as String,
      size: map['size'] != null ? map['size'] as String : null,
      url: map['url'] as String,
      progress: map['progress'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory DownloadingModel.fromJson(String source) =>
      DownloadingModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
