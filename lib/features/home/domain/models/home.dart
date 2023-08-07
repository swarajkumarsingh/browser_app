import 'package:freezed_annotation/freezed_annotation.dart';

part 'home.freezed.dart';
part 'home.g.dart';

@Freezed()
class Home with _$Home {
  const factory Home({
    required int userId,
    required int id,
    required String title,
    required String body,
  }) = _Home;

  factory Home.fromJson(Map<String, dynamic> json) => _$HomeFromJson(json);
}


///! Generate your model by the following
// part 'my_class.freezed.dart';
// part 'my_class.g.dart';

// @Freezed()
// class MyClass with _$MyClass {
//   const factory MyClass({
//     required int userId,
//     required int id,
//     required String title,
//     required String body,
//     @Default(true) bool isOptional,
//   }) = _MyClass;

//   factory MyClass.fromJson(Map<String, dynamic> json) => _$MyClassFromJson(json);
// }
