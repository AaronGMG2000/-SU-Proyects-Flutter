import 'package:flutter/scheduler.dart';
import 'package:tarea_2/main.dart';
import 'package:flutter/material.dart';
import 'package:tarea_2/repository/table_edit_repository.dart';
import 'package:tarea_2/widgets/form_client_validation.dart';
import 'package:tarea_2/widgets/text_input.dart';

class PageEditableView extends StatefulWidget {
  const PageEditableView({
    Key? key,
  }) : super(key: key);

  @override
  _PageEditableView createState() => _PageEditableView();
}

class _PageEditableView extends State<PageEditableView> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: Myapp.themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return Scaffold(
          backgroundColor: Myapp.themeNotifier.value == ThemeMode.light
              ? Colors.blue
              : Myapp.themeNotifier.value == ThemeMode.system
                  ? SchedulerBinding.instance!.window.platformBrightness ==
                          Brightness.light
                      ? Colors.blue
                      : const Color.fromRGBO(17, 17, 17, 1)
                  : const Color.fromRGBO(17, 17, 17, 1),
          body: FutureBuilder(
            future: TableEditRepository.shared.getAll(table: 'editable_table'),
            builder: (BuildContext context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Text('Press button to start.');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    List<dynamic> data = snapshot.requireData as List<dynamic>;
                    Map<String, dynamic> map = data.first;

                    return Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 50, left: 50),
                              child: const Text(
                                "Editable Table",
                                style: TextStyle(
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
                                : Myapp.themeNotifier.value == ThemeMode.system
                                    ? SchedulerBinding.instance!.window
                                                .platformBrightness ==
                                            Brightness.light
                                        ? Colors.white
                                        : const Color.fromRGBO(29, 29, 29, 1)
                                    : const Color.fromRGBO(29, 29, 29, 1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            ),
                          ),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(
                              top: 0,
                            ),
                            itemCount: map.keys.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                ),
                                child: TextInputT(
                                  onEditingComplete: () {},
                                  hinText: map.keys.elementAt(index),
                                  initialValue: "",
                                  iconData: Icons.abc,
                                  controller: TextEditingController(),
                                  inputType: TextInputType.text,
                                  validator: (value) {
                                    return null;
                                  },
                                  onSaved: (value) {},
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    );
                  }
                  return const Text('No data');
              }
            },
          ),
        );
      },
    );
  }
}
