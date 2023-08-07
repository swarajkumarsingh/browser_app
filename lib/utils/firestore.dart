// import 'package:cloud_firestore/cloud_firestore.dart';

// typedef Transformer<T> = T Function(dynamic);

// class FirestoreUtils<T> {
//   static final _instance = FirebaseFirestore.instance;

//   // Retry for ~30 seconds max
//   static const _maxRetries = 5;

//   Future<T?> getDocument(
//     String collectionPath,
//     String documentPath,
//     Transformer<T> transformer, {
//     int maxRetries = _maxRetries,
//     bool cache = false, // TODO
//   }) async {
//     final collection = _instance.collection(collectionPath);
//     var sleepDuration = const Duration(seconds: 1);
//     DocumentSnapshot? snapshot;
//     for (var i = 1; i <= _maxRetries; i++) {
//       try {
//         snapshot = await collection.doc(documentPath).get();
//         break;
//       } on Exception {
//         if (i == _maxRetries) rethrow;
//         await Future.delayed(sleepDuration);
//         sleepDuration *= 2;
//       }
//     }
//     final data = snapshot?.data();
//     if (data == null) {
//       return null;
//     }
//     return transformer(data);
//   }

//   // setDocument

//   Future<void> setDocument({
//     required String collectionPath,
//     required String documentPath,
//     required Map<String, dynamic> data,
//     bool merge = false,
//   }) async {
//     final collection = _instance.collection(collectionPath);
//     return await collection.doc(documentPath).set(
//           data,
//           SetOptions(merge: merge),
//         );
//   }

//   Future<void> updateDocument({
//     required String collectionPath,
//     required String documentPath,
//     required Map<String, dynamic> data,
//   }) async {
//     final collection = _instance.collection(collectionPath);
//     return await collection.doc(documentPath).update(data);
//   }
// }
