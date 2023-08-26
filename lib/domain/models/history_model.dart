import 'dart:convert';

class HistoryModel {
  final String prompt;
  final String url;
  final DateTime time;
  HistoryModel({
    required this.prompt,
    required this.url,
    required this.time,
  });

  HistoryModel copyWith({
    String? prompt,
    String? url,
    DateTime? time,
  }) {
    return HistoryModel(
      prompt: prompt ?? this.prompt,
      url: url ?? this.url,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> _toMap() {
    return <String, dynamic>{
      'prompt': prompt,
      'url': url,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      prompt: map['prompt'] as String,
      url: map['url'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
    );
  }

  String toJson() => json.encode(_toMap());
  String toMap() => json.encode(_toMap());

  factory HistoryModel.fromJson(String source) =>
      HistoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'HistoryModel(prompt: $prompt, url: $url, time: $time)';
}
