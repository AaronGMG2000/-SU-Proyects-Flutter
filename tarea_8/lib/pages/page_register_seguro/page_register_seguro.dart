import 'package:flutter/scheduler.dart';
import 'package:tarea_2/main.dart';
import 'package:flutter/material.dart';
import 'package:tarea_2/models/Seguro.dart';
import 'package:tarea_2/widgets/form_seguro_validation.dart';

class PageRegisterSeguro extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final dynamic seguro;
  final String titulo;
  final bool update;
  final Future<void> Function(Seguro seguro) onSubmit;

  const PageRegisterSeguro({
    Key? key,
    required this.formKey,
    required this.seguro,
    required this.onSubmit,
    required this.titulo,
    this.update = false,
  }) : super(key: key);
  @override
  _PageRegisterSeguroState createState() => _PageRegisterSeguroState();
}

class _PageRegisterSeguroState extends State<PageRegisterSeguro> {
  late bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: Myapp.themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return Scaffold(
            backgroundColor: Myapp.themeNotifier.value == ThemeMode.light
                ? Colors.blue
                : Myapp.themeNotifier.value == ThemeMode.system
                    ? SchedulerBinding.instance.window.platformBrightness ==
                            Brightness.light
                        ? Colors.blue
                        : const Color.fromRGBO(17, 17, 17, 1)
                    : const Color.fromRGBO(17, 17, 17, 1),
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 50, left: 50),
                      child: Text(
                        widget.titulo,
                        style: const TextStyle(
                          fontSize: 26,
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
                  margin: const EdgeInsets.only(top: 100),
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
                            update: widget.update,
                            showSpinner: (bool value) {
                              setState(() {
                                showSpinner = value;
                              });
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                showSpinner
                    ? Container(
                        color: Colors.black54,
                        height: MediaQuery.of(context).size.height,
                        child: const Center(child: CircularProgressIndicator()),
                      )
                    : Container(),
              ],
            ),
          );
        });
  }
}
