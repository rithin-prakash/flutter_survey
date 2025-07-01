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
    final size = MediaQuery.sizeOf(context);

    return Wrap(
      // mainAxisAlignment: MainAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: List.from(
        widget.question.answerChoices.keys.map(
          (answer) => SizedBox(
            width: size.width / 2 - 30,
            child: ListTile(
              leading: Radio(
                value: answer,
                groupValue: _selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    _selectedAnswer = value as String;
                  });
                  widget.onChange([_selectedAnswer!]);
                },
              ),

              contentPadding: EdgeInsets.zero,
              title: Text(answer),
            ),
          ),
        ),
      ),
    );

    //  Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children:
    //       widget.question.answerChoices.keys
    //           .map(
    //             (answer) => Padding(
    //               padding: const EdgeInsets.symmetric(vertical: 4),
    //               child: Row(
    //                 children: [
    //                   Radio(
    //                     value: answer,
    //                     groupValue: _selectedAnswer,
    //                     onChanged: (value) {
    //                       setState(() {
    //                         _selectedAnswer = value as String;
    //                       });
    //                       widget.onChange([_selectedAnswer!]);
    //                     },
    //                   ),
    //                   Flexible(fit: FlexFit.loose, child: Text(answer)),
    //                 ],
    //               ),
    //             ),
    //           )
    //           .toList(),
    // );
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
    final size = MediaQuery.sizeOf(context);

    return Wrap(
      // mainAxisAlignment: MainAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: List.from(
        widget.question.answerChoices.keys.map(
          (answer) => SizedBox(
            width: size.width / 2 - 30,
            child: ListTile(
              leading: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(width: .1, color: Colors.grey.shade100),
                ),
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

              contentPadding: EdgeInsets.zero,
              title: Text(answer),
            ),
          ),
        ),
      ),
    );

    // Column(
    //   children:
    //       widget.question.answerChoices.keys
    //           .map(
    //             (answer) => Row(
    //               children: [
    //                 Checkbox(
    //                   value: _answers.contains(answer),
    //                   onChanged: (value) {
    //                     if (value == true) {
    //                       _answers.add(answer);
    //                     } else {
    //                       _answers.remove(answer);
    //                     }
    //                     widget.onChange(_answers);
    //                     setState(() {});
    //                   },
    //                 ),
    //                 Flexible(fit: FlexFit.loose, child: Text(answer)),
    //               ],
    //             ),
    //           )
    //           .toList(),
    // );
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
    var borderRadius = 14.0;
    var borderColor = const Color.fromARGB(255, 172, 177, 184);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: _textEditingController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(width: 1, color: borderColor),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(width: 1, color: borderColor),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(width: 1, color: Colors.red),
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(width: 1, color: borderColor),
          ),
        ),
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
    var borderRadius = 14.0;
    var borderColor = const Color.fromARGB(255, 172, 177, 184);
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
            decoration: InputDecoration(
              suffixIcon: Image.asset(
                'packages/flutter_survey/assets/calendar.png',
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(width: 1, color: borderColor),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(width: 1, color: borderColor),
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(width: 1, color: Colors.red),
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(width: 1, color: borderColor),
              ),
            ),
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
    var borderRadius = 14.0;
    var borderColor = const Color.fromARGB(255, 172, 177, 184);
    return widget.question.answers.isNotEmpty
        ? Container(
          // height: 60,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('packages/flutter_survey/assets/file.png'),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      widget.question.answers.first.split("/").first,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  widget.onChange([]);
                  _textEditingController.text = '';
                },
                child: Icon(Icons.close),
              ),
            ],
          ),
        )
        : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InkWell(
            onTap: () async {
              final data = await FilePicker.platform.pickFiles();

              if (data != null) {
                widget.onChange([]);
                _textEditingController.text = '';

                widget.onChange([
                  "${data.xFiles.first.name}/${base64Encode(await data.xFiles.first.readAsBytes())}",
                ]);
                _textEditingController.text = data.xFiles.first.name;
                // widget.onChange([_textEditingController.text]);
              }
            },
            child: IgnorePointer(
              ignoring: true,
              child: TextFormField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  prefixIcon: Image.asset(
                    'packages/flutter_survey/assets/file.png',
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(width: 1, color: borderColor),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(width: 1, color: borderColor),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: const BorderSide(width: 1, color: Colors.red),
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(width: 1, color: borderColor),
                  ),
                ),
              ),
            ),
          ),
        );
  }
}
