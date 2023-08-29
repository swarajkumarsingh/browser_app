class DownloadModel {
  final bool success;
  final String message;
  final String url;
  final String? taskId;
  DownloadModel({
    required this.url,
    required this.success,
    required this.message,
    required this.taskId,
  });
}
