import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/common/constants.dart';

class ResultBox extends StatelessWidget {
  const ResultBox(
      {super.key,
      required this.result,
      required this.questionLength,
      required this.onPressed});

  final int result;
  final int questionLength;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: background,
      content: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Result',
              style: TextStyle(color: neutral, fontSize: 24.0),
            ),
            const SizedBox(
              height: 20.0,
            ),
            CircleAvatar(
                child: Text(
                  '$result/$questionLength',
                  style: TextStyle(fontSize: 30.0),
                ),
                radius: 70.0,
                backgroundColor: result == questionLength / 2
                    ? Colors.yellow
                    : result < questionLength / 2
                        ? incorrect
                        : correct),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              result == questionLength / 2
                  ? 'Almost there'
                  : result < questionLength / 2
                      ? 'try again'
                      : 'Great !',
              style: const TextStyle(color: neutral, fontSize: 15.0),
            ),
            const SizedBox(
              height: 25.0,
            ),
            GestureDetector(
              onTap: onPressed,
              child: const Text(
                "Start over",
                style: TextStyle(
                    color: Colors.blue, fontSize: 20.0, letterSpacing: 1.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
