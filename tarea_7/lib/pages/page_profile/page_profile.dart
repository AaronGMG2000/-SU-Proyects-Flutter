import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarea_2/bloc/home_bloc/home_bloc.dart';
import 'package:tarea_2/main.dart';
import 'package:tarea_2/models/login.dart';
import 'package:tarea_2/pages/page_cliente/page_cliente.dart';
import 'package:tarea_2/pages/page_editable_table/page_editable_table.dart';
import 'package:tarea_2/pages/page_seguro/page_seguro.dart';
import 'package:tarea_2/pages/page_siniestro/page_siniestro.dart';
import 'package:tarea_2/provider/get_user.dart';
import 'package:tarea_2/util/realTimeDatabase.dart';
import 'package:tarea_2/widgets/button_model2.dart';

class PageProfile extends StatelessWidget {
  final String email;
  const PageProfile({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: Myapp.themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return Scaffold(
          backgroundColor: Myapp.themeNotifier.value == ThemeMode.light
              ? Colors.blue
              : const Color.fromRGBO(17, 17, 17, 1),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Myapp.themeNotifier.value =
                    Myapp.themeNotifier.value == ThemeMode.light
                        ? ThemeMode.dark
                        : ThemeMode.light;
                setMode(Myapp.themeNotifier.value == ThemeMode.dark, 'mode');
              },
              child: Icon(
                Myapp.themeNotifier.value == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode,
              )),
          body: FutureBuilder(
            future: GetUser.shared.getUser(),
            builder: (BuildContext context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    if (snapshot.hasData) {
                      Login login = Login.fromProfile(
                        snapshot.requireData as Map<String, dynamic>,
                      );
                      return BlocProvider(
                        create: (BuildContext context) => HomeBloc(),
                        child: BlocListener<HomeBloc, HomeState>(
                          listener: (context, state) {
                            switch (state.runtimeType) {
                              case AppStarted:
                                break;
                              case ClienteState:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PageCliente(),
                                  ),
                                );
                                break;
                              case SeguroState:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PageSeguro(),
                                  ),
                                );
                                break;
                              case SiniestroState:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PageSiniestro(),
                                  ),
                                );
                                break;
                            }
                          },
                          child: BlocBuilder<HomeBloc, HomeState>(
                            builder: (context, state) {
                              return Stack(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 40),
                                        alignment: Alignment.center,
                                        height: 125,
                                        width: 125,
                                        child: Stack(
                                          children: [
                                            const CircleAvatar(
                                              radius: 65,
                                              backgroundImage: AssetImage(
                                                'assets/images/profile.jpg',
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                height: 35,
                                                width: 35,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Myapp.themeNotifier
                                                              .value ==
                                                          ThemeMode.light
                                                      ? Colors.yellowAccent
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                ),
                                                child: const Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 20),
                                        alignment: Alignment.center,
                                        child: Text(
                                          login.name,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5),
                                        alignment: Alignment.center,
                                        child: Text(
                                          login.email,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(79, 79, 79, 1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 250),
                                    decoration: BoxDecoration(
                                      color: Myapp.themeNotifier.value ==
                                              ThemeMode.light
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
                                        Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 20,
                                              ),
                                              child: ButtonModel2(
                                                text: "Clientes",
                                                iconButton: Icons.people,
                                                onPressed: () {
                                                  BlocProvider.of<HomeBloc>(
                                                          context)
                                                      .add(SelectPage(
                                                          page: "cliente"));
                                                },
                                                width: 350,
                                                height: 75,
                                                lightColor:
                                                    const Color.fromARGB(
                                                        255, 223, 224, 228),
                                                darkColor: const Color.fromRGBO(
                                                    56, 56, 56, 1),
                                                lightText: Colors.black87,
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 20,
                                              ),
                                              child: ButtonModel2(
                                                text: "Seguros",
                                                iconButton: Icons.security,
                                                onPressed: () {
                                                  BlocProvider.of<HomeBloc>(
                                                          context)
                                                      .add(SelectPage(
                                                          page: "seguro"));
                                                },
                                                width: 350,
                                                height: 75,
                                                lightColor:
                                                    const Color.fromARGB(
                                                        255, 223, 224, 228),
                                                darkColor: const Color.fromRGBO(
                                                    56, 56, 56, 1),
                                                lightText: Colors.black87,
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 20,
                                              ),
                                              child: ButtonModel2(
                                                text: "Siniestros",
                                                iconButton: Icons
                                                    .assignment_late_outlined,
                                                onPressed: () {
                                                  BlocProvider.of<HomeBloc>(
                                                          context)
                                                      .add(SelectPage(
                                                          page: "siniestro"));
                                                },
                                                width: 350,
                                                height: 75,
                                                lightColor:
                                                    const Color.fromARGB(
                                                        255, 223, 224, 228),
                                                darkColor: const Color.fromRGBO(
                                                    56, 56, 56, 1),
                                                lightText: Colors.black87,
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 20,
                                              ),
                                              child: ButtonModel2(
                                                text: "Tabla modificable",
                                                iconButton: Icons
                                                    .assignment_late_outlined,
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const PageEditableTable(),
                                                    ),
                                                  );
                                                },
                                                width: 350,
                                                height: 75,
                                                lightColor:
                                                    const Color.fromARGB(
                                                        255, 223, 224, 228),
                                                darkColor: const Color.fromRGBO(
                                                    56, 56, 56, 1),
                                                lightText: Colors.black87,
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 20,
                                              ),
                                              child: ButtonModel2(
                                                text: "Cerrar Sesión",
                                                iconButton: Icons.logout,
                                                isIcon: false,
                                                onPressed: () async {
                                                  final SharedPreferences
                                                      sharedPreferences =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  sharedPreferences.setBool(
                                                      'rememberMe', false);
                                                  sharedPreferences.setString(
                                                      'email', '');
                                                  sharedPreferences.setString(
                                                      'password', '');
                                                  sharedPreferences.setString(
                                                      'name', '');
                                                  Myapp.isLogin.value = false;
                                                },
                                                width: 350,
                                                height: 75,
                                                lightColor:
                                                    const Color.fromARGB(
                                                        255, 223, 224, 228),
                                                darkColor: const Color.fromRGBO(
                                                    56, 56, 56, 1),
                                                lightText: Colors.black87,
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                top: 20,
                                              ),
                                              child: ButtonModel2(
                                                text: "Forzar Cierre de Sesión",
                                                iconButton: Icons.logout,
                                                isIcon: false,
                                                onPressed: () {
                                                  BlocProvider.of<HomeBloc>(
                                                          context)
                                                      .add(CloseSession());
                                                },
                                                width: 350,
                                                height: 75,
                                                lightColor:
                                                    const Color.fromARGB(
                                                        255, 223, 224, 228),
                                                darkColor: const Color.fromRGBO(
                                                    56, 56, 56, 1),
                                                lightText: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      return const Text('No data');
                    }
                  }
              }
            },
          ),
        );
      },
    );
  }
}
