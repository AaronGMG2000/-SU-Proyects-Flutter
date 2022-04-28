import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea_2/bloc/seguro_bloc/seguro_bloc.dart';
import 'package:tarea_2/main.dart';
import 'package:tarea_2/models/Seguro.dart';
import 'package:tarea_2/pages/page_register_seguro/page_register_seguro.dart';
import 'package:tarea_2/repository/seguro_repository.dart';
import 'package:tarea_2/widgets/navigation_drawer_widget.dart';

class PageSeguro extends StatefulWidget {
  const PageSeguro({Key? key}) : super(key: key);

  @override
  _PageSeguroState createState() => _PageSeguroState();
}

class _PageSeguroState extends State<PageSeguro> {
  late List<Seguro> seguros = [];
  final _formKey = GlobalKey<FormState>();

  late Seguro seguro = Seguro();
  late bool init = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SeguroBloc(),
      child: BlocListener<SeguroBloc, SeguroState>(
        listener: (context, state) {
          switch (state.runtimeType) {
            case AppStarted:
              break;
            case DeleteSuccess:
              final estado = state as DeleteSuccess;
              Navigator.of(context).pop();
              setState(() {
                seguros.removeAt(estado.index);
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
        child: BlocBuilder<SeguroBloc, SeguroState>(
          builder: (context, state) {
            Future<void> create(dynamic seguro2) async {
              setState(() {
                seguros.insert(0, seguro2);
                seguro = Seguro();
              });
            }

            Future<void> update(dynamic seguro2) async {
              setState(() {
                seguro = Seguro();
              });
            }

            Future<void> delete(dynamic numeroPoliza, int index) async {
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
                              '¿Esta seguro de eliminar el dato seleccionado con Numero de Poliza: ${numeroPoliza.toString()}?'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Confirmar'),
                        onPressed: () async {
                          BlocProvider.of<SeguroBloc>(context).add(
                            DeleteEvent(
                                numeroPoliza: numeroPoliza, index: index),
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
                    title: const Text("Seguros"),
                    backgroundColor: Colors.red,
                  ),
                  floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        if (Myapp.connected.value) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PageRegisterSeguro(
                              formKey: _formKey,
                              onSubmit: create,
                              titulo: 'Registrar Seguro',
                              seguro: seguro,
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
                    future: SeguroRepository.shared.getAllSave(),
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
                            seguros =
                                data.map((e) => Seguro.fromService(e)).toList();
                            return ListView.builder(
                              itemCount: seguros.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onLongPress: () {
                                    if (Myapp.connected.value) {
                                      delete(
                                          seguros[index].numeroPoliza, index);
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
                                      'Inicio: ${seguros[index].fechaInicio.toIso8601String().split("T")[0]} - Vencimiento: ${seguros[index].fechaVencimiento.toIso8601String().split("T")[0]}'),
                                  subtitle: Text(
                                      "Poliza: ${seguros[index].numeroPoliza.toString()}"),
                                  leading: const Icon(
                                    Icons.security,
                                  ),
                                  onTap: () {
                                    if (Myapp.connected.value) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PageRegisterSeguro(
                                            formKey: _formKey,
                                            titulo: "Editar Seguro",
                                            onSubmit: update,
                                            update: true,
                                            seguro: seguros[index],
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
