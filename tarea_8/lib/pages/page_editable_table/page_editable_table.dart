import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tarea_2/main.dart';
import 'package:tarea_2/pages/page_editable_table/page_editable_view.dart';
import 'package:tarea_2/repository/table_edit_repository.dart';
import 'package:tarea_2/widgets/button_model1.dart';
import 'package:tarea_2/widgets/navigation_drawer_widget.dart';
import 'package:tarea_2/widgets/text_input.dart';

class PageEditableTable extends StatelessWidget {
  const PageEditableTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String parameter = "";
    final _formKey = GlobalKey<FormState>();
    late String type = "";
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: Myapp.themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return Scaffold(
          drawer: const NavigationDrawerWidget(),
          backgroundColor: Myapp.themeNotifier.value == ThemeMode.light
              ? Colors.blue
              : Myapp.themeNotifier.value == ThemeMode.system
                  ? SchedulerBinding.instance.window.platformBrightness ==
                          Brightness.light
                      ? Colors.blue
                      : const Color.fromRGBO(17, 17, 17, 1)
                  : const Color.fromRGBO(17, 17, 17, 1),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const PageEditableView();
              }));
            },
            child: const Icon(Icons.visibility),
          ),
          appBar: AppBar(
            title: const Text("Tabla Modificable"),
            backgroundColor: Myapp.themeNotifier.value == ThemeMode.light
                ? Colors.blue
                : Myapp.themeNotifier.value == ThemeMode.system
                    ? SchedulerBinding.instance.window.platformBrightness ==
                            Brightness.light
                        ? Colors.blue
                        : const Color.fromRGBO(17, 17, 17, 1)
                    : const Color.fromRGBO(17, 17, 17, 1),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    alignment: Alignment.center,
                    child: const Text(
                      "Ingrese nuevos campos en la tabla",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    alignment: Alignment.center,
                    child: const Text(
                      "Ingrese el nuevo parametro y tipo para insertar en la tabla",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(79, 79, 79, 1),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 150),
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
                  scrollDirection: Axis.vertical,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextInputT(
                              onEditingComplete: () {},
                              hinText: "Nuevo Parametro",
                              initialValue: "",
                              iconData: Icons.abc,
                              controller: TextEditingController(),
                              inputType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, introduzca el nombre del parametro';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null && value.isNotEmpty) {
                                  parameter = value;
                                }
                              },
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: TextInputT(
                                onEditingComplete: () {},
                                initialValue: "",
                                hinText: "Tipo",
                                iconData: Icons.abc,
                                controller: TextEditingController(),
                                inputType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, introduzca el tipo del parametro';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    type = value;
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 20),
                              child: ButtonModel1(
                                text: "Modificar tabla",
                                fontSize: 16,
                                lightColor: Colors.blue,
                                darkColor:
                                    const Color.fromRGBO(174, 124, 232, 1),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    await TableEditRepository.shared.editTable(
                                        tableName: "editable_table",
                                        parameter: parameter,
                                        type: type);
                                    _formKey.currentState!.reset();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Tabla modificada")),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
