import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/api/location/location.dart';
import 'package:data/log/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/auth/auth_models.dart';
import '../api/network/client.dart';
import '../storage/app_preferences.dart';

final timelineServiceProvider = Provider((ref) => TimelineService(
  ref.read(currentUserPod),
  ref.read(firestoreProvider),
));

class TimelineService {
  final ApiUser? currentUser;
  final FirebaseFirestore _db;

  TimelineService(
      this.currentUser,
      this._db,
      );

  CollectionReference get _userRef =>
      _db.collection("users").withConverter<ApiUser>(
          fromFirestore: ApiUser.fromFireStore,
          toFirestore: (user, options) => user.toJson());

  CollectionReference _timelineRef(String userId) {
    return _userRef.doc(userId)
        .collection('user_journeys');
  }

  Future<List<ApiLocation>> getTimelineHistory(String userId, {int? from, int? to}) async {
    final timelineReference = _timelineRef(userId).where('user_id', isEqualTo: userId);
    try {
      Query query;

      if (from == null) {
        query = timelineReference.orderBy('created_at', descending: true).limit(20);
      } else if (to == null) {
        query = timelineReference
            .where('created_at', isGreaterThanOrEqualTo: from)
            .orderBy('created_at', descending: true)
            .limit(20);
      } else {
        query = timelineReference
            .where('created_at', isGreaterThanOrEqualTo: from)
            .where('created_at', isLessThanOrEqualTo: to)
            .orderBy('created_at', descending: true)
            .limit(20);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) {
        return ApiLocation.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      logger.e(
        'TimelineService: error while loading location',
        error: e
      );
      return [];
    }
  }

  Future<List<ApiLocation>> getMoreTimelineHistory(String userId, int? from) async {
    final journeyRef = FirebaseFirestore.instance.collection('journeys').where('user_id', isEqualTo: userId);

    try {
      Query query;

      if (from == null) {
        query = journeyRef.orderBy('created_at', descending: true).limit(20);
      } else {
        query = journeyRef
            .orderBy('created_at', descending: true)
            .where('created_at', isLessThan: from)
            .limit(20);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) {
        return ApiLocation.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      logger.e(
          'TimelineService: error while loading more location',
          error: e
      );
      return [];
    }
  }
}
