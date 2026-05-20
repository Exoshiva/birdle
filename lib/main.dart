import 'package:flutter/material.dart';
import 'game.dart';
//import 'jjk_game.dart'; // later import for Jujutsu Kaisen category
// import 'bildung_game.dart'; // later import for education category, not implemented yet
// import 'spiele_game.dart'; // later import for games category, not implemented yet
// import 'filme_game.dart'; // later import for movies category, not implemented yet
// import 'allgemein_game.dart'; // later import for general category, not implemented yet

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide the debug banner
      theme: ThemeData(
        brightness: Brightness.light,
      ), // Use light theme

      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(252, 255, 255, 100), // Make the app bar yellow
          elevation : 1, 
          // add border shadow to title widget to make it pop against the background
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1), // minimal height for the shadow 
            child: Container(
              color: Colors.black.withOpacity(0.15), // subtle shadow color
              height: 1.0, // thickness of the shadow
            ),
          ),
          centerTitle: true, // Remove the shadow
          title: const Text(
            'Birdle Game',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),

        // Side Navigation Bar with category theming
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Header section of the drawer with category theming
              const DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 255, 255, 100),
                      Color.fromARGB(255, 255, 255, 100),
                    ],
                  ),
                ),
                child: Text(
                  'Menü und Themen',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // List of categories in the drawer
              ListTile(
                leading: const Icon(Icons.code),
                title: const Text('IT & Coding (5 Buchstaben)'),
                onTap: () {
                  // Handle category selection, e.g., navigate to a different game page or set the category in the game state
                  Navigator.pop(context); // Close the drawer after selection
                },
              ),
              ListTile(
                leading: const Icon(Icons.school),
                title: const Text('Bildung (5 Buchstaben)'),
                onTap: () {
                  // Handle category selection, e.g., navigate to a different game page or set the category in the game state
                  Navigator.pop(context); // Close the drawer after selection
                },
              ),
              ListTile(
                leading: const Icon(Icons.games),
                title: const Text('Spiele (5 Buchstaben)'),
                onTap: () {
                  // Handle category selection, e.g., navigate to a different game page or set the category in the game state
                  Navigator.pop(context); // Close the drawer after selection
                },
              ),
              ListTile(
                leading: const Icon(Icons.movie),
                title: const Text('Filme (5 Buchstaben)'),
                onTap: () {
                  // Handle category selection, e.g., navigate to a different game page or set the category in the game state
                  Navigator.pop(context); // Close the drawer after selection
                },
              ),
              ListTile(
                leading: const Icon(Icons.sports_esports),
                title: const Text('Allgemein (5 Buchstaben)'),
                onTap: () {
                  // Handle category selection, e.g., navigate to a different game page or set the category in the game state
                  Navigator.pop(context); // Close the drawer after selection
                },
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Jujutsu Kaisen (Charaktere, X Buchstaben)'),
                onTap: () {
                  // Handle category selection, e.g., navigate to a different game page or set the category in the game state
                  Navigator.pop(context); // Close the drawer after selection
                },
              ),
              const Divider(), // add clear parting separation  

              // placeholderrr for level selection, not implemented yet
              ListTile(
                leading: const Icon(Icons.tune, color: Colors.blueGrey), // grey icon for level selection
                title: const Text('Level 1 (Einfach)'),
                subtitle: const Text('5 Buchstaben, 5 Versuche'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer after selection
                },
              ),

            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(252, 255, 255, 255), 
                Color.fromARGB(255, 175, 243, 255), 
              ],
            ),
          ),
          child: Center(
            child: SizedBox(
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20), // Add some spacing at the top

                  // Game focus themeing 
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15), 
                      borderRadius: BorderRadius.circular(20), // Rounded corners
                      border: Border.all(color: Colors.green.withOpacity(0.3)), // Green border
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Wrap content 
                      children: [
                        const Icon(Icons.bug_report, color: Colors.green), // Green bug icon
                        const SizedBox(width: 8), // Spacing between icon and text
                        Text(
                          'Kategorie: IT & Coding',
                          style: TextStyle(
                            color: Colors.green.shade700, // Adjust text color based on theme
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20), // Add some spacing between the category and the game
                  // The actual game page
                  Expanded(
                    child: SingleChildScrollView(
                      child: GamePage(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: switch (hitType) {
          HitType.hit => const Color(0xFD43FF64), // Green for correct position
          HitType.partial => const Color(0xFFFFFF64), // Yellow for correct letter, wrong position
          HitType.miss => const Color(0x667D7D7D), // Grey for incorrect letter
          _ => Colors.white,
        },
      ),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}
  //final Game _game = Game(); moved to _GamePageState to avoid creating a new game on every rebuild

  class _GamePageState extends State<GamePage> {
    final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          for (var guess in _game.guesses)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  for (var letter in guess) 
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 2.5),
                    child: Tile(letter.char, letter.type),
                  ) 
              ],
            ),
          GuessInput(
            onSubmitGuess: (String guess) {
              setState(() {
                _game.guess(guess);
              });
            },
          )
        ],
      ),
    );
  }
}

class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _onSubmit() {
    onSubmitGuess(_textEditingController.text.trim());
    _textEditingController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 5,
              focusNode: _focusNode,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
              ),
            ),
              controller: _textEditingController,
              onSubmitted: (value) { 
                _onSubmit(); 
              },
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_circle_up),
          onPressed: _onSubmit,
          ),
        ],
    );
  }
}