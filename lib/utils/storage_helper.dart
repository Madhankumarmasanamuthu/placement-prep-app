import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String _lastScoreKey = 'lastScore';
  static const String _highestScoreKey = 'highestScore';
  static const String _attemptsKey = 'attempts';
  static const String _lastAttemptDateKey = 'lastAttemptDate';
  static const String _streakKey = 'streak';

  // ===============================
  // SAVE RESULT AFTER MOCK TEST
  // ===============================
  static Future<void> saveResult(int score) async {
    final prefs = await SharedPreferences.getInstance();

    // Attempts
    int attempts = prefs.getInt(_attemptsKey) ?? 0;
    await prefs.setInt(_attemptsKey, attempts + 1);

    // Last score
    await prefs.setInt(_lastScoreKey, score);

    // Highest score
    int highest = prefs.getInt(_highestScoreKey) ?? 0;
    if (score > highest) {
      await prefs.setInt(_highestScoreKey, score);
    }

    // Update streak
    await updateStreak();
  }

  // ===============================
  // GETTERS
  // ===============================
  static Future<int> getLastScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastScoreKey) ?? 0;
  }

  static Future<int> getHighestScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highestScoreKey) ?? 0;
  }

  static Future<int> getAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_attemptsKey) ?? 0;
  }

  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  // ===============================
  // DAILY ATTEMPT CHECK
  // ===============================
  static Future<bool> canAttemptToday() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString(_lastAttemptDateKey);

    final today = DateTime.now().toIso8601String().substring(0, 10);

    return lastDate != today;
  }

  // ===============================
  // STREAK LOGIC (PrepInsta-style)
  // ===============================
  static Future<void> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();

    final today = DateTime.now();
    final todayStr = today.toIso8601String().substring(0, 10);

    final lastDateStr = prefs.getString(_lastAttemptDateKey);
    int streak = prefs.getInt(_streakKey) ?? 0;

    if (lastDateStr != null) {
      final lastDate = DateTime.parse(lastDateStr);

      if (today.difference(lastDate).inDays == 1) {
        streak += 1; // Continue streak
      } else if (today.difference(lastDate).inDays > 1) {
        streak = 1; // Reset streak
      }
    } else {
      streak = 1;
    }

    await prefs.setInt(_streakKey, streak);
    await prefs.setString(_lastAttemptDateKey, todayStr);
  }

  // ===============================
  // RESET ANALYTICS
  // ===============================
  static Future<void> resetAnalytics() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_lastScoreKey);
    await prefs.remove(_highestScoreKey);
    await prefs.remove(_attemptsKey);
    await prefs.remove(_lastAttemptDateKey);
    await prefs.remove(_streakKey);
  }
}
