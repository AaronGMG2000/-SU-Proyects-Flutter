import 'package:flutter/material.dart';
import 'package:tarea_2/models/cliente.dart';
import 'package:tarea_2/pages/page_register_client/page_register_client.dart';
import 'package:tarea_2/provider/api_manager.dart';
import 'package:tarea_2/util/app_type.dart';
import 'package:tarea_2/widgets/datatable_model.dart';
import 'package:tarea_2/widgets/navigation_drawer_widget.dart';

class PageCliente extends StatefulWidget {
  const PageCliente({Key? key}) : super(key: key);

  @override
  _PageClienteState createState() => _PageClienteState();
}

class _PageClienteState extends State<PageCliente> {
  final _formKey = GlobalKey<FormState>();
  late List<Cliente> clientes = [];
  late Cliente cliente = Cliente(
    dniCl: 0,
    nombreCl: '',
    apellido1: '',
    apellido2: '',
    telefono: '',
    ciudad: '',
    claseVia: '',
    numeroVia: '',
    codPostal: '',
    nombreVia: '',
    observaciones: '',
    segurosList: [],
  );
  late bool init = true;
  Future<int> create(dynamic cliente2) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      dynamic data = await ApiManager.shared.request(
          baseUrl: "192.168.1.5:8585",
          pathUrl: "/cliente/guardar",
          type: HttpType.post,
          bodyParams: {
            'nombreCl': cliente2.nombreCl,
            'apellido1': cliente2.apellido1,
            'apellido2': cliente2.apellido2,
            'telefono': cliente2.telefono,
            'ciudad': cliente2.ciudad,
            'claseVia': cliente2.claseVia,
            'numeroVia': cliente2.numeroVia,
            'codPostal': cliente2.codPostal,
            'nombreVia': cliente2.nombreVia,
            'observaciones': cliente2.observaciones,
          });
      if (data != null) {
        Cliente clientN = Cliente.fromService(data);
        setState(() {
          cliente.clear();
          clientes.insert(0, clientN);
        });
        return 2;
      }
      return 1;
    }
    return 0;
  }

  Future<int> update(dynamic cliente) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      dynamic data = await ApiManager.shared.request(
          baseUrl: "192.168.1.5:8585",
          pathUrl: "/cliente/actualizar",
          type: HttpType.put,
          bodyParams: {
            'dniCl': cliente.dniCl,
            'nombreCl': cliente.nombreCl,
            'apellido1': cliente.apellido1,
            'apellido2': cliente.apellido2,
            'telefono': cliente.telefono,
            'ciudad': cliente.ciudad,
            'claseVia': cliente.claseVia,
            'numeroVia': cliente.numeroVia,
            'codPostal': cliente.codPostal,
            'nombreVia': cliente.nombreVia,
            'observaciones': cliente.observaciones,
          });
      if (data != null) {
        return 2;
      }
      return 1;
    }
    return 0;
  }

  Future<int> delete(dynamic dni) async {
    int response = 2;
    dynamic data = await ApiManager.shared.request(
      baseUrl: "192.168.1.5:8585",
      pathUrl: "/cliente/eliminar/" + dni.toString(),
      type: HttpType.delete,
    );
    if (data != null) {
      response = 1;
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    late Future<int> Function(dynamic cliente) function = create;
    late Future<int> Function(dynamic cliente) functionU = update;
    late Future<int> Function(dynamic cliente) functionD = delete;
    return Scaffold(
      drawer: const NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text("Clientes"),
        backgroundColor: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PageRegisterClient(
                formKey: _formKey,
                onSubmit: function,
                cliente: cliente,
              );
            }));
          },
          child: const Icon(
            Icons.add,
          )),
      body: FutureBuilder(
        future: ApiManager.shared.request(
          baseUrl: "192.168.1.5:8585",
          pathUrl: "/cliente/buscar",
          type: HttpType.get,
        ),
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
                if (init) {
                  List<dynamic> data = snapshot.requireData as List<dynamic>;
                  for (var element in data) {
                    clientes.add(Cliente.fromService(element));
                  }
                }
                init = false;
                List<dynamic> columns = [
                  "DNI",
                  "Nombre",
                  "Primer Apellido",
                  "Segundo Apellido",
                  "Clase de Via",
                  "Nombre de Via",
                  "Numero de Via",
                  "Codigo Postal",
                  "Ciudad",
                  "Telefono",
                  "Observaciones",
                ];
                List<dynamic> fields = [
                  "dniCl",
                  "nombreCl",
                  "apellido1",
                  "apellido2",
                  "claseVia",
                  "nombreVia",
                  "numeroVia",
                  "codPostal",
                  "ciudad",
                  "telefono",
                  "observaciones",
                ];
                return DatatableModel(
                  page: "cliente",
                  formKey: _formKey,
                  columns: columns,
                  fields: fields,
                  data: clientes,
                  onUpdate: functionU,
                  onDelete: functionD,
                  columnSize: 140,
                );
              }
              return const Text('No data');
          }
        },
      ),
    );
  }
}
