import 'package:flutter/material.dart';

class RepeatInput extends StatefulWidget {
  RepeatInput({this.repeatController, this.periodController});
  final TextEditingController repeatController;
  final TextEditingController periodController;

  _RepeatInputState createState() => _RepeatInputState();
}

class _RepeatInputState extends State<RepeatInput> {
  String _repeatValidator(String s) {
    if (s == null || s.length == 0) return null;
    final i = int.tryParse(s);
    if (i == null) return "Invalid";
    if (i <= 0) return "Too small";
    int period = int.tryParse(widget.periodController.text);
    if (period != null && i > period) {
      return "Too large";
    }
    return null;
  }

  String _periodValidator(String s) {
    if (s == null || s.length == 0) return null;
    final i = int.tryParse(s);
    if (i == null) return "Invalid";
    if (i <= 0) return "Too small";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text("Repeat"),
        Container(
          width: 50,
          child: TextFormField(
            validator: _repeatValidator,
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
            controller: widget.repeatController,
            textAlign: TextAlign.center,
          ),
        ),
        Text("times in"),
        Container(
          width: 50,
          child: TextFormField(
            validator: _periodValidator,
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
            controller: widget.periodController,
            textAlign: TextAlign.center,
          ),
        ),
        Text("days."),
      ],
    );
  }
}
