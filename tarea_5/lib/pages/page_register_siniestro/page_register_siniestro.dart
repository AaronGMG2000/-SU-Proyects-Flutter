import 'package:tarea_2/main.dart';
import 'package:flutter/material.dart';
import 'package:tarea_2/models/siniestro.dart';
import 'package:tarea_2/widgets/form_siniestro_validation.dart';

class PageRegisterSiniestro extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Siniestro siniestro;
  final String titulo;
  final bool update;
  final Future<void> Function(Siniestro cliente) onSubmit;

  const PageRegisterSiniestro({
    Key? key,
    required this.formKey,
    required this.siniestro,
    required this.onSubmit,
    required this.titulo,
    this.update = false,
  }) : super(key: key);

  @override
  _PageRegisterSiniestro createState() => _PageRegisterSiniestro();
}

class _PageRegisterSiniestro extends State<PageRegisterSiniestro> {
  late bool showSpinner = false;
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
                          FormSiniestroValidation(
                            formKey: widget.formKey,
                            onSubmit: widget.onSubmit,
                            siniestro: widget.siniestro,
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
