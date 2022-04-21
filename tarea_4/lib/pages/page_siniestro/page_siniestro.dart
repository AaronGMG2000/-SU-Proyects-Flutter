import 'package:flutter/material.dart';
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

  Future<int> create(Siniestro siniestro) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      dynamic data = await SiniestroRepository.shared
          .save(data: [siniestro], table: 'siniestro');
      if (data != null) {
        setState(() {
          siniestro.idSiniestro = data.first;
          siniestros.insert(0, siniestro);
          siniestro = Siniestro();
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
      dynamic data = await SiniestroRepository.shared.update(
        data: siniestro,
        table: 'siniestro',
        where: 'idSiniestro = ?',
        whereArgs: [siniestro.idSiniestro.toString()],
      );
      if (data != null) {
        setState(() {
          siniestro = siniestro;
        });
        return 2;
      }
      return 1;
    }
    return 0;
  }

  Future<void> delete(dynamic idSiniestro, int index) async {
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
                    '¿Esta seguro de eliminar al siniestro seleccionado con id ${idSiniestro.toString()}?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () async {
                dynamic data = await SiniestroRepository.shared.delete(
                  table: 'siniestro',
                  where: 'idSiniestro = ?',
                  whereArgs: [idSiniestro.toString()],
                );
                Navigator.of(context).pop();
                if (data != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("siniestro eliminado correctamente")),
                  );
                  setState(() {
                    siniestros.removeAt(index);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("error al eliminar el siniestro")),
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
                titulo: 'Registrar Siniestro',
              );
            }));
          },
          child: const Icon(
            Icons.add,
          )),
      body: FutureBuilder(
        future: SiniestroRepository.shared.getAll(table: 'siniestro'),
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
                siniestros = data.map((e) => Siniestro.fromLocal(e)).toList();
                return ListView.builder(
                  itemCount: siniestros.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onLongPress: () {
                        delete(siniestros[index].idSiniestro, index);
                      },
                      title: Text(
                          '${siniestros[index].fechaSiniestro.toIso8601String().split("T")[0]} - ${siniestros[index].causas}'),
                      subtitle: Text(
                          "ID: ${siniestros[index].idSiniestro.toString()} Estado: ${siniestros[index].aceptado}"),
                      leading: const Icon(
                        Icons.assignment_late_outlined,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PageRegisterSiniestro(
                              formKey: _formKey,
                              onSubmit: update,
                              siniestro: siniestros[index],
                              titulo: 'Editar Siniestro',
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
