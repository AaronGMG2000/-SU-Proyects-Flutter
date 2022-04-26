import 'package:flutter/material.dart';
import 'package:tarea_2/main.dart';

class ButtonModel1 extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color lightColor;
  final Color darkColor;
  final Color lightText;
  final Color darkText;
  final double width;
  final double height;
  final double fontSize;
  final FontWeight fontWeight;
  const ButtonModel1({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.lightColor,
    required this.darkColor,
    this.lightText = Colors.white,
    this.darkText = Colors.white,
    this.width = double.infinity,
    this.height = 60,
    this.fontSize = 15,
    this.fontWeight = FontWeight.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: Myapp.themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: onPressed,
            child: Text(text),
            style: ElevatedButton.styleFrom(
              primary: Myapp.themeNotifier.value == ThemeMode.light
                  ? lightColor
                  : darkColor,
              padding: const EdgeInsets.all(5),
              textStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: Myapp.themeNotifier.value == ThemeMode.light
                    ? lightText
                    : darkText,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        );
      },
    );
  }
}
