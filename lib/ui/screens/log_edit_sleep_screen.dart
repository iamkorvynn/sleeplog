import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/state/sleep_provider.dart';
import 'package:sleeplog/ui/theme/app_colors.dart';
import 'package:sleeplog/utils/time_formatter.dart';
import 'package:sleeplog/ui/widgets/star_rating_bar.dart';
import 'package:sleeplog/ui/widgets/goal_progress_badge.dart';

class LogEditSleepScreen extends StatefulWidget {
  final SleepProvider provider;
  final SleepNight? existingNight;

  const LogEditSleepScreen({
    super.key,
    required this.provider,
    this.existingNight,
  });

  @override
  State<LogEditSleepScreen> createState() => _LogEditSleepScreenState();
}

class _LogEditSleepScreenState extends State<LogEditSleepScreen> {
  late DateTime _bedtime;
  late DateTime _wakeTime;
  late int _quality;
  late TextEditingController _notesController;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingNight;
    if (existing != null) {
      _bedtime = existing.bedtime;
      _wakeTime = existing.wakeTime;
      _quality = existing.quality;
      _notesController = TextEditingController(text: existing.notes ?? '');
    } else {
      // Default to last night: yesterday 23:00 to today 07:00
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      _bedtime = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 0);
      _wakeTime = DateTime(now.year, now.month, now.day, 7, 0);
      _quality = 4;
      _notesController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Duration get _currentDuration => _wakeTime.difference(_bedtime);

  Future<void> _pickBedtime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _bedtime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _bedtime.hour, minute: _bedtime.minute),
    );
    if (pickedTime == null || !mounted) return;

    setState(() {
      _bedtime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      _validationError = null;
    });
  }

  Future<void> _pickWakeTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _wakeTime,
      firstDate: _bedtime.subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 2)),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _wakeTime.hour, minute: _wakeTime.minute),
    );
    if (pickedTime == null || !mounted) return;

    setState(() {
      _wakeTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      _validationError = null;
    });
  }

  Future<void> _save() async {
    final duration = _currentDuration;
    if (duration.inMinutes <= 0) {
      setState(() => _validationError = 'Wake time must be after bedtime');
      return;
    }
    if (duration.inMinutes < 15) {
      setState(() => _validationError = 'Sleep duration must be at least 15 minutes');
      return;
    }
    if (duration.inHours > 24) {
      setState(() => _validationError = 'Sleep duration cannot exceed 24 hours');
      return;
    }

    final notes = _notesController.text.trim();
    final nightId = widget.existingNight?.id ?? DateTime.now().microsecondsSinceEpoch.toString();

    final night = SleepNight(
      id: nightId,
      bedtime: _bedtime,
      wakeTime: _wakeTime,
      quality: _quality,
      notes: notes.isEmpty ? null : notes,
      createdAt: widget.existingNight?.createdAt,
      updatedAt: DateTime.now(),
    );

    if (widget.existingNight != null) {
      await widget.provider.updateNight(night);
    } else {
      await widget.provider.addNight(night);
    }

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.existingNight != null ? 'Sleep log updated' : 'Sleep logged successfully!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingNight != null;
    final use24Hour = widget.provider.settings.use24HourFormat;
    final goalHours = widget.provider.settings.goalHours;
    final duration = _currentDuration;
    final isPositive = duration.inMinutes > 0;
    final isMet = isPositive && (duration.inMinutes / 60.0 >= goalHours);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Sleep' : 'Log Sleep'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          ),
        ],
      ),
      // Crucial: SingleChildScrollView + Column to avoid form validation cache bugs
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Duration preview banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Column(
                children: [
                  const Text(
                    'CALCULATED DURATION',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isPositive ? TimeFormatter.formatDuration(duration) : '--:--',
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (isPositive)
                    GoalProgressBadge(
                      isMet: isMet,
                      label: isMet
                          ? 'Goal Met (≥ ${TimeFormatter.formatDurationHours(goalHours)})'
                          : 'Under Goal (< ${TimeFormatter.formatDurationHours(goalHours)})',
                    ),
                ],
              ),
            ),
            if (_validationError != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.danger.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.danger.withAlpha(80)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: AppColors.danger, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _validationError!,
                        style: const TextStyle(color: AppColors.danger, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Bedtime Selector
            const Text(
              'Bedtime',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickBedtime,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bedtime_outlined, color: AppColors.primaryLight),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            TimeFormatter.formatDate(_bedtime, includeWeekday: true, includeYear: true),
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            TimeFormatter.formatTime(_bedtime, use24HourFormat: use24Hour),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.edit_calendar_rounded, size: 20, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Wake-up Time Selector
            const Text(
              'Wake-up Time',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickWakeTime,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wb_sunny_outlined, color: AppColors.accentAmber),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            TimeFormatter.formatDate(_wakeTime, includeWeekday: true, includeYear: true),
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            TimeFormatter.formatTime(_wakeTime, use24HourFormat: use24Hour),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.edit_calendar_rounded, size: 20, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sleep Quality Rating
            const Text(
              'Sleep Quality',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Center(
                child: StarRatingBar(
                  rating: _quality,
                  starSize: 36,
                  readOnly: false,
                  showLabel: true,
                  onRatingChanged: (newRating) {
                    setState(() => _quality = newRating);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Notes field
            const Text(
              'Notes (Optional)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'e.g. Woke up refreshed, read before bed...',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                filled: true,
                fillColor: AppColors.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.darkBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.darkBorder),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Save & Cancel buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      side: const BorderSide(color: AppColors.darkBorder),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(isEditing ? 'Update Night' : 'Save Night'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}}
