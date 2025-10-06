import '../helpers/shared_pref_helper.dart';

class SessionTrackingHelper {
  static const String _sessionsKey = 'completed_sessions';
  static const String _recordingsKey = 'total_recordings';
  static const String _monthKey = 'current_month';

  static Future<int> getCompletedSessions() async {
    await _checkAndResetMonth();
    return await SharedPrefHelper.getInt(_sessionsKey);
  }

  static Future<int> getTotalRecordings() async {
    return await SharedPrefHelper.getInt(_recordingsKey);
  }

  static Future<void> incrementSession() async {
    await _checkAndResetMonth();
    final current = await SharedPrefHelper.getInt(_sessionsKey);
    await SharedPrefHelper.setData(_sessionsKey, current + 1);
  }

  static Future<void> incrementRecording() async {
    final current = await SharedPrefHelper.getInt(_recordingsKey);
    await SharedPrefHelper.setData(_recordingsKey, current + 1);
  }

  static Future<void> _checkAndResetMonth() async {
    final currentMonth = DateTime.now().month;
    final savedMonth = await SharedPrefHelper.getInt(_monthKey);

    if (savedMonth != currentMonth) {
      await SharedPrefHelper.setData(_sessionsKey, 0);
      await SharedPrefHelper.setData(_monthKey, currentMonth);
    }
  }
}