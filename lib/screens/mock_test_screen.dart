import 'dart:async';
import 'package:flutter/material.dart';
import 'analytics_screen.dart';
import '../utils/storage_helper.dart';

class MockTestScreen extends StatefulWidget {
  final String category;
  final String difficulty;

  const MockTestScreen({
    Key? key,
    required this.category,
    required this.difficulty,
  }) : super(key: key);

  @override
  State<MockTestScreen> createState() => _MockTestScreenState();
}

class _MockTestScreenState extends State<MockTestScreen> {
  int _currentQuestion = 0;
  int _correct = 0;
  int _selectedOption = -1;
  bool _answered = false;

  static const int timePerQuestion = 15;
  int remainingTime = timePerQuestion;
  int totalTimeTaken = 0;
  Timer? _timer;

  late List<Map<String, Object>> _questions;

  final Map<String, Map<String, List<Map<String, Object>>>> questionBank = {
    'Aptitude': {
      'Easy': [
        {
          'question': 'What is 10 + 5?',
          'options': ['10', '15', '20', '25'],
          'answer': 1,
        },
      ],
      'Medium': [
        {
          'question': 'What is 15% of 200?',
          'options': ['20', '25', '30', '35'],
          'answer': 2,
        },
      ],
      'Hard': [
        {
          'question': 'If A : B = 2 : 3 and B = 15, find A',
          'options': ['8', '9', '10', '12'],
          'answer': 1,
        },
      ],
    },
    'Technical': {
      'Easy': [
        {
          'question': 'What does OOP stand for?',
          'options': [
            'Object Oriented Programming',
            'Open Operational Process',
            'Only Object Programming',
            'None',
          ],
          'answer': 0,
        },
      ],
      'Medium': [
        {
          'question': 'Which language is used in Flutter?',
          'options': ['Java', 'Kotlin', 'Dart', 'Python'],
          'answer': 2,
        },
      ],
      'Hard': [
        {
          'question': 'What is a constructor?',
          'options': [
            'Special method',
            'Variable',
            'Class',
            'Object',
          ],
          'answer': 0,
        },
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _questions =
        questionBank[widget.category]?[widget.difficulty] ?? [];
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    remainingTime = timePerQuestion;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime == 0) {
        totalTimeTaken += timePerQuestion;
        timer.cancel();
        _goToNextQuestion();
      } else {
        setState(() => remainingTime--);
      }
    });
  }

  void _answerQuestion(int index) {
    if (_answered) return;

    _timer?.cancel();
    totalTimeTaken += (timePerQuestion - remainingTime);

    setState(() {
      _selectedOption = index;
      _answered = true;
    });

    if (index == _questions[_currentQuestion]['answer']) {
      _correct++;
    }
  }

  void _goToNextQuestion() {
    setState(() {
      _currentQuestion++;
      _selectedOption = -1;
      _answered = false;
    });

    if (_currentQuestion < _questions.length) {
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion >= _questions.length) {
      final int wrong = _questions.length - _correct;
      final double accuracy =
          (_correct / _questions.length) * 100;

      StorageHelper.saveResult(_correct);

      return Scaffold(
        appBar: AppBar(title: const Text('Test Result')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Category: ${widget.category}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Difficulty: ${widget.difficulty}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              _buildResultTile('Correct Answers', _correct.toString()),
              _buildResultTile('Wrong Answers', wrong.toString()),
              _buildResultTile(
                  'Accuracy', '${accuracy.toStringAsFixed(1)}%'),
              _buildResultTile(
                  'Time Taken', '$totalTimeTaken seconds'),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AnalyticsScreen(),
                    ),
                  );
                },
                child: const Text('View Analytics'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.category} - ${widget.difficulty}',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: remainingTime / timePerQuestion,
            ),
            const SizedBox(height: 8),
            Text(
              'Time left: $remainingTime sec',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _questions[_currentQuestion]['question'] as String,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...(_questions[_currentQuestion]['options']
                    as List<String>)
                .asMap()
                .entries
                .map((entry) {
              Color? color;

              if (_answered) {
                if (entry.key ==
                    _questions[_currentQuestion]['answer']) {
                  color = Colors.green;
                } else if (entry.key == _selectedOption) {
                  color = Colors.red;
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                  ),
                  onPressed: () =>
                      _answerQuestion(entry.key),
                  child: Text(entry.value),
                ),
              );
            }),
            if (_answered)
              ElevatedButton(
                onPressed: _goToNextQuestion,
                child: const Text('Next'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultTile(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
