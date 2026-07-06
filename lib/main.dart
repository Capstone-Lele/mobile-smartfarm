import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/core/utils/app_session.dart';
import 'package:budidaya_lele_mobile/common/services/fcm_service.dart';
import 'package:budidaya_lele_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FCMService.init();
  await dotenv.load(fileName: ".env");
  await AppSession.init();
  await initializeDateFormatting('id_ID', null);
  runApp(const ProviderScope(child: OverlaySupport(child: MyApp())));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    // Sinkronkan token FCM terkini ke backend setiap app dibuka (bila sudah
    // login). Sesi login persisten, sehingga tanpa ini token yang dirotasi
    // saat app mati tidak pernah terdaftar ulang dan token lama "nyangkut".
    _syncFcmToken();

    // Daftarkan ulang token FCM ke backend setiap kali token dirotasi selagi
    // app hidup. Hanya dijalankan saat user sudah login.
    FCMService.listenTokenRefresh((token) => _registerToken(token));
  }

  Future<void> _syncFcmToken() async {
    if (!AppSession.isUserLoggedIn) return;
    final token = await FCMService.getToken();
    if (token == null) return;
    await _registerToken(token);
  }

  Future<void> _registerToken(String token) async {
    if (!AppSession.isUserLoggedIn) return;
    final deviceInfo = await FCMService.getDeviceInfo();
    await ref
        .read(registerTokenUseCaseProvider)
        .execute(
          token,
          deviceInfo['name'] ?? 'Unknown Device',
          deviceInfo['type'] ?? 'android',
        );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budidaya Lele',
      navigatorKey: AppRoutes.navigatorKey,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        textTheme: GoogleFonts.onestTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
            textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 15)),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
    );
  }
}
