import 'dart:convert';

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

  final json = {
    "questions": [
      {
        "id": "pep",
        "type": "single", //muilple, text, date, file
        "title": "Question 1",
        "question": "Are you a politically exposed person (PEP)?",
        "mandatory": true,
        "choices": [
          {
            "answer": "Yes",
            "id": "pep_yes",
            "question": [
              {
                "type": "text",
                "title": "Question 2",
                "id": "role",
                "question": "What is your role?",
                "mandatory": true
              }
            ]
          },
          {"answer": "No", "id": "pep_no"},
        ]
      },
      {
        "id": "soi",
        "type": "multiple",
        "title": "Question 3",
        "question": "What is your primary source of income?",
        "mandatory": true,
        "choices": [
          {
            "answer": "Salary",
            "id": "soi_salary",
            "question": [
              {
                "type": "single",
                "id": "occupation",
                "title": "Question 4",
                "question": "Choose your occupation",
                "mandatory": true,
                "choices": [
                  {
                    "answer": "Software Engineer",
                    "id": "occupation_software_engineer"
                  },
                  {"answer": "Manager", "id": "occupation_Manager"},
                  {"answer": "Driver", "id": "occupation_driver"},
                  {"answer": "Technician", "id": "occupation_technician"}
                ]
              }
            ]
          },
          {"answer": "Businesss", "id": "soi_businesss"}
        ]
      },
      {
        "id": "change_address",
        "type": "single",
        "title": "Question 5",
        "question":
            "Have you changed your residential address in the last 12 months?",
        "mandatory": true,
        "choices": [
          {
            "answer": "Yes",
            "id": "change_address_yes",
            "question": [
              {
                "type": "date",
                "id": "change_address_date",
                "title": "Question 6",
                "question": "When the address change has happened?",
                "mandatory": true
              }
            ]
          },
          {
            "answer": "No",
            "id": "change_address_no",
            "question": [
              {
                "type": "file",
                "title": "Question 6",
                "id": "change_address_proof",
                "question": "Attach current address proof",
                "mandatory": true
              }
            ]
          }
        ]
      }
    ]
  };

  final map = <Map<String, dynamic>>[];

  answerMap(List<QuestionResult> result, String? parentId) {
    for (var i in result) {
      print(i.question);

      map.add({
        "id": i.id,
        "question": i.question,
        "answers": answers(i.type, i.answers),
        "parent_question_id": parentId
      });
      answerMap(i.children, i.id);
    }
  }

  List<String> answers(String type, List<String> rawAns) {
    switch (type) {
      case "file":
        return List<String>.from(rawAns.map<String>((e) {
          var x = e.split("/");
          x.removeAt(0);
          return x.join();
        }));
      default:
        return rawAns;
    }
  }

  List<Question>? questionMap(List<Map<String, dynamic>>? json) {
    if (json == null) {
      return null;
    }
    return List<Question>.from(
      json.map(
        (e) {
          return Question(
              id: e['id'].toString(),
              question: e['question'].toString(),
              isMandatory: (e['mandatory'] as bool?) ?? false,
              answerType: e['type'].toString().toLowerCase(),
              answerChoices: e['choices'] == null
                  ? null
                  : {
                      for (var v in e['choices'])
                        v['answer']: questionMap(v['question'])
                    });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    initForm();
  }

  List<Question> qList = [];

  initForm() {
    qList = questionMap(json['questions']) ?? [];
  }

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
              initialData: qList),
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
                  map.clear();
                  answerMap(_questionResults, null);
                  print(jsonEncode(map));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
