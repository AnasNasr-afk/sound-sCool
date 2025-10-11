import 'package:cloud_firestore/cloud_firestore.dart';

class UserLimitsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== GET USER DAILY LIMITS ====================
  Future<Map<String, dynamic>> getUserLimits(String userId) async {
    final today = _getTodayDate();

    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('daily_limits')
        .doc(today);

    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'date': today,
        'recordings': 0,
        'generations': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return {'recordings': 0, 'generations': 0};
    }

    return {
      'recordings': doc.data()?['recordings'] ?? 0,
      'generations': doc.data()?['generations'] ?? 0,
    };
  }

  // ==================== INCREMENT RECORDING ====================
  Future<int> incrementRecording(String userId) async {
    final today = _getTodayDate();

    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('daily_limits')
        .doc(today);

    await docRef.set({
      'date': today,
      'recordings': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final updated = await docRef.get();
    return updated.data()?['recordings'] ?? 0;
  }

  // ==================== INCREMENT GENERATION ====================
  Future<int> incrementGeneration(String userId) async {
    final today = _getTodayDate();

    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('daily_limits')
        .doc(today);

    await docRef.set({
      'date': today,
      'generations': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final updated = await docRef.get();
    return updated.data()?['generations'] ?? 0;
  }

  // ==================== INCREMENT SESSION (NEW!) ====================
  Future<int> incrementSession(String userId) async {
    final monthId = _getMonthId(); // e.g., "2025-01"

    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('monthly_sessions')
        .doc(monthId);

    await docRef.set({
      'month': monthId,
      'sessions': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final updated = await docRef.get();
    return updated.data()?['sessions'] ?? 0;
  }

  // ==================== GET MONTHLY SESSION COUNT ====================
  Future<int> getMonthlySessionCount(String userId) async {
    final monthId = _getMonthId();

    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('monthly_sessions')
        .doc(monthId);

    final doc = await docRef.get();

    if (!doc.exists) return 0;
    return doc.data()?['sessions'] ?? 0;
  }

  // ==================== CHECK LIMITS ====================
  Future<bool> canRecord(String userId) async {
    final limits = await getUserLimits(userId);
    return limits['recordings'] < 7;
  }

  Future<bool> canGenerate(String userId) async {
    final limits = await getUserLimits(userId);
    return limits['generations'] < 10;
  }

  // ==================== HELPER METHODS ====================
  String _getTodayDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  String _getMonthId() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}'; // "2025-01"
  }
}