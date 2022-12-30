import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/common/constants.dart';

class OptionCard extends StatelessWidget {
  final String option;
  final Color color;
  const OptionCard({super.key, required this.option, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: ListTile(
          title: Text(
        option,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 22.0,
            //we will decide here if the 'color' we're receiving here.
            //what ratio of the red or green colors are in it.
            color: color.red != color.green ? neutral : Colors.black),
      )),
    );
  }
}
