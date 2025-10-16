import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationHelper {
  NotificationHelper._();

  static const String _notificationPrefKey = 'notifications_enabled';
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  /// Initialize local notifications
  static Future<void> initialize() async {
    print('🔧 [NotificationHelper] Initializing notifications...');
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings =
    InitializationSettings(android: androidInit, iOS: iosInit);
    await _plugin.initialize(initSettings);
    print('✅ [NotificationHelper] Initialization complete');
  }

  /// Request permission from user
  static Future<bool> requestPermission() async {
    print('🔍 [NotificationHelper] Requesting permission...');
    bool result = false;

    if (Platform.isAndroid) {
      final statusBefore = await Permission.notification.status;
      print('📱 [Android] Permission before request: $statusBefore');
      final res = await Permission.notification.request();
      print('📱 [Android] Permission after request: $res');
      result = res.isGranted;
    } else if (Platform.isIOS) {
      print('🍏 [iOS] Requesting permissions through local_notifications...');
      result = await _plugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
      print('🍏 [iOS] Permission result: $result');
    } else {
      print('❌ [NotificationHelper] Unsupported platform');
    }

    return result;
  }

  /// Get current permission status
  static Future<PermissionStatus> getPermissionStatus() async {
    print('🧠 [NotificationHelper] Checking permission status...');
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      print('📱 [Android] Permission status: $status');
      return status;
    } else if (Platform.isIOS) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions() ??
          false;
      print('🍏 [iOS] Permission status: ${granted ? "granted" : "denied"}');
      return granted
          ? PermissionStatus.granted
          : PermissionStatus.denied;
    } else {
      print('❌ [NotificationHelper] Unsupported platform');
      return PermissionStatus.denied;
    }
  }

  static Future<bool> isPermissionGranted() async {
    final status = await getPermissionStatus();
    print('🔐 [NotificationHelper] Permission granted: ${status.isGranted}');
    return status.isGranted;
  }

  /// Save preference
  static Future<void> enableNotifications() async {
    print('💾 [NotificationHelper] Saving preference: ENABLED');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationPrefKey, true);
  }

  static Future<void> disableNotifications() async {
    print('💾 [NotificationHelper] Saving preference: DISABLED');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationPrefKey, false);
  }

  static Future<bool> isNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getBool(_notificationPrefKey) ?? true;
    print('🧾 [NotificationHelper] User preference: $val');
    return val;
  }

  static Future<bool> initializeNotificationStatus() async {
    print('🚀 [NotificationHelper] Initializing notification status...');
    final userPreference = await isNotificationsEnabled();
    final systemPermission = await isPermissionGranted();
    final active = userPreference && systemPermission;
    print(
        '📊 [NotificationHelper] Init result => userPref: $userPreference | systemPerm: $systemPermission | active: $active');
    return active;
  }

  static Future<bool> enableNotificationsFlow() async {
    print('⚙️ [NotificationHelper] Starting enableNotificationsFlow...');
    final isGranted = await requestPermission();
    print('🔎 [NotificationHelper] Permission result: $isGranted');

    if (isGranted) {
      await enableNotifications();
      print('✅ [NotificationHelper] Notifications enabled');
      return true;
    } else {
      if (await Permission.notification.isPermanentlyDenied) {
        print('🚫 [NotificationHelper] Permission permanently denied. Opening settings...');
        await openAppSettings();
      }
      await disableNotifications();
      print('❌ [NotificationHelper] Notifications disabled due to denial');
      return false;
    }
  }

  static Future<void> disableNotificationsFlow() async {
    print('🛑 [NotificationHelper] Disabling notifications...');
    await disableNotifications();
  }

  static Future<void> resetNotificationPreference() async {
    print('🔄 [NotificationHelper] Resetting preferences...');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationPrefKey);
  }

  static Future<Map<String, bool>> getNotificationStatus() async {
    print('📈 [NotificationHelper] Gathering notification status...');
    final isSystemGranted = await isPermissionGranted();
    final isUserEnabled = await isNotificationsEnabled();
    final result = {
      'system_permission': isSystemGranted,
      'user_preference': isUserEnabled,
      'notifications_active': isSystemGranted && isUserEnabled,
    };
    print('📊 [NotificationHelper] Status: $result');
    return result;
  }
}
