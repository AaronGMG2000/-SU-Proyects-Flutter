import 'package:flutter/material.dart';
import 'package:tarea_2/models/Seguro.dart';
import 'package:tarea_2/pages/page_register_seguro/page_register_seguro.dart';
import 'package:tarea_2/provider/api_manager.dart';
import 'package:tarea_2/repository/seguro_repository.dart';
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

  late Seguro seguro = Seguro();
  late bool init = true;
  Future<int> create(Seguro seguro) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      dynamic data = await SeguroRepository.shared.save(
        data: [seguro],
        table: 'seguro',
      );
      if (data != null) {
        setState(() {
          seguro.numeroPoliza = data.first;
          seguros.insert(0, seguro);
          seguro = Seguro();
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
      dynamic data = await SeguroRepository.shared.update(
        data: seguro,
        table: 'seguro',
        where: 'numeroPoliza = ?',
        whereArgs: [seguro.numeroPoliza.toString()],
      );
      if (data != null) {
        setState(() {
          seguro = seguro;
        });
        return 2;
      }
      return 1;
    }
    return 0;
  }

  Future<void> delete(dynamic numeroPoliza, int index) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Cliente'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                    '¿Esta seguro de eliminar el seguro seleccionado con Numero de Poliza: ${numeroPoliza.toString()}?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () async {
                dynamic data = await SeguroRepository.shared.delete(
                  table: 'seguro',
                  where: 'numeroPoliza = ?',
                  whereArgs: [numeroPoliza.toString()],
                );
                Navigator.of(context).pop();
                if (data != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("seguro eliminado correctamente")),
                  );
                  setState(() {
                    seguros.removeAt(index);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("error al eliminar el seguro")),
                  );
                }
              },
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                titulo: 'Registrar Seguro',
                seguro: seguro,
              );
            }));
          },
          child: const Icon(
            Icons.add,
          )),
      body: FutureBuilder(
        future: SeguroRepository.shared.getAll(table: 'seguro'),
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
                seguros = data.map((e) => Seguro.fromService(e)).toList();
                return ListView.builder(
                  itemCount: seguros.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onLongPress: () {
                        delete(seguros[index].numeroPoliza, index);
                      },
                      title: Text(
                          'Inicio: ${seguros[index].fechaInicio.toIso8601String().split("T")[0]} - Vencimiento: ${seguros[index].fechaVencimiento.toIso8601String().split("T")[0]}'),
                      subtitle: Text(
                          "Poliza: ${seguros[index].numeroPoliza.toString()}"),
                      leading: const Icon(
                        Icons.security,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PageRegisterSeguro(
                              formKey: _formKey,
                              titulo: "Editar Seguro",
                              onSubmit: update,
                              seguro: seguros[index],
                            ),
                          ),
                        );
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
  }
}
