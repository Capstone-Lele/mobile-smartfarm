import 'dart:io';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class FCMService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel_v3',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  static Future<void> init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print(
      'FCM DEBUG: User granted permission: ${settings.authorizationStatus}',
    );

    // Background messaging handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Initialise the FlutterLocalNotificationsPlugin package.
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotifications.initialize(
      initializationSettings,
      // Notifikasi lokal (banner saat app foreground) di-tap -> buka halaman
      // list notifikasi, sama seperti tap notifikasi dari system tray.
      onDidReceiveNotificationResponse: (details) {
        AppRoutes.navigatorKey.currentState?.pushNamed(AppRoutes.notification);
      },
    );

    // Create the channel on Android
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // Foreground messaging handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        // Show Local Notification for Sound and Banner
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          _localNotifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _channel.id,
                _channel.name,
                channelDescription: _channel.description,
                icon: '@mipmap/ic_launcher',
                importance: Importance.max,
                priority: Priority.max,
                playSound: true,
              ),
            ),
          );
        }
      }
    });

    // Handle when app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppRoutes.navigatorKey.currentState?.pushNamed(AppRoutes.notification);
    });

    // Handle initial message if app was closed
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        AppRoutes.navigatorKey.currentState?.pushNamed(AppRoutes.notification);
      });
    }
  }

  static Future<String?> getToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      // Request permission for iOS/Web if needed
      await messaging.requestPermission(alert: true, badge: true, sound: true);
      String? token = await messaging.getToken();
      return token;
    } catch (e) {
      return null;
    }
  }

  // Memaksa membuat token FCM baru: hapus token saat ini (langsung invalid di
  // Firebase) lalu ambil token baru yang pasti segar. Dipakai saat startup
  // sebagai workaround sementara untuk token yang "nyangkut" (mati di sisi
  // Firebase tapi masih di-cache SDK di device).
  static Future<String?> regenerateToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.deleteToken();
      final token = await messaging.getToken();
      return token;
    } catch (e) {
      return null;
    }
  }

  /// FCM dapat merotasi token kapan saja (setelah jangka waktu tertentu,
  /// reinstall, clear data, restore, dll).
  /// [onRefresh] dipanggil dengan token baru agar bisa didaftarkan ulang.
  static void listenTokenRefresh(
    Future<void> Function(String token) onRefresh,
  ) {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      try {
        await onRefresh(token);
      } catch (_) {}
    });
  }

  static Future<Map<String, String>> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName = 'Unknown Device';
    String deviceType = Platform.isAndroid ? 'android' : 'ios';

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = '${androidInfo.manufacturer} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.name;
      }
    } catch (e) {
      // Fallback to defaults
    }

    return {'name': deviceName, 'type': deviceType};
  }
}
