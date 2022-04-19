import 'package:flutter/material.dart';
import 'package:tarea_2/models/Seguro.dart';
import 'package:tarea_2/pages/page_register_seguro/page_register_seguro.dart';
import 'package:tarea_2/provider/api_manager.dart';
import 'package:tarea_2/util/app_type.dart';
import 'package:tarea_2/widgets/datatable_model.dart';
import 'package:tarea_2/widgets/navigation_drawer_widget.dart';

class PageSeguro extends StatefulWidget {
  const PageSeguro({Key? key}) : super(key: key);

  @override
  _PageSeguroState createState() => _PageSeguroState();
}

class _PageSeguroState extends State<PageSeguro> {
  late List<Seguro> seguros = [];
  final _formKey = GlobalKey<FormState>();
  late Seguro seguro = Seguro(
    condicionesParticulares: "",
    dniCl: 0,
    fechaInicio: DateTime.now(),
    fechaVencimiento: DateTime.now(),
    numeroPoliza: 0,
    observaciones: "",
    ramo: "",
  );
  late bool init = true;
  Future<int> create(dynamic seguro2) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      dynamic data = await ApiManager.shared.request(
          baseUrl: "192.168.1.13:8585",
          pathUrl: "/seguro/guardar",
          type: HttpType.post,
          bodyParams: {
            "condicionesParticulares": seguro2.condicionesParticulares,
            "dniCl": seguro2.dniCl,
            "fechaInicio": seguro2.fechaInicio.toIso8601String(),
            "fechaVencimiento": seguro2.fechaVencimiento.toIso8601String(),
            "numeroPoliza": seguro2.numeroPoliza,
            "observaciones": seguro2.observaciones,
            "ramo": seguro2.ramo,
          });
      if (data != null) {
        Seguro seguroN = Seguro.fromService(data);
        setState(() {
          seguro.clear();
          seguros.insert(0, seguroN);
        });
        return 2;
      }
      return 1;
    }
    return 0;
  }

  Future<int> update(dynamic seguro) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      dynamic data = await ApiManager.shared.request(
        baseUrl: "192.168.1.13:8585",
        pathUrl: "/seguro/actualizar",
        type: HttpType.put,
        bodyParams: {
          "condicionesParticulares": seguro.condicionesParticulares,
          "dniCl": seguro.dniCl,
          "fechaInicio": seguro.fechaInicio.toIso8601String(),
          "fechaVencimiento": seguro.fechaVencimiento.toIso8601String(),
          "numeroPoliza": seguro.numeroPoliza,
          "observaciones": seguro.observaciones,
          "ramo": seguro.ramo,
        },
      );
      if (data != null) {
        return 2;
      }
      return 1;
    }
    return 0;
  }

  Future<int> delete(dynamic numeroPoliza) async {
    int response = 2;
    dynamic data = await ApiManager.shared.request(
      baseUrl: "192.168.1.13:8585",
      pathUrl: "/seguro/eliminar/" + numeroPoliza.toString(),
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
        title: const Text("Seguros"),
        backgroundColor: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PageRegisterSeguro(
                formKey: _formKey,
                onSubmit: create,
                seguro: seguro,
              );
            }));
          },
          child: const Icon(
            Icons.add,
          )),
      body: FutureBuilder(
        future: ApiManager.shared.request(
          baseUrl: "192.168.1.13:8585",
          pathUrl: "/seguro/buscar",
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
                    seguros.add(Seguro.fromService(element));
                  }
                }
                init = false;
                List<dynamic> columns = [
                  "Poliza",
                  "DNI Cliente",
                  "Ramo",
                  "Observaciones",
                  "Condiciones Particulares",
                  "Fecha Inicio",
                  "Fecha Vencimiento",
                ];
                List<dynamic> fields = [
                  "numeroPoliza",
                  "dniCl",
                  "ramo",
                  "observaciones",
                  "condicionesParticulares",
                  "fechaInicio",
                  "fechaVencimiento",
                ];
                return DatatableModel(
                  page: "seguro",
                  columns: columns,
                  fields: fields,
                  data: seguros,
                  columnSize: 140,
                  formKey: _formKey,
                  onDelete: delete,
                  onUpdate: update,
                );
              }
              ;
              return const Text('No data');
          }
        },
      ),
    );
  }
}
