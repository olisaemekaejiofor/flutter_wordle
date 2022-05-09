import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:wordle_clone/models/letter.dart';
import 'package:wordle_clone/words.dart';
import 'models/word.dart';
import 'widgets/custom_keyboard.dart';

enum GameStatus { playing, submitting, lost, won }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GameStatus _gameStatus = GameStatus.playing;
  final List<Word> _board =
      List.generate(6, (_) => Word(letters: List.generate(5, (_) => Letter.empty())));

  final List<List<GlobalKey<FlipCardState>>> _flipCards =
      List.generate(6, (_) => List.generate(5, (_) => GlobalKey<FlipCardState>()));

  int _currentWordIndex = 0;

  Word? get _currentWord =>
      _currentWordIndex < _board.length ? _board[_currentWordIndex] : null;

  Word _solution = Word.fromString(
      fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase());

  final Set<Letter> _keyBoardLetters = {};

  final ConfettiController _controller = ConfettiController();
  final ConfettiController _controller1 = ConfettiController();

  void _onBack() {
    if (_gameStatus == GameStatus.playing) {
      setState(() => _currentWord?.removeLetter());
    }
  }

  void _onKeyTap(String val) {
    if (_gameStatus == GameStatus.playing) {
      setState(() => _currentWord?.addLetter(val));
    }
  }

  Future<void> _onEnter() async {
    if (_gameStatus == GameStatus.playing &&
        _currentWord != null &&
        !_currentWord!.letters.contains(Letter.empty())) {
      _gameStatus = GameStatus.submitting;

      for (var i = 0; i < _currentWord!.letters.length; i++) {
        final currentWordLetter = _currentWord!.letters[i];
        final currentSolutionLetter = _solution.letters[i];

        setState(() {
          if (currentWordLetter == currentSolutionLetter) {
            _currentWord!.letters[i] =
                currentWordLetter.copyWith(status: LetterStatus.correct);
          } else if (_solution.letters.contains(currentWordLetter)) {
            _currentWord!.letters[i] =
                currentWordLetter.copyWith(status: LetterStatus.inWord);
          } else {
            _currentWord!.letters[i] =
                currentWordLetter.copyWith(status: LetterStatus.notInWord);
          }
        });

        await Future.delayed(
          const Duration(milliseconds: 150),
          () {
            final letter = _keyBoardLetters.firstWhere(
                (e) => e.val == currentWordLetter.val,
                orElse: () => Letter.empty());
            if (letter.status != LetterStatus.correct) {
              _keyBoardLetters
                  .removeWhere((element) => element.val == currentWordLetter.val);
              _keyBoardLetters.add(_currentWord!.letters[i]);
            }
            _flipCards[_currentWordIndex][i].currentState?.toggleCard();
          },
        );
      }
      _checkWin();
    }
  }

  void _checkWin() {
    if (_currentWord!.wordString == _solution.wordString) {
      _gameStatus = GameStatus.won;
      _controller.play();
      _controller1.play();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.none,
          duration: const Duration(days: 1),
          backgroundColor: Colors.green,
          content: const Text(
            'You Won',
            style: TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            label: 'New Game',
            onPressed: _restart,
            textColor: Colors.white,
          ),
        ),
      );
    } else if (_currentWordIndex + 1 >= _board.length) {
      _gameStatus = GameStatus.lost;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.none,
          duration: const Duration(days: 1),
          backgroundColor: Colors.redAccent[200],
          content: Text(
            'You lost! Solution: ${_solution.wordString}',
            style: const TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            label: 'New Game',
            onPressed: _restart,
            textColor: Colors.white,
          ),
        ),
      );
    } else {
      _gameStatus = GameStatus.playing;
    }
    _currentWordIndex += 1;
  }

  void _restart() {
    setState(() {
      _gameStatus = GameStatus.playing;
      _currentWordIndex = 0;
      _board
        ..clear()
        ..addAll(
          List.generate(
            6,
            (_) => Word(
              letters: List.generate(5, (_) => Letter.empty()),
            ),
          ),
        );
      _solution = Word.fromString(
          fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase());
      _keyBoardLetters.clear();
      _flipCards
        ..clear()
        ..addAll(
            List.generate(6, (_) => List.generate(5, (_) => GlobalKey<FlipCardState>())));
      _controller.stop();
      _controller1.stop();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _controller1.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          backgroundColor: Colors.black.withBlue(25).withOpacity(0.5),
          appBar: _buildAppBar(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBoard(board: _board, flipCardKeys: _flipCards),
              const SizedBox(height: 50),
              CustomKeyBoard(
                onBack: _onBack,
                onKeyTap: _onKeyTap,
                onEnter: _onEnter,
                letters: _keyBoardLetters,
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 100,
          child: ConfettiWidget(
            confettiController: _controller,
            blastDirection: pi,
            gravity: 0.1,
            emissionFrequency: 0.1,
            maxBlastForce: 150,
            minBlastForce: 50,
          ),
        ),
        Positioned(
          left: 0,
          top: 100,
          child: ConfettiWidget(
            confettiController: _controller1,
            blastDirection: pi * 4,
            gravity: 0.1,
            emissionFrequency: 0.1,
            maxBlastForce: 150,
            minBlastForce: 50,
          ),
        ),
      ],
    );
  }

  Widget _buildBoard(
      {required List<Word> board,
      required List<List<GlobalKey<FlipCardState>>> flipCardKeys}) {
    return Column(
      children: board
          .asMap()
          .map(
            (i, word) => MapEntry(
              i,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: word.letters
                    .asMap()
                    .map(
                      (j, letter) => MapEntry(
                        j,
                        FlipCard(
                          key: flipCardKeys[i][j],
                          flipOnTouch: false,
                          direction: FlipDirection.VERTICAL,
                          front: _boardTile(
                              letter:
                                  Letter(val: letter.val, status: LetterStatus.initial)),
                          back: _boardTile(letter: letter),
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
            ),
          )
          .values
          .toList(),
    );
  }

  Widget _boardTile({required Letter letter}) {
    return Container(
      margin: const EdgeInsets.all(4),
      height: 48,
      width: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: letter.background,
        border: Border.all(color: letter.borderColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        letter.val,
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Wordle Clone'.toUpperCase(),
        style: const TextStyle(fontSize: 25, color: Colors.white),
      ),
    );
  }
}
