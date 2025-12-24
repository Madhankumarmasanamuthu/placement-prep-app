import 'package:flutter/material.dart';
import '../utils/storage_helper.dart';

class AnalyticsScreen extends StatefulWidget {
  AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int lastScore = 0;
  int attempts = 0;
  int highestScore = 0;


  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
  final score = await StorageHelper.getLastScore();
  final totalAttempts = await StorageHelper.getAttempts();
  final bestScore = await StorageHelper.getHighestScore();

  setState(() {
    lastScore = score;
    attempts = totalAttempts;
    highestScore = bestScore;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCard('Last Score', lastScore.toString()),
            _buildCard('Highest Score', highestScore.toString()),
            _buildCard('Total Attempts', attempts.toString()),
            _buildCard(
              'Performance',
              lastScore >= 2 ? 'Good' : 'Needs Improvement',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await StorageHelper.resetAnalytics();
                _loadAnalytics();
              },
              child: const Text('Reset Analytics'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String value) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(value,
                style:
                    const TextStyle(fontSize: 20, color: Colors.indigo)),
          ],
        ),
      ),
    );
  }
}
