import 'package:flutter/material.dart';
import 'game.dart';
import 'jjk_game.dart'; // import for Jujutsu Kaisen category
//import 'education_game.dart'; // import for education category
//import 'gaming_game.dart'; // import for games category
//import 'movies_game.dart'; // import for movies category
//import 'general_game.dart'; // import for general category

void main() {
  runApp(const MainApp());
}

// ---- Main Application Widget with Navigation and Theming -----
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

// ---- State class for MainApp to manage navigation and theming based on selected category -----
class _MainAppState extends State<MainApp> {
  Widget _aktuelleSeite = const GamePage();
  String _aktuelleKategorieText = 'Kategorie: IT & Coding'; 

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
              color: Colors.black.withValues(alpha: 0.15), // subtle shadow color
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

      // ---- Navigation Drawer with Category Selection and Theming -----
        drawer: Drawer(
          child: Builder(
            builder: (BuildContext innerContext) {
          return ListView(
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

// ---- Category selection tiles with icons and theming for the game page -----
                  ListTile(
                    leading: const Icon(Icons.code),
                    title: const Text('IT & Coding (5 Buchstaben)'),
                    onTap: () {
                      setState(() {
                        _aktuelleSeite = const GamePage(); // focus on IT & Coding game page,
                        _aktuelleKategorieText = 'Kategorie: IT & Coding '; // set the current category for theming and game logic
                      });
                      // Handle category selection, e.g., navigate to a different game page or set the category in the game state
                      Navigator.pop(innerContext); // Close the drawer after selection
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.school),
                    title: const Text('Bildung (5 Buchstaben)'),
                    onTap: () {
                      setState(() {
                        _aktuelleSeite = const GamePage(); // focus on Education game page,
                        _aktuelleKategorieText = 'Kategorie: Bildung '; // set the current category for theming and game logic
                      });
                      // Handle category selection, e.g., navigate to a different game page or set the category in the game state
                      Navigator.pop(innerContext); // Close the drawer after selection
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.games),
                    title: const Text('Spiele (5 Buchstaben)'),
                    onTap: () {
                      setState(() {
                        _aktuelleSeite = const GamePage(); // focus on Games game page,
                        _aktuelleKategorieText = 'Kategorie: Spiele '; // set the current category for theming and game logic
                      });
                      // Handle category selection, e.g., navigate to a different game page or set the category in the game state
                      Navigator.pop(innerContext); // Close the drawer after selection
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.movie),
                    title: const Text('Filme (5 Buchstaben)'),
                    onTap: () {
                      setState(() {
                        _aktuelleSeite = const GamePage(); // focus on Movies game page,
                        _aktuelleKategorieText = 'Kategorie: Filme '; // set the current category for theming and game logic
                      });
                      // Handle category selection, e.g., navigate to a different game page or set the category in the game state
                      Navigator.pop(innerContext); // Close the drawer after selection
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.sports_esports),
                    title: const Text('Allgemein (5 Buchstaben)'),
                    onTap: () {
                      setState(() {
                        _aktuelleSeite = const GamePage(); // focus on General game page,
                        _aktuelleKategorieText = 'Kategorie: Allgemein '; // set the current category for theming and game logic
                      });
                      // Handle category selection, e.g., navigate to a different game page or set the category in the game state
                      Navigator.pop(innerContext); // Close the drawer after selection
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.star),
                    title: const Text('Jujutsu Kaisen (Charaktere, X Buchstaben)'),
                    onTap: () {
                      setState(() {
                        _aktuelleSeite = const JjkGamePage(); // focus on Jujutsu Kaisen game page,
                        _aktuelleKategorieText = 'Kategorie: Jujutsu Kaisen '; // set the current category for theming and game logic
                      });
                      // Handle category selection, e.g., navigate to a different game page or set the category in the game state
                      Navigator.pop(innerContext); // Close the drawer after selection
                    },
                  ),
                  const Divider(), // add clear parting separation  

                  // placeholderrr for level selection, not implemented yet
                  ListTile(
                    leading: const Icon(Icons.tune, color: Colors.blueGrey), // grey icon for level selection
                    title: const Text('Level 1 (Einfach)'),
                    subtitle: const Text('5 Buchstaben, 5 Versuche'),
                    onTap: () {
                      Navigator.pop(innerContext); // Close the drawer after selection
                    },
                  ),

                ],
              );
            } // HIER: Das Ende der Builder-Funktion
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

                  // ---- Category display with icon and theming to match the selected category -----
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.15), 
                      borderRadius: BorderRadius.circular(20), // Rounded corners
                      border: Border.all(color: Colors.green.withValues(alpha:0.3)), // Green border
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Wrap content 
                      children: [
                        const Icon(Icons.bug_report, color: Colors.green), // Green bug icon
                        const SizedBox(width: 8), // Spacing between icon and text
                        Text(
                          _aktuelleKategorieText, // Display the current category text
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
                      child: _aktuelleSeite, // Display the current game page based on the selected category
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

// ---- Game Page and Tile Widgets ----

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

// ---- Game Page State to manage the game logic and user interactions -----
class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}
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

