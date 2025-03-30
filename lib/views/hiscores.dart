import 'package:flutter/material.dart';
import 'package:reacttime/views/game.dart';
import 'package:reacttime/views/main_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Hiscores extends StatelessWidget {
  const Hiscores({Key? key}) : super(key: key);

  // This widget shows the high scores of the user
  // It retrieves the scores from shared preferences and displays them in a list
  // It also provides a button to clear the high scores
  // and navigate back to the main menu
  // The scores are displayed in a simple list view
  // with a title and a button to clear the scores
  // The button is styled with a blue color and white text
  // The list view is wrapped in a container with padding and a background color
  // The title is displayed in a text widget with a larger font size and bold weight
  // The button is displayed below the list view with a margin
  // The button is centered and has a fixed width and height
  // The button is styled with a blue color and white text

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
