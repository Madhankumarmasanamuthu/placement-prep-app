import 'package:flutter/material.dart';

class InterviewQuestionsScreen extends StatefulWidget {
  InterviewQuestionsScreen({Key? key}) : super(key: key);

  @override
  State<InterviewQuestionsScreen> createState() =>
      _InterviewQuestionsScreenState();
}

class _InterviewQuestionsScreenState extends State<InterviewQuestionsScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';

  final Map<String, List<Map<String, String>>> categorizedQuestions = {
    'HR': [
      {
        'question': 'Tell me about yourself.',
        'answer':
            'I am a motivated individual with strong technical skills and a passion for learning and problem-solving.',
      },
      {
        'question': 'What are your strengths?',
        'answer':
            'My strengths include adaptability, quick learning, and good communication skills.',
      },
    ],
    'Technical': [
      {
        'question': 'What is OOP?',
        'answer':
            'Object-Oriented Programming is a paradigm based on objects containing data and methods.',
      },
      {
        'question': 'What is a database?',
        'answer':
            'A database is an organized collection of data that allows efficient retrieval and management.',
      },
    ],
    'Flutter': [
      {
        'question': 'What is Flutter?',
        'answer':
            'Flutter is an open-source UI toolkit by Google for building cross-platform apps.',
      },
      {
        'question': 'What is setState()?',
        'answer':
            'setState() notifies the framework that the state has changed and the UI needs rebuilding.',
      },
    ],
  };

  List<Map<String, String>> get filteredQuestions {
    final allQuestions = selectedCategory == 'All'
        ? categorizedQuestions.values.expand((e) => e).toList()
        : categorizedQuestions[selectedCategory]!;

    return allQuestions
        .where((q) =>
            q['question']!
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            q['answer']!
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interview Questions')),
      body: Column(
        children: [
          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search questions...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // 🏷 Category chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                _buildChip('All'),
                _buildChip('HR'),
                _buildChip('Technical'),
                _buildChip('Flutter'),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 📄 Questions list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredQuestions.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ExpansionTile(
                    title: Text(
                      filteredQuestions[index]['question']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child:
                            Text(filteredQuestions[index]['answer']!),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    final bool isSelected = selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            selectedCategory = label;
          });
        },
      ),
    );
  }
}
