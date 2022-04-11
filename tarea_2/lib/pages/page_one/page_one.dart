import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:tarea_2/bloc/basic_bloc/basic_bloc.dart';
import 'package:tarea_2/models/login.dart';
import 'package:tarea_2/pages/page_three/page_three.dart';
import 'package:tarea_2/pages/page_two/page_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea_2/widgets/form_validation.dart';

class PageOne extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeNotifier;
  const PageOne({Key? key, required this.themeNotifier}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final login = Login(email: "", password: "");
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('App de ejemplo'),
          actions: [
            IconButton(
                icon: Icon(themeNotifier.value == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode),
                onPressed: () {
                  themeNotifier.value = themeNotifier.value == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
                })
          ],
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PageThree(
                        username: estado.username,
                        name: estado.name,
                        email: estado.email,
                      ),
                    ),
                  );
                  break;
                case EmailFail:
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("El Email indicado no esta registrado")),
                  );
                  break;
                case PasswordFail:
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password Incorrecto")),
                  );
                  break;
              }
            },
            child: BlocBuilder<BasicBloc, BasicState>(
              builder: (context, state) {
                if (state is AppStarted) {
                  print("aplicación inciada");
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Login"),
                    FormValidation(
                      login: login,
                      formKey: _formKey,
                      onSubmit: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();
                          BlocProvider.of<BasicBloc>(context).add(
                            LoginStart(
                              email: login.email,
                              password: login.password,
                            ),
                          );
                        }
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      width: double.infinity,
                      child: ElevatedButton(
                        child: const Text("Generar Error"),
                        onPressed: () {
                          if (FirebaseCrashlytics
                              .instance.isCrashlyticsCollectionEnabled) {
                            FirebaseCrashlytics.instance.log("Email: " +
                                FirebaseRemoteConfig.instance
                                    .getString('Email'));
                            FirebaseCrashlytics.instance.crash();
                          } else {
                            print("No se pudo enviar el error");
                          }
                        },
                      ),
                      alignment: Alignment.center,
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }
}
