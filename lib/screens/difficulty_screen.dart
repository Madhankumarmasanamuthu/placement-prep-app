import 'package:flutter/material.dart';
import 'mock_test_screen.dart';

class DifficultyScreen extends StatelessWidget {
  final String category;

  const DifficultyScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final difficulties = ['Easy', 'Medium', 'Hard'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Difficulty'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: difficulties.map((level) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MockTestScreen(
                        category: category,
                        difficulty: level,
                      ),
                    ),
                  );
                },
                child: Text(level),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
