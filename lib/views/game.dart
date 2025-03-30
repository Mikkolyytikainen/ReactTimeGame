import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _isWaiting = true;
  bool _isGameStarted = false;
  late Timer _timer;
  late DateTime _startTime;
  late DateTime _endTime;
  String _message = 'Wait for green...';

  void _startGame() {
    setState(() {
      _isWaiting = true;
      _isGameStarted = true;
      _message = 'Wait for green...';
    });

    _timer = Timer(
        Duration(
            seconds: 2 +
                (3 *
                    (new DateTime.now().millisecondsSinceEpoch % 1000) ~/
                    1000)), () {
      setState(() {
        _isWaiting = false;
        _message = 'Tap!';
        _startTime = DateTime.now();
      });
    });
  }

  void _stopGame() {
    if (!_isWaiting) {
      _endTime = DateTime.now();
      final reactionTime = _endTime.difference(_startTime).inMilliseconds;
      setState(() {
        _isGameStarted = false;
        _message = 'Your reaction time is $reactionTime ms';
        // Save the highscore
        _saveHighScore(reactionTime);
      });
    } else {
      _timer.cancel();
      setState(() {
        _isGameStarted = false;
        _message = 'You tapped too early!';
      });
    }
  }

  Future<void> _saveHighScore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? highScores = prefs.getStringList('highScores') ?? [];

    highScores.add(score.toString());
    if (highScores.length > 5) {
      highScores.removeAt(0); // Remove the oldest score if more than 5
    }
    await prefs.setStringList('highScores', highScores);
  }

  @override
  void dispose() {
    if (_isGameStarted) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reaction Time Game'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: _isGameStarted ? _stopGame : _startGame,
          child: Container(
            color: _isWaiting ? Colors.red : Colors.green,
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Text(
                _message,
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
