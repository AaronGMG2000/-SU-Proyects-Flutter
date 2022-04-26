import 'package:flutter/material.dart';

class CheckboxModel extends StatefulWidget {
  final bool rememberMe;
  final Function(bool) onChanged;
  final String text;
  const CheckboxModel({
    Key? key,
    required this.rememberMe,
    required this.onChanged,
    required this.text,
  }) : super(key: key);

  @override
  _CheckboxModelState createState() => _CheckboxModelState();
}

class _CheckboxModelState extends State<CheckboxModel> {
  bool rememberMe = false;
  void _onRememberMeChanged(bool? newValue) => setState(() {
        rememberMe = newValue!;
        widget.onChanged(rememberMe);
      });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: _onRememberMeChanged,
        ),
        Container(
          margin: const EdgeInsets.only(left: 5),
          child: Text(
            widget.text,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
