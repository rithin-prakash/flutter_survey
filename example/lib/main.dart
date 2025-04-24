import 'package:flutter/material.dart';
import 'package:flutter_survey/flutter_survey.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Survey Demo',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Flutter Survey'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  List<QuestionResult> _questionResults = [];
  final List<Question> _initialData = [
    Question(
      isMandatory: true,
      question: "Please tell us why you like it",
      answerType: 'text',
    ),
    Question(
      isMandatory: true,
      question: "Please tell us why you like it",
      answerType: 'date',
    ),
    // Question(
    //   isMandatory: true,
    //   question: 'Do you like drinking coffee?',
    //   answerType: 'single',
    //   answerChoices: {
    //     "Yes": [
    //       Question(
    //           singleChoice: false,
    //           question: "What are the brands that you've tried?",
    //           answerType: 'multiple',
    //           answerChoices: {
    //             "Nestle": null,
    //             "Starbucks": null,
    //             "Coffee Day": [
    //               Question(
    //                 question: "Did you enjoy visiting Coffee Day?",
    //                 isMandatory: true,
    //                 answerType: 'single',
    //                 answerChoices: {
    //                   "Yes": [
    //                     Question(
    //                       question: "Please tell us why you like it",
    //                       answerType: 'text',
    //                     )
    //                   ],
    //                   "No": [
    //                     Question(
    //                       question: "Please tell us what went wrong",
    //                       answerType: 'text',
    //                     )
    //                   ],
    //                 },
    //               )
    //             ],
    //           })
    //     ],
    //     "No": [
    //       Question(
    //         question: "Do you like drinking Tea then?",
    //         answerType: 'single',
    //         answerChoices: {
    //           "Yes": [
    //             Question(
    //                 question: "What are the brands that you've tried?",
    //                 answerType: 'multiple',
    //                 answerChoices: {
    //                   "Nestle": null,
    //                   "ChaiBucks": null,
    //                   "Indian Premium Tea": [
    //                     Question(
    //                       question: "Did you enjoy visiting IPT?",
    //                       answerType: 'single',
    //                       answerChoices: {
    //                         "Yes": [
    //                           Question(
    //                             question: "Please tell us why you like it",
    //                             answerType: 'text',
    //                           )
    //                         ],
    //                         "No": [
    //                           Question(
    //                             question: "Please tell us what went wrong",
    //                             answerType: 'text',
    //                           )
    //                         ],
    //                       },
    //                     )
    //                   ],
    //                 })
    //           ],
    //           "No": null,
    //         },
    //       )
    //     ],
    //   },
    // ),
    // Question(
    //     question: "What age group do you fall in?",
    //     isMandatory: true,
    //     answerType: 'single',
    //     answerChoices: const {
    //       "18-20": null,
    //       "20-30": null,
    //       "Greater than 30": null,
    //     })
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Survey(
              onNext: (questionResults) {
                _questionResults = questionResults;
              },
              initialData: _initialData),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.cyanAccent, // Background Color
              ),
              child: const Text("Validate"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  print(_questionResults);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
