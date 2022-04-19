import 'package:tarea_2/main.dart';
import 'package:flutter/material.dart';
import 'package:tarea_2/widgets/form_seguro_validation.dart';

class PageRegisterSeguro extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final dynamic seguro;
  final Future<int> Function(dynamic seguro) onSubmit;

  const PageRegisterSeguro({
    Key? key,
    required this.formKey,
    required this.seguro,
    required this.onSubmit,
  }) : super(key: key);
  @override
  _PageRegisterSeguroState createState() => _PageRegisterSeguroState();
}

class _PageRegisterSeguroState extends State<PageRegisterSeguro> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: Myapp.themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return Scaffold(
            backgroundColor: Myapp.themeNotifier.value == ThemeMode.light
                ? Colors.blue
                : const Color.fromRGBO(17, 17, 17, 1),
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 110, left: 50),
                      child: const Text(
                        "Creación de Seguros",
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontFamily: "SegoeUI",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20, left: 50),
                      child: const Text(
                        "Complete los campos y precione guardar para continuar",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: "SegoeUI",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 230),
                  padding: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Myapp.themeNotifier.value == ThemeMode.light
                        ? Colors.white
                        : const Color.fromRGBO(29, 29, 29, 1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.only(
                      top: 0,
                    ),
                    scrollDirection: Axis.vertical,
                    children: [
                      Column(
                        children: [
                          FormSeguroValidation(
                            formKey: widget.formKey,
                            onSubmit: widget.onSubmit,
                            seguro: widget.seguro,
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
