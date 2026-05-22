import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';

// ---------------------------------------------------------
// 1. The Game-Logic (now with dynamic levels!)
// ---------------------------------------------------------
enum JjkHitType { none, hit, partial, miss }
typedef JjkLetter = ({String char, JjkHitType type});

const List<String> jjkLegalWords = [
  // Level 1: 5 Letters
  'panda', 'yuuji', 'touji', 'getou', 'choso', 
  'curse', 'tokyo', 'kyoto', 'demon', 'dagon',

  // Level 2: 6 Letters
  'sukuna', 'satoru', 'megumi', 'nobara', 'kaisen', 
  'nanami', 'mahito', 'hanami', 'hakari', 'tengen',

  // Level 3: 7 Letters
  'jujutsu', 'inumaki', 'kashimo', 'kenjaku', 'sorcery'
];

const List<String> jjkTargetWords = [...jjkLegalWords];

class JjkGame {
  static const int defaultMaxGuesses = 5;
  
  // NEW: Accepts the desired wordLength
  JjkGame({this.maxGuesses = defaultMaxGuesses, this.wordLength = 5, this.seed})
      : _wordToGuess = _generateInitialWord(seed, wordLength),
        _guesses = List<JjkWord>.filled(maxGuesses, JjkWord.empty(wordLength));

  final int maxGuesses;
  final int wordLength; // NEW
  final int? seed;

  JjkWord _wordToGuess;
  List<JjkWord> _guesses;

  JjkWord get hiddenWord => _wordToGuess;
  UnmodifiableListView<JjkWord> get guesses => UnmodifiableListView(_guesses);

  JjkWord get previousGuess {
    final index = _guesses.lastIndexWhere((word) => word.isNotEmpty);
    // NEW: Returns an empty row with the appropriate length
    return index == -1 ? JjkWord.empty(wordLength) : _guesses[index];
  }

  int get activeIndex => _guesses.indexWhere((word) => word.isEmpty);

  int get guessesRemaining {
    if (activeIndex == -1) return 0;
    return maxGuesses - activeIndex;
  }

  bool get didWin {
    if (_guesses.first.isEmpty) return false;
    for (final letter in previousGuess) {
      if (letter.type != JjkHitType.hit) return false;
    }
    return true;
  }

  bool get didLose => guessesRemaining == 0 && !didWin;

  void resetGame() {
    // NEW: Generates a new word with the accepted length
    _wordToGuess = _generateInitialWord(seed, wordLength);
    _guesses = List<JjkWord>.filled(maxGuesses, JjkWord.empty(wordLength));
  }

  JjkWord guess(String guess) {
    final result = matchGuessOnly(guess);
    addGuessToList(result);
    return result;
  }
  
  // NEW: Checks whether the length is correct
  bool isLegalGuess(String guess) => 
      guess.length == wordLength && jjkTargetWords.contains(guess.toLowerCase());

  JjkWord matchGuessOnly(String guess) =>
      JjkWord.fromString(guess, wordLength).evaluateGuess(_wordToGuess);

  void addGuessToList(JjkWord guess) {
    final guessIndex = activeIndex;
    if (guessIndex == -1) throw StateError('No Guesses Remaining');
    _guesses[guessIndex] = guess;
  }

  static JjkWord _generateInitialWord(int? seed, int length) {
    final validWords = jjkTargetWords.where((w) => w.length == length).toList();
    if (validWords.isEmpty) throw StateError('No words found for length $length!');

    if (seed == null) {
      final random = Random();
      return JjkWord.fromString(validWords[random.nextInt(validWords.length)], length);
    } else {
      return JjkWord.fromString(validWords[seed % validWords.length], length);
    }
  }
}

class JjkWord with IterableMixin<JjkLetter> {
  JjkWord(this._letters);

  // NEW: Creates an empty word with dynamic length
  factory JjkWord.empty(int length) =>
      JjkWord(List<JjkLetter>.filled(length, (char: '', type: JjkHitType.none)));

  // NEW: Checks against the requiredLength instead of a hardcoded 5
  factory JjkWord.fromString(String guess, int requiredLength) {
    if (guess.length != requiredLength) {
      throw ArgumentError.value(guess, 'guess', 'Must be exactly $requiredLength characters long');
    }
    final letters = guess
        .toLowerCase()
        .split('')
        .map((char) => (char: char, type: JjkHitType.none))
        .toList();
    return JjkWord(letters);
  }

  final List<JjkLetter> _letters;

  @override
  Iterator<JjkLetter> get iterator => _letters.iterator;

  @override
  bool get isEmpty => every((letter) => letter.char.isEmpty);

  @override
  int get length => _letters.length;

  JjkLetter operator [](int i) => _letters[i];

