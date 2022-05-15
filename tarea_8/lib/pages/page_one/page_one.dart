import 'package:flutter/scheduler.dart';
import 'package:tarea_2/bloc/basic_bloc/basic_bloc.dart';
import 'package:tarea_2/localizations/localizations.dart';
import 'package:tarea_2/main.dart';
import 'package:tarea_2/models/login.dart';
import 'package:tarea_2/pages/page_settings/page_settings.dart';
import 'package:tarea_2/pages/page_two/page_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea_2/repository/login_repository.dart';
import 'package:tarea_2/util/app_string.dart';
import 'package:tarea_2/util/realTimeDatabase.dart';
import 'package:tarea_2/widgets/form_validation.dart';

class PageOne extends StatefulWidget {
  final Login login;
  const PageOne({
    Key? key,
    required this.login,
  }) : super(key: key);

  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
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
            backgroundColor: Myapp.themeNotifier.value == ThemeMode.light
                ? Colors.blue
                : Myapp.themeNotifier.value == ThemeMode.system
                    ? SchedulerBinding.instance!.window.platformBrightness ==
                            Brightness.light
                        ? Colors.blue
                        : const Color.fromRGBO(17, 17, 17, 1)
                    : const Color.fromRGBO(17, 17, 17, 1),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PageSettings()),
                );
              },
              child: const Icon(Icons.settings),
            ),
            body: BlocProvider(
              create: (BuildContext context) => BasicBloc(),
              child: BlocListener<BasicBloc, BasicState>(
                listener: (context, state) {
                  switch (state.runtimeType) {
                    case AppStarted:
                      break;
                    case PageChanged:
                      final estado = state as PageChanged;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PageTwo(title: estado.title),
                        ),
                      );
                      break;
                    case LoginSuccess:
                      final estado = state as LoginSuccess;
                      widget.login.email = estado.email;
                      Myapp.isLogin.value = true;
                      break;
                    case EmailFail:
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(locatizations
                                .dictionary(Strings.errorEmailString))),
                      );
                      break;
                    case PasswordFail:
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(locatizations
                                .dictionary(Strings.errorPasswordString))),
                      );
                      break;
                  }
                },
                child: BlocBuilder<BasicBloc, BasicState>(
                  builder: (context, state) {
                    return FutureBuilder(
                      future: LoginRepository.shared.getAllSave(),
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
                              return Stack(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 110, left: 50),
                                        child: Text(
                                          locatizations.dictionary(
                                              Strings.bienvenidaString),
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
                                        margin: const EdgeInsets.only(
                                            top: 20, left: 50),
                                        child: Text(
                                          locatizations.dictionary(
                                              Strings.bienvenida2String),
                                          style: const TextStyle(
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
                                    margin: const EdgeInsets.only(top: 250),
                                    decoration: BoxDecoration(
                                      color: Myapp.themeNotifier.value ==
                                              ThemeMode.light
                                          ? Colors.white
                                          : Myapp.themeNotifier.value ==
                                                  ThemeMode.system
                                              ? SchedulerBinding
                                                          .instance!
                                                          .window
                                                          .platformBrightness ==
                                                      Brightness.light
                                                  ? Colors.white
                                                  : const Color.fromRGBO(
                                                      29, 29, 29, 1)
                                              : const Color.fromRGBO(
                                                  29, 29, 29, 1),
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
                                                top: 20,
                                                left: 30,
                                              ),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                locatizations.dictionary(
                                                    Strings.loginString),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: "SegoeUI",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 30,
                                              ),
                                              child: FormValidation(
                                                login: widget.login,
                                                formKey: _formKey,
                                                onSubmit: () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    _formKey.currentState
                                                        ?.save();
                                                    BlocProvider.of<BasicBloc>(
                                                            context)
                                                        .add(
                                                      LoginStart(
                                                          email: widget
                                                              .login.email,
                                                          password: widget
                                                              .login.password,
                                                          rememberMe: widget
                                                              .login
                                                              .rememberMe),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                            Container(
                                                margin: const EdgeInsets.only(
                                                  top: 100,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      locatizations.dictionary(
                                                          Strings.acountString),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: "SegoeUI",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      " " +
                                                          locatizations
                                                              .dictionary(Strings
                                                                  .registrateString),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: "SegoeUI",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }
                            return const Text('No data');
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          );
        });
  }
}
