import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/state/sleep_provider.dart';
import 'package:sleeplog/ui/theme/app_colors.dart';
import 'package:sleeplog/utils/time_formatter.dart';
import 'package:sleeplog/ui/widgets/confirm_dialog.dart';

class SettingsScreen extends StatelessWidget {
  final SleepProvider provider;

  const SettingsScreen({super.key, required this.provider});

  Future<void> _updateBedtime(BuildContext context) async {
    final s = provider.settings;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: s.targetBedtimeHour, minute: s.targetBedtimeMinute),
    );
    if (picked != null) {
      await provider.updateSettings(s.copyWith(
        targetBedtimeHour: picked.hour,
        targetBedtimeMinute: picked.minute,
      ));
    }
  }

  Future<void> _updateMorningSummaryTime(BuildContext context) async {
    final s = provider.settings;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: s.morningSummaryHour, minute: s.morningSummaryMinute),
    );
    if (picked != null) {
      await provider.updateSettings(s.copyWith(
        morningSummaryHour: picked.hour,
        morningSummaryMinute: picked.minute,
      ));
    }
  }

  void _showExportDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Export Sleep Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Export your logs to backup or transfer your sleep data.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.code_rounded, color: AppColors.primaryLight),
              title: const Text('Export as JSON'),
              subtitle: const Text('Complete backup with settings'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: AppColors.darkCard,
              onTap: () {
                Navigator.of(ctx).pop();
                final jsonStr = provider.exportJson();
                _showRawDataModal(context, 'JSON Backup', jsonStr);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.table_chart_rounded, color: AppColors.secondary),
              title: const Text('Export as CSV'),
              subtitle: const Text('Spreadsheet compatible format'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: AppColors.darkCard,
              onTap: () {
                Navigator.of(ctx).pop();
                final csvStr = provider.exportCsv();
                _showRawDataModal(context, 'CSV Export', csvStr);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRawDataModal(BuildContext context, String title, String data) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(
              data,
              style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Import Sleep Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paste JSON or CSV sleep data below to import past nights.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textController,
              maxLines: 6,
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              decoration: const InputDecoration(
                hintText: 'Paste exported JSON or CSV here...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final raw = textController.text.trim();
              if (raw.isEmpty) return;
              try {
                int imported;
                if (raw.startsWith('{')) {
                  imported = await provider.importJson(raw);
                } else {
                  imported = await provider.importCsv(raw);
                }
                if (ctx.mounted) Navigator.of(ctx).pop();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully imported $imported sleep logs!')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Import failed: $e')),
                  );
                }
              }
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClearData(BuildContext context) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Clear All Data',
      message: 'Are you sure you want to delete all sleep records and reset the app? This cannot be undone.',
      confirmText: 'Clear All',
      isDestructive: true,
    );
    if (confirmed) {
      await provider.deleteAllNights();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All sleep records have been cleared')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = provider.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SLEEP GOAL SECTION
            const Text(
              'SLEEP GOAL',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.0, color: AppColors.textMuted),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nightly Sleep Goal',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                        Text(
                          '${s.goalHours.toStringAsFixed(1)} hours',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primaryLight),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Target sleep duration to calculate goal streaks and sleep debt.',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      value: s.goalHours,
                      min: 4.0,
                      max: 12.0,
                      divisions: 16,
                      label: '${s.goalHours.toStringAsFixed(1)}h',
                      onChanged: (val) {
                        provider.updateSettings(s.copyWith(goalHours: val));
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // BEDTIME SCHEDULE & REMINDER SECTION
            const Text(
              'BEDTIME & REMINDERS',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.0, color: AppColors.textMuted),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Target Bedtime'),
                    subtitle: const Text('Your intended sleep time each night'),
                    trailing: Text(
                      TimeFormatter.formatTimeOfDay(s.targetBedtimeHour, s.targetBedtimeMinute, use24HourFormat: s.use24HourFormat),
                      style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryLight),
                    ),
                    onTap: () => _updateBedtime(context),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    title: const Text('Bedtime Reminder'),
                    subtitle: Text('${s.bedtimeReminderMinutesBefore} minutes before target bedtime'),
                    value: s.bedtimeReminderEnabled,
                    onChanged: (val) {
                      provider.updateSettings(s.copyWith(bedtimeReminderEnabled: val));
                    },
                  ),
                  if (s.bedtimeReminderEnabled) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Reminder timing', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                          DropdownButton<int>(
                            value: s.bedtimeReminderMinutesBefore,
                            underline: const SizedBox(),
                            items: const [
                              DropdownMenuItem(value: 15, child: Text('15 min before')),
                              DropdownMenuItem(value: 30, child: Text('30 min before')),
                              DropdownMenuItem(value: 45, child: Text('45 min before')),
                              DropdownMenuItem(value: 60, child: Text('60 min before')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                provider.updateSettings(s.copyWith(bedtimeReminderMinutesBefore: val));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    title: const Text('Morning Summary'),
                    subtitle: Text('Reminder to log sleep at ${TimeFormatter.formatTimeOfDay(s.morningSummaryHour, s.morningSummaryMinute, use24HourFormat: s.use24HourFormat)}'),
                    value: s.morningSummaryEnabled,
                    onChanged: (val) {
                      provider.updateSettings(s.copyWith(morningSummaryEnabled: val));
                    },
                  ),
                  if (s.morningSummaryEnabled)
                    ListTile(
                      title: const Text('Morning Reminder Time'),
                      trailing: Text(
                        TimeFormatter.formatTimeOfDay(s.morningSummaryHour, s.morningSummaryMinute, use24HourFormat: s.use24HourFormat),
                        style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.accentAmber),
                      ),
                      onTap: () => _updateMorningSummaryTime(context),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // DISPLAY PREFERENCES SECTION
            const Text(
              'DISPLAY PREFERENCES',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.0, color: AppColors.textMuted),
            ),
            const SizedBox(height: 8),
            Card(
              child: SwitchListTile(
                title: const Text('24-Hour Clock'),
                subtitle: Text(s.use24HourFormat ? 'Displaying 23:00' : 'Displaying 11:00 PM'),
                value: s.use24HourFormat,
                onChanged: (val) {
                  provider.updateSettings(s.copyWith(use24HourFormat: val));
                },
              ),
            ),
            const SizedBox(height: 16),

            // DATA MANAGEMENT SECTION
            const Text(
              'DATA & PRIVACY',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.0, color: AppColors.textMuted),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.file_upload_outlined, color: AppColors.primaryLight),
                    title: const Text('Export Sleep Data'),
                    subtitle: const Text('Save backup as JSON or CSV'),
                    onTap: () => _showExportDialog(context),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Icon(Icons.file_download_outlined, color: AppColors.secondary),
                    title: const Text('Import Sleep Data'),
                    subtitle: const Text('Restore records from backup'),
                    onTap: () => _showImportDialog(context),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Icon(Icons.delete_forever_outlined, color: AppColors.danger),
                    title: const Text('Clear All Data', style: TextStyle(color: AppColors.danger)),
                    subtitle: const Text('Erase all sleep records from this device'),
                    onTap: () => _confirmClearData(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ABOUT / LOCAL PRIVACY COMMITMENT
            Center(
              child: Column(
                children: [
                  const Icon(Icons.shield_outlined, size: 28, color: AppColors.textMuted),
                  const SizedBox(height: 6),
                  const Text(
                    'SleepLog v1.0.0',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '100% Local & Private. No accounts, no network calls.',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
