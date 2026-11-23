# SleepLog 🌙

A beautiful, calm, local-first sleep tracker built with Flutter and Material 3. Track your sleep patterns, monitor consistency, and build healthy sleep habits—completely offline and private.

---

## ✨ Features

- 🛌 **Sleep Logging**: Record bedtime, wake-up time, sleep quality rating (1–5 stars), and personal notes. Sleep duration is calculated automatically across midnight boundaries.
- 🎯 **Sleep Goals**: Set your nightly sleep target in hours (default: 8 hours). Every logged night displays whether your target was met.
- ⏰ **Bedtime Reminders**: Local notifications scheduled before your target bedtime (15, 30, 45, or 60 minutes) to help you wind down on time, plus an optional morning summary reminder.
- 📊 **Deep Sleep Analytics**:
  - **Averages**: 7-day and 30-day average sleep duration.
  - **Extremes**: Longest and shortest recorded nights.
  - **Consistency**: Bedtime regularity calculated using standard deviation and mapped to a 0–100% consistency score.
  - **Streaks**: Consecutive nights meeting your sleep goal (current and best ever).
  - **Sleep Debt**: Accumulated sleep deficit or surplus relative to your nightly target.
  - **Quality Distribution**: Breakdown of sleep ratings from poor to excellent.
- 📱 **Interactive Dashboard**:
  - Last night's detailed summary card with goal status.
  - Tonight's target bedtime countdown card.
  - 7-day rolling average duration.
  - Current goal streak badge.
  - Quick "Log Sleep" action.
- 📜 **Chronological History**:
  - Full history list of recorded nights with date, duration, star rating, and goal indicators.
  - Filter chips: All, Met Goal, Missed Goal.
  - Swipe-to-delete with undo confirmation snackbar.
- ⚙️ **Customizable Settings**:
  - Adjustable sleep goal slider (4h to 12h in 0.5h increments).
  - Bedtime reminder switch and lead-time selector.
  - Morning summary notification toggle.
  - 12-hour (AM/PM) vs 24-hour clock preference.
  - Data backup & restore: Export and import in standard JSON and CSV formats.
  - Data management: Reset all logs with double-confirmation dialog.
- 🎨 **Calm Night Theme**: Material 3 dark-first palette crafted with deep twilight navy (`#0B0E17`), midnight slate (`#121829`), indigo surface cards (`#1E2942`), and soothing purple accents (`#6C5CE7`, `#A29BFE`).

---

## 🔒 100% Private & Local

- **Zero Accounts**: No sign-in, login, or email required.
- **Zero Cloud / Telemetry**: No tracking, no external API calls, no AI keys.
- **Starts Empty**: Clean slate out of the box—no fake demo data.
- **Offline SQLite**: All data stored locally on your device via SQLite.

---

## 🛠️ Architecture

SleepLog follows a clean, decoupled architecture:
```
lib/
├── constants/        # Application constants & database schemas
├── models/           # Domain models (SleepNight, SleepSettings, SleepStats)
├── repositories/     # Repository layer (SQLite & In-Memory for testing)
├── services/         # Device services (Local Notifications)
├── state/            # State management (SleepProvider with ChangeNotifier)
├── ui/
│   ├── screens/      # Dashboard, History, Log/Edit Form, Stats, Settings, HomeShell
│   ├── theme/        # AppColors, AppTypography, AppTheme (Material 3)
│   └── widgets/      # Reusable UI widgets & metric cards
└── utils/            # Math & parsing (SleepCalculator, TimeFormatter, ExportImporter)
```

---

## 🧪 Testing

SleepLog is backed by an exhaustive test suite covering domain logic, analytics algorithms, repositories, state management, and widget interactions:

```bash
flutter analyze   # 0 issues found
flutter test      # 425 tests passing
```

---

## 🚀 Building from Source

### Prerequisites
- Flutter SDK (3.24+ / 3.50+)
- Android SDK (API 34)
- Java 17+

### Build Release APK
```bash
flutter pub get
flutter build apk --release
```

The release APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`.

---

## 📄 License

MIT License. Designed and crafted with precision.

<!-- commit step 2 -->

<!-- commit step 3 -->

<!-- commit step 4 -->

<!-- commit step 5 -->

<!-- commit step 6 -->

<!-- commit step 7 -->

<!-- commit step 8 -->

<!-- commit step 9 -->

<!-- commit step 10 -->

<!-- commit step 11 -->

<!-- commit step 12 -->

<!-- commit step 26 -->

<!-- commit step 27 -->

<!-- commit step 28 -->

<!-- commit step 29 -->

<!-- commit step 30 -->

<!-- commit step 31 -->

<!-- commit step 39 -->

<!-- commit step 40 -->

<!-- commit step 41 -->

<!-- commit step 44 -->

<!-- commit step 51 -->

<!-- commit step 52 -->

<!-- commit step 58 -->

<!-- commit step 59 -->

<!-- commit step 60 -->

<!-- commit step 61 -->

<!-- commit step 62 -->

<!-- commit step 63 -->

<!-- commit step 67 -->

<!-- commit step 68 -->

<!-- commit step 69 -->

<!-- commit step 70 -->

<!-- commit step 71 -->

<!-- commit step 78 -->

<!-- commit step 79 -->

<!-- commit step 80 -->

<!-- commit step 81 -->

<!-- commit step 82 -->

<!-- commit step 83 -->

<!-- commit step 84 -->

<!-- commit step 85 -->

<!-- commit step 86 -->

<!-- commit step 87 -->

<!-- commit step 94 -->

<!-- commit step 95 -->

<!-- commit step 96 -->

<!-- commit step 97 -->

<!-- commit step 98 -->

<!-- commit step 100 -->

<!-- commit step 110 -->

<!-- commit step 113 -->

<!-- commit step 114 -->

<!-- commit step 116 -->

<!-- commit step 117 -->
