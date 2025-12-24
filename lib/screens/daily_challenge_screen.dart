import 'package:flutter/material.dart';
import 'mock_test_screen.dart';
import '../utils/storage_helper.dart';

class DailyChallengeScreen extends StatefulWidget {
  const DailyChallengeScreen({Key? key}) : super(key: key);

  @override
  State<DailyChallengeScreen> createState() =>
      _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  bool canAttempt = true;
  int streak = 0;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final allowed = await StorageHelper.canAttemptToday();
    final currentStreak = await StorageHelper.getStreak();

    setState(() {
      canAttempt = allowed;
      streak = currentStreak;
    });
  }

  void _startChallenge() async {
    await StorageHelper.updateStreak();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MockTestScreen(
          category: 'Aptitude',
          difficulty: 'Easy',
        ),
      ),
    ).then((_) => _loadStatus());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Challenge')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_fire_department,
                size: 80, color: Colors.orange),
            const SizedBox(height: 10),
            Text(
              '🔥 Streak: $streak days',
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            if (canAttempt)
              ElevatedButton(
                onPressed: _startChallenge,
                child: const Text('Start Daily Challenge'),
              )
            else
              const Text(
                'You have already completed today’s challenge.\nCome back tomorrow!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
