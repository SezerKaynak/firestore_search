library firestore_search;

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService<T> {
  final String? collectionName;
  final String? searchBy;
  final List Function(QuerySnapshot)? dataListFromSnapshot;
  final int? limitOfRetrievedData;

  FirestoreService(
      {this.collectionName,
      this.searchBy,
      this.dataListFromSnapshot,
      this.limitOfRetrievedData});
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Stream<List> searchData(String query) {
    final collectionReference = firebaseFirestore.collection(collectionName!);
    return query.isEmpty
        ? Stream.empty()
        : collectionReference
            .orderBy('${searchBy!.toLowerCase()}', descending: false)
            .where('${searchBy!.toLowerCase()}', isGreaterThanOrEqualTo: query)
            .where('${searchBy!.toLowerCase()}', isLessThan: query + 'z')
            .limit(limitOfRetrievedData!)
            .snapshots()
            .map(dataListFromSnapshot!);
  }
}
