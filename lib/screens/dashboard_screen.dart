import 'package:flutter/material.dart';
import 'mock_test_screen.dart';
import 'analytics_screen.dart';
import 'interview_questions_screen.dart';
import 'profile_screen.dart';
import '../utils/storage_helper.dart';
import 'category_screen.dart';
import 'daily_challenge_screen.dart';



class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int lastScore = 0;
  int attempts = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final score = await StorageHelper.getLastScore();
    final totalAttempts = await StorageHelper.getAttempts();

    setState(() {
      lastScore = score;
      attempts = totalAttempts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // 🔹 HEADER SECTION
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back 👋',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Last Score: $lastScore | Attempts: $attempts',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // 🔹 DASHBOARD GRID
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildCard(
                    icon: Icons.quiz,
                    title: 'Mock Test',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MockTestScreen(
                            category: 'Technical',
                            difficulty: 'Easy',
                          ),
                        ),
                      );
                    },
                  ),
                  _buildCard(
                    icon: Icons.question_answer,
                    title: 'Interview Q&A',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InterviewQuestionsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildCard(
                    icon: Icons.analytics,
                    title: 'Analytics',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnalyticsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildCard(
                    icon: Icons.local_fire_department,
                    title: 'Daily Challenge',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DailyChallengeScreen(),
                        ),
                      );
                    },
                  ),
                  _buildCard(
                    icon: Icons.person,
                    title: 'Profile',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 REUSABLE CARD WIDGET
 Widget _buildCard({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}
}
