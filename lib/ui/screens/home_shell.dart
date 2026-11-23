import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/state/sleep_provider.dart';
import 'package:sleeplog/ui/screens/dashboard_screen.dart';
import 'package:sleeplog/ui/screens/history_screen.dart';
import 'package:sleeplog/ui/screens/stats_screen.dart';
import 'package:sleeplog/ui/screens/settings_screen.dart';
import 'package:sleeplog/ui/screens/log_edit_sleep_screen.dart';

class HomeShell extends StatefulWidget {
  final SleepProvider provider;

  const HomeShell({super.key, required this.provider});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  void _openLogScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => LogEditSleepScreen(provider: widget.provider),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.provider,
      builder: (context, _) {
        if (widget.provider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final screens = [
          DashboardScreen(provider: widget.provider),
          HistoryScreen(provider: widget.provider),
          StatsScreen(provider: widget.provider),
          SettingsScreen(provider: widget.provider),
        ];

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.bedtime_outlined),
                selectedIcon: Icon(Icons.bedtime_rounded),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.history_rounded),
                selectedIcon: Icon(Icons.history_toggle_off_rounded),
                label: 'History',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart_rounded),
                label: 'Stats',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings_rounded),
                label: 'Settings',
              ),
            ],
          ),
          floatingActionButton: (_currentIndex == 0 || _currentIndex == 1)
              ? FloatingActionButton(
                  onPressed: _openLogScreen,
                  tooltip: 'Log Sleep',
                  child: const Icon(Icons.add_rounded),
                )
              : null,
        );
      },
    );
  }
}
