import 'package:material_ui/material_ui.dart';
import 'repositories/sqlite_sleep_repository.dart';
import 'repositories/sqlite_preferences_repository.dart';
import 'services/local_notification_service.dart';
import 'state/sleep_provider.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/home_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sleepRepo = SqliteSleepRepository();
  final prefsRepo = SqlitePreferencesRepository();
  final notificationService = LocalNotificationService();

  try {
    await notificationService.initialize();
  } catch (_) {}

  final provider = SleepProvider(
    repository: sleepRepo,
    preferencesRepository: prefsRepo,
    notificationService: notificationService,
  );

  await provider.load();

  runApp(SleepLogApp(provider: provider));
}

class SleepLogApp extends StatelessWidget {
  final SleepProvider provider;

  const SleepLogApp({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SleepLog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: HomeShell(provider: provider),
    );
  }
}
