import '../helpers/shared_pref_helper.dart';

class SessionTrackingHelper {
  static const String _sessionsKey = 'completed_sessions';
  static const String _monthKey = 'current_month';

  // ===== DAILY RECORDINGS (Resets every day) =====
  // static Future<void> _checkAndResetDaily() async {
  //   final today = DateTime.now().toString().split(' ')[0]; // YYYY-MM-DD
  //   final lastResetDate = await SharedPrefHelper.getString(_lastResetDateKey);
  //
  //   if (lastResetDate != today) {
  //     // New day - reset daily recordings
  //     await SharedPrefHelper.setData(_dailyRecordingsKey, 0);
  //     await SharedPrefHelper.setData(_lastResetDateKey, today);
  //   }
  // }
  //
  // static Future<int> getDailyRecordings() async {
  //   await _checkAndResetDaily();
  //   return await SharedPrefHelper.getInt(_dailyRecordingsKey);
  // }
  //
  // static Future<void> incrementRecording() async {
  //   await _checkAndResetDaily();
  //   final current = await SharedPrefHelper.getInt(_dailyRecordingsKey);
  //   await SharedPrefHelper.setData(_dailyRecordingsKey, current + 1);
  // }
  //
  // static Future<bool> isDailyLimitReached() async {
  //   final count = await getDailyRecordings();
  //   return count >= 7;
  // }

  // ===== MONTHLY SESSIONS (Resets every month) =====
  static Future<int> getCompletedSessions() async {
    await _checkAndResetMonth();
    return await SharedPrefHelper.getInt(_sessionsKey);
  }

  static Future<void> incrementSession() async {
    await _checkAndResetMonth();
    final current = await SharedPrefHelper.getInt(_sessionsKey);
    await SharedPrefHelper.setData(_sessionsKey, current + 1);
  }

  static Future<void> _checkAndResetMonth() async {
    final currentMonth = DateTime.now().month;
    final savedMonth = await SharedPrefHelper.getInt(_monthKey);

    if (savedMonth != currentMonth) {
      await SharedPrefHelper.setData(_sessionsKey, 0);
      await SharedPrefHelper.setData(_monthKey, currentMonth);
    }
  }

  // ===== TOTAL RECORDINGS (All-time, never resets) =====
  // static Future<int> getTotalRecordings() async {
  //   return await SharedPrefHelper.getInt(_recordingsKey);
  // }
}