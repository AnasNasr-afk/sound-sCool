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
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings =
    InitializationSettings(android: androidInit, iOS: iosInit);
    await _plugin.initialize(initSettings);
  }

  /// Request permission from user
  static Future<bool> requestPermission() async {
    bool result = false;

    if (Platform.isAndroid) {
      final statusBefore = await Permission.notification.status;
      final res = await Permission.notification.request();
      result = res.isGranted;
    } else if (Platform.isIOS) {
      result = await _plugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    } else {
    }

    return result;
  }

  /// Get current permission status
  static Future<PermissionStatus> getPermissionStatus() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      return status;
    } else if (Platform.isIOS) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions() ??
          false;
      return granted
          ? PermissionStatus.granted
          : PermissionStatus.denied;
    } else {
      return PermissionStatus.denied;
    }
  }

  static Future<bool> isPermissionGranted() async {
    final status = await getPermissionStatus();
    return status.isGranted;
  }

  /// Save preference
  static Future<void> enableNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationPrefKey, true);
  }

  static Future<void> disableNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationPrefKey, false);
  }

  static Future<bool> isNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getBool(_notificationPrefKey) ?? true;
    return val;
  }

  static Future<bool> initializeNotificationStatus() async {
    final userPreference = await isNotificationsEnabled();
    final systemPermission = await isPermissionGranted();
    final active = userPreference && systemPermission;
    return active;
  }

  static Future<bool> enableNotificationsFlow() async {
    final isGranted = await requestPermission();

    if (isGranted) {
      await enableNotifications();
      return true;
    } else {
      if (await Permission.notification.isPermanentlyDenied) {
        await openAppSettings();
      }
      await disableNotifications();
      return false;
    }
  }

  static Future<void> disableNotificationsFlow() async {
    await disableNotifications();
  }

  static Future<void> resetNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationPrefKey);
  }

  static Future<Map<String, bool>> getNotificationStatus() async {
    final isSystemGranted = await isPermissionGranted();
    final isUserEnabled = await isNotificationsEnabled();
    final result = {
      'system_permission': isSystemGranted,
      'user_preference': isUserEnabled,
      'notifications_active': isSystemGranted && isUserEnabled,
    };
    return result;
  }
}
