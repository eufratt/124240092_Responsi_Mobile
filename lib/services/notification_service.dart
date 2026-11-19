import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Notifikasi lokal (muncul di status bar tanpa server).
class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  // Dipanggil sekali di main().
  static Future<void> init() async {
    // Ikon kecil notifikasi memakai ikon launcher aplikasi.
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(const InitializationSettings(android: android));
    // Android 13+ butuh izin POST_NOTIFICATIONS saat runtime.
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // Tampilkan notifikasi. ID dari waktu (detik) supaya tiap notifikasi unik
  // dan tidak saling menimpa.
  static Future<void> show(String title, String body) => _plugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails('keripikroll', 'Keripikroll',
              importance: Importance.high, priority: Priority.high),
        ),
      );
}
