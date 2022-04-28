import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea_2/bloc/siniestro_bloc/siniestro_bloc.dart';
import 'package:tarea_2/main.dart';
import 'package:tarea_2/models/siniestro.dart';
import 'package:tarea_2/pages/page_register_siniestro/page_register_siniestro.dart';
import 'package:tarea_2/repository/siniestro_repository.dart';
import 'package:tarea_2/widgets/navigation_drawer_widget.dart';

class PageSiniestro extends StatefulWidget {
  const PageSiniestro({Key? key}) : super(key: key);

  @override
  _PageSiniestroState createState() => _PageSiniestroState();
}

class _PageSiniestroState extends State<PageSiniestro> {
  final _formKey = GlobalKey<FormState>();
  late List<Siniestro> siniestros = [];
  late Siniestro siniestro = Siniestro();
  late bool init = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SiniestroBloc(),
      child: BlocListener<SiniestroBloc, SiniestroState>(
        listener: (context, state) {
          switch (state.runtimeType) {
            case AppStarted:
              break;
            case DeleteSuccess:
              final estado = state as DeleteSuccess;
              Navigator.of(context).pop();
              setState(() {
                siniestros.removeAt(estado.index);
              });
              break;
            case EventFailure:
              final estado = state as EventFailure;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(estado.message)),
              );
              break;
          }
        },
        child: BlocBuilder<SiniestroBloc, SiniestroState>(
          builder: (context, state) {
            Future<void> create(dynamic sineistro2) async {
              setState(() {
                siniestros.insert(0, sineistro2);
                siniestro = Siniestro();
              });
            }

            Future<void> update(dynamic sineistro2) async {
              setState(() {
                siniestro = Siniestro();
              });
            }

            Future<void> delete(dynamic idSiniestro, int index) async {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context2) {
                  return AlertDialog(
                    title: const Text('Eliminar Cliente'),
                    content: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Text(
                              '¿Esta seguro de eliminar el dato seleccionado con Numero de Poliza: ${idSiniestro.toString()}?'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Confirmar'),
                        onPressed: () async {
                          BlocProvider.of<SiniestroBloc>(context).add(
                            DeleteEvent(idSiniestro: idSiniestro, index: index),
                          );
                        },
                      ),
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context2).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }

            return ValueListenableBuilder<bool>(
              valueListenable: Myapp.connected,
              builder: (_, bool conect, __) {
                return Scaffold(
                  drawer: const NavigationDrawerWidget(),
                  appBar: AppBar(
                    title: const Text("Siniestros"),
                    backgroundColor: Colors.red,
                  ),
                  floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        if (Myapp.connected.value) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PageRegisterSiniestro(
                              formKey: _formKey,
                              onSubmit: create,
                              siniestro: siniestro,
                              titulo: 'Registrar Siniestro',
                            );
                          }));
                        } else {
                          Flushbar(
                            message: 'No hay conexion a internet',
                            backgroundColor: Colors.red,
                            duration: const Duration(milliseconds: 1500),
                          ).show(context);
                        }
                      },
                      child: const Icon(
                        Icons.add,
                      )),
                  body: FutureBuilder(
                    future: SiniestroRepository.shared.getAllSave(),
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
                            List<dynamic> data =
                                snapshot.requireData as List<dynamic>;
                            siniestros = data
                                .map((e) => Siniestro.fromLocal(e))
                                .toList();
                            return ListView.builder(
                              itemCount: siniestros.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onLongPress: () {
                                    if (Myapp.connected.value) {
                                      delete(
                                          siniestros[index].idSiniestro, index);
                                    } else {
                                      Flushbar(
                                        message: 'No hay conexion a internet',
                                        backgroundColor: Colors.red,
                                        duration:
                                            const Duration(milliseconds: 1500),
                                      ).show(context);
                                    }
                                  },
                                  title: Text(
                                      '${siniestros[index].fechaSiniestro.toIso8601String().split("T")[0]} - ${siniestros[index].causas}'),
                                  subtitle: Text(
                                      "ID: ${siniestros[index].idSiniestro.toString()} Estado: ${siniestros[index].aceptado}"),
                                  leading: const Icon(
                                    Icons.assignment_late_outlined,
                                  ),
                                  onTap: () {
                                    if (Myapp.connected.value) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PageRegisterSiniestro(
                                            formKey: _formKey,
                                            onSubmit: update,
                                            update: true,
                                            siniestro: siniestros[index],
                                            titulo: 'Editar Siniestro',
                                          ),
                                        ),
                                      );
                                    } else {
                                      Flushbar(
                                        message: 'No hay conexion a internet',
                                        backgroundColor: Colors.red,
                                        duration:
                                            const Duration(milliseconds: 1500),
                                      ).show(context);
                                    }
                                  },
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                );
                              },
                            );
                          }
                          return const Text('No data');
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
