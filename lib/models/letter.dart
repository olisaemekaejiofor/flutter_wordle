import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:wordle_clone/main.dart';

enum LetterStatus { initial, notInWord, inWord, correct }

class Letter extends Equatable {
  final String val;
  final LetterStatus? status;

  const Letter({
    required this.val,
    this.status = LetterStatus.initial,
  });

  factory Letter.empty() => const Letter(val: '');

  Color get background {
    switch (status) {
      case LetterStatus.notInWord:
        return notInWord;
      case LetterStatus.inWord:
        return inWord;
      case LetterStatus.correct:
        return correctColor;
      default:
        return Colors.transparent;
    }
  }

  Color get borderColor {
    switch (status) {
      case LetterStatus.initial:
        return Colors.grey;
      default:
        return Colors.transparent;
    }
  }

  Letter copyWith({
    String? val,
    LetterStatus? status,
  }) {
    return Letter(
      val: val ?? this.val,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [val, status];
}
