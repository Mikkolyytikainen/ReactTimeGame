import 'package:flutter/material.dart';
import 'package:reacttime/views/game.dart';
import 'package:reacttime/views/main_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Hiscores extends StatelessWidget {
  const Hiscores({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Highscores'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Highscores',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Here are your highscores:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Center(
              child: FutureBuilder<List<String>>(
                future: _getHighScores(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error loading highscores');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No highscores yet!');
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index]),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _clearHighScores();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainMenu()),
                );
              },
              child: const Text('Clear Highscores'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainMenu()),
                );
              },
              child: const Text('Back to Main Menu'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getHighScores() {
    return SharedPreferences.getInstance().then((prefs) {
      List<String>? highScores = prefs.getStringList('highScores') ?? [];
      return highScores;
    });
  }

  void _clearHighScores() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('highScores');
    });
  }
}
