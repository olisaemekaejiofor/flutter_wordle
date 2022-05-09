import 'package:flutter/material.dart';

import '../models/letter.dart';
import 'custom_keys.dart';

const _keys = [
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
  ['ENTER', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'DEL']
];

class CustomKeyBoard extends StatelessWidget {
  final void Function(String) onKeyTap;
  final VoidCallback onEnter;
  final VoidCallback onBack;

  final Set<Letter> letters;

  const CustomKeyBoard({
    Key? key,
    required this.onKeyTap,
    required this.onEnter,
    required this.onBack,
    required this.letters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _keys
          .map(
            (keyRow) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: keyRow.map(
                (letter) {
                  if (letter == 'DEL') {
                    return CustomKey.delete(
                      onTap: onBack,
                    );
                  } else if (letter == 'ENTER') {
                    return CustomKey.enter(onTap: onEnter);
                  }

                  final letterKey = letters.firstWhere(
                    (e) => e.val == letter,
                    orElse: () => Letter.empty(),
                  );

                  return CustomKey(
                    text: letter,
                    onTap: () => onKeyTap(letter),
                    backgoundColor: letterKey != Letter.empty()
                        ? letterKey.background
                        : Colors.black54,
                  );
                },
              ).toList(),
            ),
          )
          .toList(),
    );
  }
}
