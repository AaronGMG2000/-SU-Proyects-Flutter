import 'package:flutter/material.dart';
import 'package:tarea_2/main.dart';

class TextInput extends StatefulWidget {
  final String hinText;
  final String initialValue;
  final TextInputType inputType;
  final TextEditingController controller;
  final int maxlines;
  final FormFieldValidator validator;
  final Function(String?) onSaved;
  final IconData iconData;
  final double padingL;
  final double padingR;
  const TextInput({
    Key? key,
    required this.initialValue,
    required this.hinText,
    required this.controller,
    required this.validator,
    required this.onSaved,
    required this.iconData,
    this.inputType = TextInputType.text,
    this.maxlines = 1,
    this.padingL = 20,
    this.padingR = 20,
  }) : super(key: key);

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  late bool obscureText = true;
  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: Myapp.themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          Color color = Myapp.themeNotifier.value == ThemeMode.light
              ? const Color.fromRGBO(232, 232, 232, 1)
              : const Color.fromRGBO(80, 80, 80, 1);
          return Container(
            padding: EdgeInsets.only(
              left: widget.padingL,
              right: widget.padingR,
            ),
            child: TextFormField(
              onSaved: widget.onSaved,
              validator: widget.validator,
              obscureText: widget.inputType == TextInputType.visiblePassword
                  ? obscureText
                  : false,
              controller: widget.controller,
              keyboardType: widget.inputType,
              maxLines: widget.maxlines,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Lato',
                color: Myapp.themeNotifier.value == ThemeMode.light
                    ? const Color.fromRGBO(76, 76, 76, 1)
                    : const Color.fromRGBO(253, 253, 253, 1),
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                filled: true,
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  child: widget.inputType == TextInputType.visiblePassword
                      ? Icon(
                          widget.iconData,
                          color: obscureText
                              ? Myapp.themeNotifier.value == ThemeMode.light
                                  ? const Color.fromRGBO(76, 76, 76, 1)
                                  : const Color.fromRGBO(253, 253, 253, 1)
                              : Colors.blue,
                        )
                      : Icon(
                          widget.iconData,
                        ),
                ),
                hintText: widget.hinText,
                fillColor: color,
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: color),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: color),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
              ),
            ),
          );
        });
  }
}