  @override
  String toString() => _letters.map((letter) => letter.char).join().trim();
}

extension JjkWordUtils on JjkWord {
  bool get isLegalGuess => jjkTargetWords.contains(toString());

  JjkWord evaluateGuess(JjkWord hiddenWord) {
    final result = List<JjkLetter>.filled(length, (char: '', type: JjkHitType.none));
    final unmatchedHiddenLetterCounts = <String, int>{};

    for (var i = 0; i < length; i++) {
      final guessChar = this[i].char;
      final hiddenChar = hiddenWord[i].char;

      if (guessChar == hiddenChar) {
        result[i] = (char: guessChar, type: JjkHitType.hit);
      } else {
        final unmatchedCount = unmatchedHiddenLetterCounts[hiddenChar] ?? 0;
        unmatchedHiddenLetterCounts[hiddenChar] = unmatchedCount + 1;
      }
    }

    for (var i = 0; i < length; i++) {
      if (result[i].type == JjkHitType.hit) continue;

      final guessChar = this[i].char;
      final unmatchedCount = unmatchedHiddenLetterCounts[guessChar] ?? 0;
      final isPartial = unmatchedCount > 0;
      if (isPartial) {
        unmatchedHiddenLetterCounts[guessChar] = unmatchedCount - 1;
      }

      result[i] = (
        char: guessChar,
        type: isPartial ? JjkHitType.partial : JjkHitType.miss,
      );
    }
    return JjkWord(result);
  }
}

// ---------------------------------------------------------
// 2. The UI (Widgets special for JJK)
// ---------------------------------------------------------

class JjkTile extends StatelessWidget {
  const JjkTile(this.letter, this.hitType, {super.key});

  final String letter;
  final JjkHitType hitType;

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
          JjkHitType.hit => const Color(0xFD43FF64), 
          JjkHitType.partial => const Color(0xFFFFFF64), 
          JjkHitType.miss => const Color(0x667D7D7D), 
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

// --- 
class JjkGamePage extends StatefulWidget {
  final int wordLength; // NEW: Accepts word length parameter

  // Default to 5 if nothing is specified
  const JjkGamePage({super.key, this.wordLength = 5});

  @override
  State<JjkGamePage> createState() => _JjkGamePageState();
}

class _JjkGamePageState extends State<JjkGamePage> {
  late JjkGame _game; // NEW: changed to 'late' so we can initialize it dynamically

  @override
  void initState() {
    super.initState();
    // NEW: Initialize game with the dynamically provided wordLength
    _game = JjkGame(wordLength: widget.wordLength);
  }

  @override
  Widget build(BuildContext context) {
    // --- BILDER LOGIK ---
    Widget gojoReaction = const SizedBox(height: 150);
    
    if (_game.didWin) {
      gojoReaction = SizedBox(
        height: 150,
        child: Image.asset('assets/images/gojo_love.png', fit: BoxFit.contain),
      );
    } else if (_game.didLose) {
      gojoReaction = SizedBox(
        height: 150,
        child: Image.asset('assets/images/gojo_fail.png', fit: BoxFit.contain),
      );
    } else if (_game.activeIndex > 0) {
      final lastGuess = _game.previousGuess;
      
      final hasCorrectLetters = lastGuess.any((letter) => 
          letter.type == JjkHitType.hit || letter.type == JjkHitType.partial);
      
      if (hasCorrectLetters) {
        gojoReaction = SizedBox(
          height: 150,
          child: Image.asset('assets/images/gojo_win.png', fit: BoxFit.contain),
        );
      } else {
        gojoReaction = SizedBox(
          height: 150,
          child: Image.asset('assets/images/gojo_fail.png', fit: BoxFit.contain),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          gojoReaction,
          const SizedBox(height: 20),
          for (var guess in _game.guesses)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var letter in guess)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 2.5),
                    child: JjkTile(letter.char, letter.type),
                  )
              ],
            ),
            const SizedBox(height: 20),
            JjkGuessInput(
              expectedLength: widget.wordLength, // NEW: Pass length to input field
              onSubmitGuess: (String guess) {
                // NEW: Validate against dynamic wordLength
                if (guess.length == widget.wordLength && _game.isLegalGuess(guess)) {
                  setState(() {
                    _game.guess(guess);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Wort muss ${widget.wordLength} Buchstaben haben und in der JJK-Datenbank existieren!')),
                  );
                }
              },
            )
        ]
      ),
    );
  }
}

class JjkGuessInput extends StatelessWidget {
  // NEW: Added expectedLength parameter
  JjkGuessInput({super.key, required this.onSubmitGuess, required this.expectedLength});

  final void Function(String) onSubmitGuess;
  final int expectedLength; // NEW
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
              maxLength: expectedLength, // NEW: Limit textfield input to required length
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