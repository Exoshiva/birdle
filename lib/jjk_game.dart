import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';

// ---- Game Logic and Data Models -----
enum JjkHitType { none, hit, partial, miss }
typedef JjkLetter = ({String char, JjkHitType type});

const List<String> jjkLegalWords = [
  'panda',
  'yuuji',
  'touji',
  'getou',
  'choso',
  'curse',
  'tokyo',
  'kyoto',
  'demon',
];

const List<String> jjkTargetWords = [...jjkLegalWords];

class JjkGame {
  static const int defaultMaxGuesses = 5;

  JjkGame({this.maxGuesses = defaultMaxGuesses, this.seed})
      : _wordToGuess = _generateInitialWord(seed),
        _guesses = List<JjkWord>.filled(maxGuesses, JjkWord.empty());

  final int maxGuesses;
  final int? seed;
  JjkWord _wordToGuess;
  List<JjkWord> _guesses;

  JjkWord get hiddenWord => _wordToGuess;
  UnmodifiableListView<JjkWord> get guesses => UnmodifiableListView(_guesses);

  JjkWord get previousGuess {
    final index = _guesses.lastIndexWhere((word) => word.isNotEmpty);
    return index == -1 ? JjkWord.empty() : _guesses[index];
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
    _wordToGuess = _generateInitialWord(seed);
    _guesses = List<JjkWord>.filled(maxGuesses, JjkWord.empty());
  }

  JjkWord guess(String guess) {
    final result = matchGuessOnly(guess);
    addGuessToList(result);
    return result;
  }

  bool isLegalGuess(String guess) => JjkWord.fromString(guess).isLegalGuess;

  JjkWord matchGuessOnly(String guess) =>
      JjkWord.fromString(guess).evaluateGuess(_wordToGuess);

  void addGuessToList(JjkWord guess) {
    final guessIndex = activeIndex;
    if (guessIndex == -1) throw StateError('No Guesses Remaining');
    _guesses[guessIndex] = guess;
  } // HIER FEHLTE DIE KLAMMER!

  static JjkWord _generateInitialWord(int? seed) =>
      seed == null ? JjkWord.random() : JjkWord.fromSeed(seed);
}

class JjkWord with IterableMixin<JjkLetter> {
  JjkWord(this._letters);

  factory JjkWord.empty() =>
      JjkWord(List<JjkLetter>.filled(5, (char: '', type: JjkHitType.none)));

  factory JjkWord.fromString(String guess) {
    if (guess.length != 5) {
      throw ArgumentError.value(guess, 'guess', 'Must be exactly 5 characters long');
    }
    final letters = guess
        .toLowerCase()
        .split('')
        .map((char) => (char: char, type: JjkHitType.none))
        .toList();
    return JjkWord(letters);
  }

  factory JjkWord.random() {
    final random = Random();
    final nextWord = jjkLegalWords[random.nextInt(jjkLegalWords.length)];
    return JjkWord.fromString(nextWord);
  }
}