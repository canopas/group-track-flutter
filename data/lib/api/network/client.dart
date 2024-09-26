import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreProvider = Provider((ref) {
  final store = FirebaseFirestore.instance;
  store.settings = const Settings(persistenceEnabled: false);
  return store;
});
