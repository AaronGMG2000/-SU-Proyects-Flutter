import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tarea_2/main.dart';
import 'package:tarea_2/models/login.dart';
import 'package:tarea_2/pages/page_cliente/page_cliente.dart';
import 'package:tarea_2/pages/page_seguro/page_seguro.dart';
import 'package:tarea_2/pages/page_siniestro/page_siniestro.dart';
import 'package:tarea_2/provider/get_user.dart';
import 'package:tarea_2/util/realTimeDatabase.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  _NavigationDrawerWidgetState createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 20);
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: Myapp.themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return FutureBuilder(
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
                    return Drawer(
                      child: Material(
                        color: Myapp.themeNotifier.value == ThemeMode.light
                            ? Colors.blue
                            : const Color.fromRGBO(26, 40, 51, 1),
                        child: ListView(
                          padding: padding,
                          children: [
                            buildHeader(
                              urlImage: 'assets/images/profile.jpg',
                              name: login.name,
                              email: login.email,
                            ),
                            const SizedBox(height: 48),
                            buildMenuItem(
                              text: "Perfil",
                              icon: Icons.person,
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                            const SizedBox(height: 16),
                            buildMenuItem(
                              text: "Clientes",
                              icon: Icons.people,
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PageCliente(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            buildMenuItem(
                              text: "Seguros",
                              icon: Icons.security,
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PageSeguro(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            buildMenuItem(
                              text: "Siniestros",
                              icon: Icons.assignment_late_outlined,
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PageSiniestro(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            const Divider(
                              color: Colors.white70,
                            ),
                            const SizedBox(height: 24),
                            buildMenuItem(
                              text: Myapp.themeNotifier.value == ThemeMode.light
                                  ? "Set Dark Mode"
                                  : "Set Light Mode",
                              icon: Myapp.themeNotifier.value == ThemeMode.light
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                              onTap: () {
                                Myapp.themeNotifier.value =
                                    Myapp.themeNotifier.value == ThemeMode.light
                                        ? ThemeMode.dark
                                        : ThemeMode.light;
                                setMode(
                                    Myapp.themeNotifier.value == ThemeMode.dark,
                                    'mode');
                              },
                            ),
                            const SizedBox(height: 16),
                            buildMenuItem(
                              text: "Cerrar Sesión",
                              icon: Icons.logout,
                              onTap: () {
                                setMode(false, 'rememberMe');
                                setMode("", 'email');
                                setMode("", 'name');
                                Navigator.pop(context);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Text('No data');
                  }
                }
            }
          },
        );
      },
    );
  }
}

Widget buildHeader({
  required String urlImage,
  required String name,
  required String email,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 50),
    child: Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(urlImage),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 175,
              child: AutoSizeText(
                name,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 3,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 175,
              child: AutoSizeText(
                email,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
                maxLines: 3,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildMenuItem({
  required String text,
  required IconData icon,
  required Function()? onTap,
}) {
  const color = Colors.white;
  const hoverColor = Colors.white70;
  return ListTile(
    leading: Icon(
      icon,
      color: color,
    ),
    title: Text(
      text,
      style: const TextStyle(
        color: color,
      ),
    ),
    hoverColor: hoverColor,
    onTap: onTap,
  );
}
