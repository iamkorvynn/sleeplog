import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/models/sleep_settings.dart';
import 'package:sleeplog/models/sleep_stats.dart';
import 'package:sleeplog/repositories/sleep_repository.dart';
import 'package:sleeplog/repositories/preferences_repository.dart';
import 'package:sleeplog/services/notification_service.dart';
import 'package:sleeplog/services/mock_notification_service.dart';
import 'package:sleeplog/utils/sleep_calculator.dart';
import 'package:sleeplog/utils/export_importer.dart';

class SleepProvider extends ChangeNotifier {
  final SleepRepository repository;
  final PreferencesRepository preferencesRepository;
  final NotificationService notificationService;

  List<SleepNight> _nights = [];
  SleepSettings _settings = const SleepSettings.defaults();
  SleepStats _stats = const SleepStats.empty();
  bool _isLoading = true;

  SleepProvider({
    required this.repository,
    required this.preferencesRepository,
    NotificationService? notificationService,
  })  : notificationService = notificationService ?? MockNotificationService();

  List<SleepNight> get nights => List.unmodifiable(_nights);
  SleepSettings get settings => _settings;
  SleepStats get stats => _stats;
  bool get isLoading => _isLoading;
  bool get is24Hour => _settings.use24HourFormat;
  SleepNight? get lastNight => _nights.isEmpty ? null : _nights.first;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    await repository.initialize();
    _settings = await preferencesRepository.getSettings();
    _nights = await repository.getAllNights();
    _recalculateStats();

    await notificationService.scheduleBedtimeReminder(_settings);
    await notificationService.scheduleMorningSummary(_settings);

    _isLoading = false;
    notifyListeners();
  }

  void _recalculateStats() {
    _stats = SleepCalculator.computeAllStats(_nights, _settings);
  }

  Future<void> addNight(SleepNight night) async {
    await repository.saveNight(night);
    _nights = await repository.getAllNights();
    _recalculateStats();
    notifyListeners();
  }

  Future<void> updateNight(SleepNight night) async {
    await repository.updateNight(night);
    _nights = await repository.getAllNights();
    _recalculateStats();
    notifyListeners();
  }

  Future<void> deleteNight(String id) async {
    await repository.deleteNight(id);
    _nights = await repository.getAllNights();
    _recalculateStats();
    notifyListeners();
  }

  Future<void> deleteAllNights() async {
    await repository.deleteAllNights();
    _nights = [];
    _recalculateStats();
    notifyListeners();
  }

  Future<void> updateSettings(SleepSettings newSettings) async {
    _settings = newSettings;
    await preferencesRepository.saveSettings(newSettings);
    _recalculateStats();

    await notificationService.scheduleBedtimeReminder(newSettings);
    await notificationService.scheduleMorningSummary(newSettings);
    notifyListeners();
  }

  String exportJson() {
    return ExportImporter.exportToJson(_nights, _settings);
  }

  String exportCsv() {
    return ExportImporter.exportToCsv(_nights, _settings.goalHours);
  }

  Future<int> importJson(String jsonString) async {
    final result = ExportImporter.importFromJson(jsonString);
    if (result.settings != null) {
      await updateSettings(result.settings!);
    }
    await repository.importNights(result.nights);
    _nights = await repository.getAllNights();
    _recalculateStats();
    notifyListeners();
    return result.count;
  }

  Future<int> importCsv(String csvString) async {
    final result = ExportImporter.importFromCsv(csvString);
    await repository.importNights(result.nights);
    _nights = await repository.getAllNights();
    _recalculateStats();
    notifyListeners();
    return result.count;
  }
}}
