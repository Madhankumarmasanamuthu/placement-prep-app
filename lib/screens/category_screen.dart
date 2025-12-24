import 'package:flutter/material.dart';
import 'mock_test_screen.dart';
import 'difficulty_screen.dart';


class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'title': 'Aptitude', 'icon': Icons.calculate},
      {'title': 'Technical', 'icon': Icons.computer},
      {'title': 'Verbal', 'icon': Icons.record_voice_over},
      {'title': 'Logical', 'icon': Icons.psychology},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];

            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DifficultyScreen(
                      category: category['title'] as String,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category['icon'] as IconData,
                      size: 48,
                      color: Colors.indigo,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      category['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
