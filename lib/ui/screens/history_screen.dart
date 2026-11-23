import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/state/sleep_provider.dart';
import 'package:sleeplog/ui/widgets/night_list_item.dart';
import 'package:sleeplog/ui/widgets/empty_state_view.dart';
import 'package:sleeplog/ui/widgets/confirm_dialog.dart';
import 'package:sleeplog/ui/screens/log_edit_sleep_screen.dart';

class HistoryScreen extends StatefulWidget {
  final SleepProvider provider;

  const HistoryScreen({super.key, required this.provider});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filter = 'all'; // 'all', 'met', 'missed'

  void _openLogScreen(BuildContext context, [SleepNight? night]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => LogEditSleepScreen(
          provider: widget.provider,
          existingNight: night,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, SleepNight night) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete Night',
      message: 'Are you sure you want to delete this sleep log? This action cannot be undone.',
      confirmText: 'Delete',
      isDestructive: true,
    );
    if (confirmed) {
      await widget.provider.deleteNight(night.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sleep log deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final allNights = widget.provider.nights;
    final goalHours = widget.provider.settings.goalHours;
    final use24Hour = widget.provider.settings.use24HourFormat;

    final filteredNights = allNights.where((n) {
      if (_filter == 'met') return n.isGoalMet(goalHours);
      if (_filter == 'missed') return !n.isGoalMet(goalHours);
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Sleep Log',
            onPressed: () => _openLogScreen(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                FilterChip(
                  label: Text('All (${allNights.length})'),
                  selected: _filter == 'all',
                  onSelected: (_) => setState(() => _filter = 'all'),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text('Goal Met (${allNights.where((n) => n.isGoalMet(goalHours)).length})'),
                  selected: _filter == 'met',
                  onSelected: (_) => setState(() => _filter = 'met'),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text('Missed (${allNights.where((n) => !n.isGoalMet(goalHours)).length})'),
                  selected: _filter == 'missed',
                  onSelected: (_) => setState(() => _filter = 'missed'),
                ),
              ],
            ),
          ),

          // Nights List or Empty State
          Expanded(
            child: filteredNights.isEmpty
                ? EmptyStateView(
                    icon: Icons.nights_stay_outlined,
                    title: allNights.isEmpty ? 'No sleep logged yet' : 'No nights match filter',
                    description: allNights.isEmpty
                        ? 'Tap below or the + button in the corner to log your first night.'
                        : 'Try selecting a different filter above.',
                    actionText: allNights.isEmpty ? 'Log First Night' : null,
                    onAction: allNights.isEmpty ? () => _openLogScreen(context) : null,
                  )
                : ListView.builder(
                    itemCount: filteredNights.length,
                    padding: const EdgeInsets.only(bottom: 24),
                    itemBuilder: (ctx, index) {
                      final night = filteredNights[index];
                      return NightListItem(
                        night: night,
                        goalHours: goalHours,
                        use24Hour: use24Hour,
                        onTap: () => _openLogScreen(context, night),
                        onDelete: () => _confirmDelete(context, night),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}}
