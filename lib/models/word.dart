import 'package:equatable/equatable.dart';

import 'letter.dart';

class Word extends Equatable {
  final List<Letter> letters;

  const Word({
    required this.letters,
  });

  factory Word.fromString(String word) =>
      Word(letters: word.split('').map((e) => Letter(val: e)).toList());

  String get wordString => letters.map((e) => e.val).join();

  void addLetter(String val) {
    final currentIndex = letters.indexWhere((e) => e.val.isEmpty);
    if (currentIndex != -1) {
      letters[currentIndex] = Letter(val: val);
    }
  }

  void removeLetter() {
    final recentIndex = letters.lastIndexWhere((e) => e.val.isNotEmpty);
    if (recentIndex != -1) {
      letters[recentIndex] = Letter.empty();
    }
  }

  @override
  List<Object> get props => [letters];

  // Word copyWith({
  //   int? id,
  //   List<Letter>? letters,
  // }) {
  //   return Word(letters: letters ?? this.letters);
  // }
}
