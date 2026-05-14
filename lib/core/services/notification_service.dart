import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidInit);
      await _plugin.initialize(initSettings);
    } catch (e) {
      debugPrint('Notification init failed: $e');
    }
  }

  Future<void> showDaily({required String title, required String body}) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'pulsefit_daily',
        'Daily Reminders',
        channelDescription: 'PulseFit daily workout & nutrition reminders',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    try {
      await _plugin.show(0, title, body, details);
    } catch (e) {
      debugPrint('Notification error: $e');
    }
  }

  Future<void> cancelAll() => _plugin.cancelAll();
}
