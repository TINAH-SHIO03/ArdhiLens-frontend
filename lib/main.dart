import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'controllers/certificate_controller.dart';
import 'controllers/document_controller.dart';
import 'controllers/gps_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/nin_controller.dart';
import 'controllers/notification_controller.dart';
import 'controllers/plot_controller.dart';
import 'controllers/questions_controller.dart';
import 'controllers/result_controller.dart';
import 'controllers/settings_controller.dart';
import 'controllers/seller_home_controller.dart';
import 'controllers/profile_controller.dart';
import 'core/api_client.dart';
import 'core/app_config.dart';
import 'core/storage_service.dart';
import 'design/app_theme.dart';
import 'locale/app_translations.dart';
import 'routes/app_routes.dart';
import 'screens/certificate_screen.dart';
import 'screens/certificate_viewer_screen.dart';
import 'screens/documents_screen.dart';
import 'screens/gps_screen.dart';
import 'screens/history_detail_screen.dart';
import 'screens/home_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/login_screen.dart';
import 'screens/nin_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/plot_screen.dart';
import 'screens/questions_screen.dart';
import 'screens/register_screen.dart';
import 'screens/result_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/seller_home_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/buyer_interests_screen.dart';
import 'controllers/buyer_interest_controller.dart';
import 'services/answers_service.dart';
import 'services/auth_service.dart';
import 'services/assistant_service.dart';
import 'services/certificate_service.dart';
import 'services/document_service.dart';
import 'services/gps_service.dart';
import 'services/history_service.dart';
import 'services/interest_service.dart';
import 'services/local_alert_service.dart';
import 'services/nin_service.dart';
import 'services/notification_service.dart';
import 'services/plot_service.dart';
import 'services/seller_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final storage = await StorageService.init();
  Get.put<StorageService>(storage, permanent: true);

  // Always use the live ArdhiLens API on physical devices / installs.
  if (AppConfig.isUnreachableOnPhysicalDevice(storage.baseUrl) ||
      storage.baseUrl == null ||
      storage.baseUrl!.contains('ngrok') ||
      storage.baseUrl!.contains('pipeline.dickens')) {
    await storage.setBaseUrl(AppConfig.apiBaseUrl);
  }

  Get.put<ApiClient>(ApiClient(storage), permanent: true);
  Get.put<AuthService>(
    AuthService(Get.find<ApiClient>(), storage),
    permanent: true,
  );
  Get.put<PlotService>(
    PlotService(Get.find<ApiClient>(), storage),
    permanent: true,
  );
  Get.put<GpsService>(GpsService(Get.find<ApiClient>()), permanent: true);
  Get.put<NinService>(
    NinService(Get.find<ApiClient>(), storage),
    permanent: true,
  );
  Get.put<AnswersService>(
    AnswersService(Get.find<ApiClient>()),
    permanent: true,
  );
  Get.put<AssistantService>(
    AssistantService(Get.find<ApiClient>()),
    permanent: true,
  );
  Get.put<HistoryService>(HistoryService(storage), permanent: true);

  final notificationService = NotificationService(Get.find<ApiClient>());
  Get.put<NotificationService>(notificationService, permanent: true);

  final certificateService = CertificateService(Get.find<ApiClient>());
  Get.put<CertificateService>(certificateService, permanent: true);

  final documentService = DocumentService(Get.find<ApiClient>());
  Get.put<DocumentService>(documentService, permanent: true);
  Get.put<SellerService>(SellerService(Get.find<ApiClient>()), permanent: true);
  Get.put<InterestService>(
    InterestService(Get.find<ApiClient>()),
    permanent: true,
  );

  final localAlerts = await LocalAlertService(
    notificationService,
    storage,
  ).init();
  Get.put<LocalAlertService>(localAlerts, permanent: true);

  Get.put<NotificationController>(
    NotificationController(notificationService),
    permanent: true,
  );

  Get.put<CertificateController>(
    CertificateController(certificateService),
    permanent: true,
  );

  final initialRoute = storage.isAuthenticated
      ? storage.homeRouteForRole()
      : Routes.landing;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.initialRoute, super.key});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<StorageService>();
    final langCode = storage.languageCode;
    final locale = langCode == 'sw' ? const Locale('sw') : const Locale('en');

    return GetMaterialApp(
      title: 'ArdhiLens',
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      theme: AppTheme.light,
      translations: AppTranslations(),
      locale: locale,
      fallbackLocale: const Locale('en'),
      getPages: [
        GetPage(name: Routes.landing, page: () => const LandingScreen()),
        GetPage(
          name: Routes.login,
          page: () => const LoginScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
          }),
        ),
        GetPage(
          name: Routes.register,
          page: () => const RegisterScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
          }),
        ),
        GetPage(
          name: Routes.home,
          page: () => const HomeScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<HomeController>(() => HomeController());
          }),
        ),
        GetPage(
          name: Routes.settings,
          page: () => const SettingsScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<SettingsController>(() => SettingsController());
          }),
        ),
        GetPage(
          name: Routes.profile,
          page: () => const ProfileScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<ProfileController>(() => ProfileController());
          }),
        ),
        GetPage(
          name: Routes.plot,
          page: () => const PlotScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<PlotController>(() => PlotController());
          }),
        ),
        GetPage(
          name: Routes.gps,
          page: () => const GpsScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<GpsController>(() => GpsController());
          }),
        ),
        GetPage(
          name: Routes.nin,
          page: () => const NinScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<NinController>(() => NinController());
          }),
        ),
        GetPage(
          name: Routes.questions,
          page: () => const QuestionsScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<QuestionsController>(() => QuestionsController());
          }),
        ),
        GetPage(
          name: Routes.result,
          page: () => const ResultScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<ResultController>(() => ResultController());
          }),
        ),
        GetPage(
          name: Routes.chat,
          page: () => const ChatScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<ResultController>(() => ResultController());
          }),
        ),
        GetPage(
          name: Routes.notifications,
          page: () => const NotificationsScreen(),
        ),
        GetPage(
          name: Routes.certificate,
          page: () => const CertificateScreen(),
        ),
        GetPage(
          name: Routes.certificateViewer,
          page: () => const CertificateViewerScreen(),
        ),
        GetPage(
          name: Routes.documents,
          page: () => const DocumentsScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<DocumentController>(
              () => DocumentController(Get.find<DocumentService>()),
            );
          }),
        ),
        GetPage(
          name: Routes.historyDetail,
          page: () => const HistoryDetailScreen(),
        ),
        GetPage(
          name: Routes.sellerHome,
          page: () => const SellerHomeScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<SellerHomeController>(() => SellerHomeController());
          }),
        ),
        GetPage(
          name: Routes.buyerInterests,
          page: () => const BuyerInterestsScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<BuyerInterestController>(() => BuyerInterestController());
          }),
        ),
        GetPage(
          name: Routes.forgotPassword,
          page: () => const ForgotPasswordScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
          }),
        ),
      ],
    );
  }
}
