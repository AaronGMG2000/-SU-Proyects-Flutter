import 'package:flutter/material.dart';
import 'package:tarea_2/main.dart';

class ButtonModel2 extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color lightColor;
  final Color darkColor;
  final Color lightText;
  final Color darkText;
  final double width;
  final double height;
  final double fontSize;
  final double iconSize;
  final bool isIcon;
  final FontWeight fontWeight;
  final IconData iconButton;
  const ButtonModel2({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.lightColor,
    required this.darkColor,
    required this.iconButton,
    this.lightText = Colors.white,
    this.darkText = Colors.white,
    this.width = double.infinity,
    this.height = 60,
    this.fontSize = 20,
    this.iconSize = 40,
    this.isIcon = true,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      Icon(
                        iconButton,
                        size: iconSize,
                        color: Myapp.themeNotifier.value == ThemeMode.light
                            ? lightText
                            : darkText,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 30),
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: fontWeight,
                            color: Myapp.themeNotifier.value == ThemeMode.light
                                ? lightText
                                : darkText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                isIcon
                    ? Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: iconSize,
                          color: Myapp.themeNotifier.value == ThemeMode.light
                              ? lightText
                              : darkText,
                        ),
                      )
                    : Container(),
              ],
            ),
            style: ElevatedButton.styleFrom(
              primary: Myapp.themeNotifier.value == ThemeMode.light
                  ? lightColor
                  : darkColor,
              padding: const EdgeInsets.all(5),
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
