import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:tarea_2/bloc/basic_bloc/basic_bloc.dart';
import 'package:tarea_2/localizations/localizations.dart';
import 'package:tarea_2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea_2/provider/language_provider.dart';
import 'package:tarea_2/repository/app_preferences.dart';
import 'package:tarea_2/util/app_string.dart';
import 'package:tarea_2/util/realTimeDatabase.dart';
import 'package:tarea_2/widgets/dropdownbutton1.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({
    Key? key,
  }) : super(key: key);

  @override
  _PageSettingsState createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locatizations = AppLocalizations(Localizations.localeOf(context));
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: Myapp.themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Myapp.themeNotifier.value == ThemeMode.light
                ? Colors.blue
                : Myapp.themeNotifier.value == ThemeMode.system
                    ? SchedulerBinding.instance.window.platformBrightness ==
                            Brightness.light
                        ? Colors.blue
                        : const Color.fromRGBO(17, 17, 17, 1)
                    : const Color.fromRGBO(17, 17, 17, 1),
            elevation: 0,
          ),
          backgroundColor: Myapp.themeNotifier.value == ThemeMode.light
              ? Colors.blue
              : Myapp.themeNotifier.value == ThemeMode.system
                  ? SchedulerBinding.instance.window.platformBrightness ==
                          Brightness.light
                      ? Colors.blue
                      : const Color.fromRGBO(17, 17, 17, 1)
                  : const Color.fromRGBO(17, 17, 17, 1),
          body: BlocProvider(
            create: (BuildContext context) => BasicBloc(),
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40, left: 50),
                      child: Text(
                        locatizations.dictionary(Strings.bienvenidaString),
                        style: const TextStyle(
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
                        "¡te extrañamos! Inicie sesión para comenzar",
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
                  margin: const EdgeInsets.only(top: 200),
                  decoration: BoxDecoration(
                    color: Myapp.themeNotifier.value == ThemeMode.light
                        ? Colors.white
                        : Myapp.themeNotifier.value == ThemeMode.system
                            ? SchedulerBinding
                                        .instance.window.platformBrightness ==
                                    Brightness.light
                                ? Colors.white
                                : const Color.fromRGBO(29, 29, 29, 1)
                            : const Color.fromRGBO(29, 29, 29, 1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              top: 50,
                              left: 30,
                            ),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Lenguaje",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "SegoeUI",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 20,
                            ),
                            child: Dropdownbutton1(
                              initialValue: "es",
                              getValue: () async {
                                return await AppPreferences.shared
                                    .getStringPreference("defaultLanguage");
                              },
                              items: const ["es", "en"],
                              onChanged: (value) async {
                                LanguageProvider languageProvider =
                                    Provider.of<LanguageProvider>(context,
                                        listen: false);
                                languageProvider.setLanguage =
                                    Locale(value, "");
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 50,
                              left: 30,
                            ),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Tema",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "SegoeUI",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 20,
                            ),
                            child: Dropdownbutton1(
                              initialValue: "sistema",
                              getValue: () async {
                                dynamic value = await getMode('mode');
                                if (value == null) {
                                  return "sistema";
                                } else {
                                  return value.snapshot.value;
                                }
                              },
                              items: const [
                                "sistema",
                                "tema oscuro",
                                "tema claro"
                              ],
                              onChanged: (value) async {
                                if (value == "sistema" || value == "system") {
                                  setState(() {
                                    Myapp.themeNotifier.value =
                                        ThemeMode.system;
                                  });
                                } else if (value == "tema oscuro" ||
                                    value == "dark") {
                                  Myapp.themeNotifier.value = ThemeMode.dark;
                                } else if (value == "tema claro" ||
                                    value == "light") {
                                  Myapp.themeNotifier.value = ThemeMode.light;
                                }
                                print(SchedulerBinding
                                    .instance.window.platformBrightness);
                                setMode(value, 'mode');
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
