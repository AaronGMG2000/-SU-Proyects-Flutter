import 'package:flutter/material.dart';
import 'package:tarea_2/models/siniestro.dart';
import 'package:tarea_2/pages/page_register_siniestro/page_register_siniestro.dart';
import 'package:tarea_2/provider/api_manager.dart';
import 'package:tarea_2/util/app_type.dart';
import 'package:tarea_2/widgets/datatable_model.dart';
import 'package:tarea_2/widgets/navigation_drawer_widget.dart';

class PageSiniestro extends StatefulWidget {
  const PageSiniestro({Key? key}) : super(key: key);

  @override
  _PageSiniestroState createState() => _PageSiniestroState();
}

class _PageSiniestroState extends State<PageSiniestro> {
  final _formKey = GlobalKey<FormState>();
  late List<Siniestro> siniestros = [];
  late Siniestro siniestro = Siniestro(
    aceptado: "",
    causas: "",
    fechaSiniestro: DateTime.now(),
    idSiniestro: 0,
    indermizacion: "",
  );
  late bool init = true;
  Future<int> create(dynamic siniestro) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      dynamic data = await ApiManager.shared.request(
          baseUrl: "192.168.1.5:8585",
          pathUrl: "/siniestro/guardar",
          type: HttpType.post,
          bodyParams: {
            "aceptado": siniestro.aceptado,
            "causas": siniestro.causas,
            "fechaSiniestro": siniestro.fechaSiniestro.toIso8601String(),
            "idSiniestro": siniestro.idSiniestro,
            "indermizacion": siniestro.indermizacion,
            "perito": {
              "dniPerito": siniestro.perito.dniPerito,
            },
            "seguro": {
              "numeroPoliza": siniestro.seguro.numeroPoliza,
            }
          });
      if (data != null) {
        Siniestro siniestroN = Siniestro.fromService(data);
        setState(() {
          siniestros.insert(0, siniestroN);
          siniestro.clear();
        });
        return 2;
      }
      return 1;
    }
    return 0;
  }

  Future<int> update(dynamic siniestro) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      dynamic data = await ApiManager.shared.request(
          baseUrl: "192.168.1.5:8585",
          pathUrl: "/siniestro/actualizar",
          type: HttpType.put,
          bodyParams: {
            "aceptado": siniestro.aceptado,
            "causas": siniestro.causas,
            "fechaSiniestro": siniestro.fechaSiniestro.toIso8601String(),
            "idSiniestro": siniestro.idSiniestro,
            "indermizacion": siniestro.indermizacion,
            "perito": {
              "dniPerito": siniestro.perito.dniPerito,
            },
            "seguro": {
              "numeroPoliza": siniestro.seguro.numeroPoliza,
            }
          });
      if (data != null) {
        return 2;
      }
      return 1;
    }
    return 0;
  }

  Future<int> delete(dynamic idSiniestro) async {
    int response = 2;
    dynamic data = await ApiManager.shared.request(
      baseUrl: "192.168.1.5:8585",
      pathUrl: "/siniestro/eliminar/" + idSiniestro.toString(),
      type: HttpType.delete,
    );
    if (data != null) {
      response = 1;
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text("Siniestros"),
        backgroundColor: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PageRegisterSiniestro(
                formKey: _formKey,
                onSubmit: create,
                siniestro: siniestro,
              );
            }));
          },
          child: const Icon(
            Icons.add,
          )),
      body: FutureBuilder(
        future: ApiManager.shared.request(
          baseUrl: "192.168.1.5:8585",
          pathUrl: "/siniestro/buscar",
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
                List<dynamic> data = snapshot.requireData as List<dynamic>;
                if (init) {
                  for (var element in data) {
                    siniestros.add(Siniestro.fromService(element));
                  }
                }
                init = false;
                List<dynamic> columns = [
                  "Id",
                  "Causas",
                  "Aceptado",
                  "Indermizacion",
                  "Fecha de Siniestro",
                  "DNI Perito",
                  "Poliza",
                ];
                List<dynamic> fields = [
                  "idSiniestro",
                  "causas",
                  "aceptado",
                  "indermizacion",
                  "fechaSiniestro",
                  "dniPerito",
                  "numeroPoliza",
                ];
                return DatatableModel(
                  page: "siniestro",
                  columns: columns,
                  fields: fields,
                  data: siniestros,
                  columnSize: 140,
                  formKey: _formKey,
                  onDelete: delete,
                  onUpdate: update,
                );
              }
              return const Text('No data');
          }
        },
      ),
    );
  }
}
