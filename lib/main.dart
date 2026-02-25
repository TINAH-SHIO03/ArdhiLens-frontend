import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'controllers/gps_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/nin_controller.dart';
import 'controllers/plot_controller.dart';
import 'controllers/questions_controller.dart';
import 'controllers/result_controller.dart';
import 'controllers/settings_controller.dart';
import 'core/api_client.dart';
import 'core/app_config.dart';
import 'core/storage_service.dart';
import 'screens/gps_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/nin_screen.dart';
import 'screens/plot_screen.dart';
import 'screens/questions_screen.dart';
import 'screens/register_screen.dart';
import 'screens/result_screen.dart';
import 'screens/settings_screen.dart';
import 'services/answers_service.dart';
import 'services/auth_service.dart';
import 'services/assistant_service.dart';
import 'services/gps_service.dart';
import 'services/history_service.dart';
import 'services/nin_service.dart';
import 'services/plot_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await StorageService.init();
  Get.put<StorageService>(storage, permanent: true);

  if (storage.baseUrl == null || storage.baseUrl!.trim().isEmpty) {
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
    AnswersService(Get.find<ApiClient>(), storage),
    permanent: true,
  );
  Get.put<AssistantService>(
    AssistantService(Get.find<ApiClient>()),
    permanent: true,
  );
  Get.put<HistoryService>(HistoryService(storage), permanent: true);

  runApp(MyApp(initialRoute: storage.isAuthenticated ? '/home' : '/login'));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.initialRoute, super.key});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LandLens Mobile',
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        scaffoldBackgroundColor: const Color(0xFFF7FAFC),
        useMaterial3: true,
      ),
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
          }),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
          }),
        ),
        GetPage(
          name: '/home',
          page: () => const HomeScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<HomeController>(() => HomeController());
          }),
        ),
        GetPage(
          name: '/settings',
          page: () => const SettingsScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<SettingsController>(() => SettingsController());
          }),
        ),
        GetPage(
          name: '/plot',
          page: () => const PlotScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<PlotController>(() => PlotController());
          }),
        ),
        GetPage(
          name: '/gps',
          page: () => const GpsScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<GpsController>(() => GpsController());
          }),
        ),
        GetPage(
          name: '/nin',
          page: () => const NinScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<NinController>(() => NinController());
          }),
        ),
        GetPage(
          name: '/questions',
          page: () => const QuestionsScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<QuestionsController>(() => QuestionsController());
          }),
        ),
        GetPage(
          name: '/result',
          page: () => const ResultScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<ResultController>(() => ResultController());
          }),
        ),
      ],
    );
  }
}
