import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/question.dart';

class AnswerChoiceWidget extends StatefulWidget {
  ///A callback function that must be called with the answer.
  final void Function(List<String> answers) onChange;

  ///The parameter that contains the data pertaining to a question.
  final Question question;

  const AnswerChoiceWidget({
    super.key,
    required this.question,
    required this.onChange,
  });

  @override
  State<AnswerChoiceWidget> createState() => _AnswerChoiceWidgetState();
}

class _AnswerChoiceWidgetState extends State<AnswerChoiceWidget> {
  @override
  Widget build(BuildContext context) {
    return switch (widget.question.answerType) {
      "single" => SingleChoiceAnswer(
        onChange: widget.onChange,
        question: widget.question,
      ),
      "multiple" => MultipleChoiceAnswer(
        onChange: widget.onChange,
        question: widget.question,
      ),
      "text" => SentenceAnswer(
        key: ObjectKey(widget.question),
        onChange: widget.onChange,
        question: widget.question,
      ),
      "date" => DateAnswer(
        onChange: widget.onChange,
        question: widget.question,
      ),
      "file" => FileAnswer(
        onChange: widget.onChange,
        question: widget.question,
      ),
      _ => SizedBox.shrink(),
    };

    // if (widget.question.answerChoices.isNotEmpty) {
    //   if (widget.question.singleChoice) {
    //     return SingleChoiceAnswer(
    //       onChange: widget.onChange,
    //       question: widget.question,
    //     );
    //   } else {
    //     return MultipleChoiceAnswer(
    //       onChange: widget.onChange,
    //       question: widget.question,
    //     );
    //   }
    // } else {
    //   return SentenceAnswer(
    //     key: ObjectKey(widget.question),
    //     onChange: widget.onChange,
    //     question: widget.question,
    //   );
    // }
  }
}

class SingleChoiceAnswer extends StatefulWidget {
  ///A callback function that must be called with the answer.
  final void Function(List<String> answers) onChange;

  ///The parameter that contains the data pertaining to a question.
  final Question question;
  const SingleChoiceAnswer({
    super.key,
    required this.onChange,
    required this.question,
  });

  @override
  State<SingleChoiceAnswer> createState() => _SingleChoiceAnswerState();
}

class _SingleChoiceAnswerState extends State<SingleChoiceAnswer> {
  String? _selectedAnswer;
  @override
  void initState() {
    if (widget.question.answers.isNotEmpty) {
      _selectedAnswer = widget.question.answers.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          widget.question.answerChoices.keys
              .map(
                (answer) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Radio(
                        value: answer,
                        groupValue: _selectedAnswer,
                        onChanged: (value) {
                          setState(() {
                            _selectedAnswer = value as String;
                          });
                          widget.onChange([_selectedAnswer!]);
                        },
                      ),
                      Flexible(fit: FlexFit.loose, child: Text(answer)),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }
}

class MultipleChoiceAnswer extends StatefulWidget {
  ///A callback function that must be called with the answer.
  final void Function(List<String> answers) onChange;

  ///The parameter that contains the data pertaining to a question.
  final Question question;
  const MultipleChoiceAnswer({
    super.key,
    required this.onChange,
    required this.question,
  });

  @override
  State<MultipleChoiceAnswer> createState() => _MultipleChoiceAnswerState();
}

class _MultipleChoiceAnswerState extends State<MultipleChoiceAnswer> {
  late List<String> _answers;

  @override
  void initState() {
    _answers = [];
    _answers.addAll(widget.question.answers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          widget.question.answerChoices.keys
              .map(
                (answer) => Row(
                  children: [
                    Checkbox(
                      value: _answers.contains(answer),
                      onChanged: (value) {
                        if (value == true) {
                          _answers.add(answer);
                        } else {
                          _answers.remove(answer);
                        }
                        widget.onChange(_answers);
                        setState(() {});
                      },
                    ),
                    Flexible(fit: FlexFit.loose, child: Text(answer)),
                  ],
                ),
              )
              .toList(),
    );
  }
}

class SentenceAnswer extends StatefulWidget {
  ///A callback function that must be called with the answer.
  final void Function(List<String> answers) onChange;

  ///The parameter that contains the data pertaining to a question.
  final Question question;
  const SentenceAnswer({
    super.key,
    required this.onChange,
    required this.question,
  });

  @override
  State<SentenceAnswer> createState() => _SentenceAnswerState();
}

class _SentenceAnswerState extends State<SentenceAnswer> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    if (widget.question.answers.isNotEmpty) {
      _textEditingController.text = widget.question.answers.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: _textEditingController,
        onChanged: (value) {
          widget.onChange([_textEditingController.text]);
        },
      ),
    );
  }
}

class DateAnswer extends StatefulWidget {
  const DateAnswer({super.key, required this.onChange, required this.question});
  final void Function(List<String> answers) onChange;
  final Question question;

  @override
  State<DateAnswer> createState() => _DateAnswerState();
}

class _DateAnswerState extends State<DateAnswer> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    if (widget.question.answers.isNotEmpty) {
      _textEditingController.text = widget.question.answers.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final data = await showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          lastDate: DateTime(2999),
        );

        if (data != null) {
          _textEditingController.text = data.toIso8601String().split("T").first;
          widget.onChange([_textEditingController.text]);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: IgnorePointer(
          ignoring: true,
          child: TextFormField(
            controller: _textEditingController,
            decoration: InputDecoration(prefixIcon: Icon(Icons.calendar_month)),
          ),
        ),
      ),
    );
  }
}

class FileAnswer extends StatefulWidget {
  const FileAnswer({super.key, required this.onChange, required this.question});
  final void Function(List<String> answers) onChange;
  final Question question;

  @override
  State<FileAnswer> createState() => _FileAnswerState();
}

class _FileAnswerState extends State<FileAnswer> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    if (widget.question.answers.isNotEmpty) {
      _textEditingController.text =
          widget.question.answers.first.split("/").first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: InkWell(
            onTap: () async {
              final data = await FilePicker.platform.pickFiles();

              if (data != null) {
                widget.onChange([]);
                _textEditingController.text = '';
                // final dataBase64 = <String>[];
                // for (var x in data.xFiles) {
                //   if (dataBase64.isNotEmpty) {
                //     _textEditingController.text =
                //         "${_textEditingController.text}, ";
                //   }
                //   dataBase64.add(base64Encode(await x.readAsBytes()));
                //   _textEditingController.text =
                //       _textEditingController.text + x.name;
                // }

                widget.onChange([
                  "${data.xFiles.first.name}/${base64Encode(await data.xFiles.first.readAsBytes())}",
                ]);
                _textEditingController.text = data.xFiles.first.name;
                // widget.onChange([_textEditingController.text]);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IgnorePointer(
                ignoring: true,
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.file_present),
                  ),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            widget.onChange([]);
            _textEditingController.text = '';
          },
          icon: Icon(Icons.close),
        ),
      ],
    );
  }
}
