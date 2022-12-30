import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/common/constants.dart';
import 'package:flutter_quiz_app/models/db_connect.dart';
import 'package:flutter_quiz_app/models/question_model.dart';
import 'package:flutter_quiz_app/widgets/next_question.dart';
import 'package:flutter_quiz_app/widgets/options_card.dart';
import 'package:flutter_quiz_app/widgets/question_widget.dart';
import 'package:flutter_quiz_app/widgets/result_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var db = DBconnect();
  /*final List<Question> _questions = [
    Question(
        id: "1",
        title: "Quelle est la capitale de la République Congo ?",
        options: {"1": false, "2": true, "3": false}),
    Question(
        id: "2",
        title: "Quelle est la chaîne de montagne la plus haute du monde ?",
        options: {"1": false, "2": true, "3": false})
  ];*/

  late Future _questions;

  Future<List<Question>> getData() async {
    return db.fetchQuestions();
  }

  //create an index to loo throught the questions
  int index = 0;

  //boolean to checked if the user has clicked the button
  bool isPressed = false;

  @override
  void initState() {
    _questions = getData();
    super.initState();
  }

  //create a function for changing color
  void checkAnswerAndUpdate(bool value) {
    if (isAlreadySelected) {
      return;
    } else {
      if (value == true) {
        score++;
      }
      setState(() {
        isPressed = true;
        isAlreadySelected = true;
      });
    }
  }

  //function to display the next question
  void nextQuestion(int questionLength) {
    if (index == questionLength - 1) {
      // this is the block when the question end
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (ctx) => ResultBox(
                result: score,
                questionLength: questionLength,
                onPressed: startOver,
              ));
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "plase select any option",
            style: TextStyle(fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical: 20.0),
        ));
      }
    }
  }

  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
    });
    Navigator.pop(context);
  }

  //create a score variable
  int score = 0;

  //boolean is already selected
  bool isAlreadySelected = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _questions as Future<List<Question>>,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            var extractedData = snapshot.data as List<Question>;
            return Scaffold(
              backgroundColor: background,
              appBar: AppBar(
                title: const Text("Quiz App"),
                shadowColor: Colors.transparent,
                backgroundColor: background,
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Score: $score',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  )
                ],
              ),
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: double.infinity,
                child: Column(
                  children: [
                    //add the question widget here
                    QuestionWidget(
                      indexAction: index,
                      question: extractedData[index].title,
                      totalQuestions: extractedData.length,
                    ),
                    const Divider(
                      color: neutral,
                    ),
                    const SizedBox(height: 25.0),
                    for (int i = 0;
                        i < extractedData[index].options.length;
                        i++)
                      GestureDetector(
                        onTap: () => checkAnswerAndUpdate(
                            extractedData[index].options.values.toList()[i]),
                        child: OptionCard(
                          option: extractedData[index].options.keys.toList()[i],
                          color: isPressed
                              ? extractedData[index]
                                          .options
                                          .values
                                          .toList()[i] ==
                                      true
                                  ? correct
                                  : incorrect
                              : neutral,
                        ),
                      ),
                  ],
                ),
              ),
              floatingActionButton: GestureDetector(
                onTap: () => nextQuestion(extractedData.length),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: NextButton(),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          }
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Plase wait, while questions are loading...",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.none,
                      fontSize: 14.0),
                )
              ],
            ),
          );
        }
        return const Center(
          child: Text('No data'),
        );
      },
    );
  }
}
