import 'package:flutter_test/flutter_test.dart';
import 'package:sleeplog/models/sleep_settings.dart';
import 'package:sleeplog/services/mock_notification_service.dart';

void main() {
  group('NotificationService Tests', () {
    late MockNotificationService service;

    setUp(() async {
      service = MockNotificationService();
      await service.initialize();
    });

    test('requestPermissions returns true', () async {
      expect(await service.requestPermissions(), isTrue);
    });

    for (int offset in [15, 30, 45, 60]) {
      test('scheduleBedtimeReminder with offset $offset min', () async {
        final s = SleepSettings(bedtimeReminderMinutesBefore: offset, targetBedtimeHour: 23, targetBedtimeMinute: 0);
        await service.scheduleBedtimeReminder(s);
        expect(service.scheduledItems.length, 1);
        final item = service.scheduledItems.first;
        expect(item.id, 1001);
      });
    }

    test('scheduleMorningSummary schedules notification', () async {
      const s = SleepSettings(morningSummaryHour: 8, morningSummaryMinute: 30);
      await service.scheduleMorningSummary(s);
      expect(service.scheduledItems.any((i) => i.id == 1002), isTrue);
    });

      });
}
