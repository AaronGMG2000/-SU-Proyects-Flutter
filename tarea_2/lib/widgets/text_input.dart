import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String hinText;
  final TextInputType inputType;
  final TextEditingController controller;
  final int maxlines;
  final bool obscureText;
  final FormFieldValidator validator;
  final Function(String?) onSaved;
  const TextInput({
    Key? key,
    required this.hinText,
    required this.controller,
    required this.validator,
    required this.onSaved,
    this.inputType = TextInputType.text,
    this.obscureText = false,
    this.maxlines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        onSaved: onSaved,
        validator: validator,
        obscureText: obscureText,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxlines,
        style: const TextStyle(
          fontSize: 15,
          fontFamily: 'Lato',
          color: Colors.blueGrey,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          filled: true,
          hintText: hinText,
          fillColor: const Color(0xFFe5e5e5),
          border: InputBorder.none,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFe5e5e5)),
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFe5e5e5)),
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
        ),
      ),
    );
  }
}
