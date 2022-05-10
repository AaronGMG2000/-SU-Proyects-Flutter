import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea_2/bloc/cliente_bloc/cliente_bloc.dart';
import 'package:tarea_2/localizations/localizations.dart';
import 'package:tarea_2/main.dart';
import 'package:tarea_2/models/cliente.dart';
import 'package:tarea_2/pages/page_register_client/page_register_client.dart';
import 'package:tarea_2/repository/cliente_repository.dart';
import 'package:tarea_2/util/app_string.dart';
import 'package:tarea_2/widgets/navigation_drawer_widget.dart';

class PageCliente extends StatefulWidget {
  const PageCliente({Key? key}) : super(key: key);

  @override
  _PageClienteState createState() => _PageClienteState();
}

class _PageClienteState extends State<PageCliente> {
  final _formKey = GlobalKey<FormState>();
  late List<Cliente> clientes = [];
  late Cliente cliente = Cliente();
  late bool init = true;

  @override
  Widget build(BuildContext context) {
    final locatizations = AppLocalizations(Localizations.localeOf(context));

    return BlocProvider(
      create: (BuildContext context) => ClienteBloc(),
      child: BlocListener<ClienteBloc, ClienteState>(
        listener: (context, state) {
          switch (state.runtimeType) {
            case AppStarted:
              break;
            case DeleteSuccess:
              final estado = state as DeleteSuccess;
              Navigator.of(context).pop();
              setState(() {
                clientes.removeAt(estado.index);
              });
              break;
            case ClientFailure:
              final estado = state as ClientFailure;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(estado.message)),
              );
              break;
          }
        },
        child: BlocBuilder<ClienteBloc, ClienteState>(
          builder: (context, state) {
            Future<void> create(dynamic client) async {
              setState(() {
                cliente.dniCl = client.dniCl;
                clientes.insert(0, cliente);
                cliente = Cliente();
              });
            }

            Future<void> update(dynamic cliente) async {
              setState(() {
                cliente = Cliente();
              });
            }

            Future<void> delete(dynamic dni, int index) async {
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
                              '${locatizations.dictionary(Strings.mensajeEliminarCliente)} ${dni.toString()}?'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Confirmar'),
                        onPressed: () async {
                          BlocProvider.of<ClienteBloc>(context).add(
                            DeleteClient(dni: dni, index: index),
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
                    title: Text(Myapp.connected.value
                        ? "Clientes"
                        : "Clientes (Sin Conexion)"),
                    backgroundColor: Colors.red,
                  ),
                  floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        if (Myapp.connected.value) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PageRegisterClient(
                              formKey: _formKey,
                              titulo: locatizations
                                  .dictionary(Strings.registroClienteString),
                              onSubmit: create,
                              cliente: cliente,
                            );
                          }));
                        } else {
                          Flushbar(
                            message:
                                locatizations.dictionary(Strings.offlineString),
                            backgroundColor: Colors.red,
                            duration: const Duration(milliseconds: 1500),
                          ).show(context);
                        }
                      },
                      child: const Icon(
                        Icons.add,
                      )),
                  body: FutureBuilder(
                    future: ClienteRepository.shared.getAllSave(),
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
                            clientes = data
                                .map((e) => Cliente.fromService(e))
                                .toList();
                            return ListView.builder(
                              itemCount: clientes.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onLongPress: () {
                                    if (Myapp.connected.value) {
                                      delete(clientes[index].dniCl, index);
                                    } else {
                                      Flushbar(
                                        message: locatizations
                                            .dictionary(Strings.offlineString),
                                        backgroundColor: Colors.red,
                                        duration:
                                            const Duration(milliseconds: 1500),
                                      ).show(context);
                                    }
                                  },
                                  title: Text(
                                      '${clientes[index].nombreCl} ${clientes[index].apellido1} ${clientes[index].apellido2}'),
                                  subtitle: Text(
                                      "DNI: ${clientes[index].dniCl.toString()} Tel: ${clientes[index].telefono}"),
                                  leading: const Icon(
                                    Icons.person,
                                  ),
                                  onTap: () {
                                    if (Myapp.connected.value) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PageRegisterClient(
                                            formKey: _formKey,
                                            onSubmit: update,
                                            update: true,
                                            titulo: locatizations.dictionary(
                                                Strings.clientesString),
                                            cliente: clientes[index],
                                          ),
                                        ),
                                      );
                                    } else {
                                      Flushbar(
                                        message: locatizations
                                            .dictionary(Strings.offlineString),
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
