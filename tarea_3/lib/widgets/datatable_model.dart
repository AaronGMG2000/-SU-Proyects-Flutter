import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:tarea_2/main.dart';
import 'package:tarea_2/pages/page_register_client/page_register_client.dart';
import 'package:tarea_2/pages/page_register_seguro/page_register_seguro.dart';
import 'package:tarea_2/pages/page_register_siniestro/page_register_siniestro.dart';

class DatatableModel extends StatefulWidget {
  final List<dynamic> columns;
  final List<dynamic> fields;
  final GlobalKey<FormState> formKey;
  final List<dynamic> data;
  final double columnSize;
  final String page;
  final Future<int> Function(dynamic) onDelete;
  final Future<int> Function(dynamic) onUpdate;
  const DatatableModel({
    Key? key,
    required this.columns,
    required this.formKey,
    required this.fields,
    required this.page,
    required this.data,
    required this.onDelete,
    required this.onUpdate,
    this.columnSize = 120,
  }) : super(key: key);

  @override
  _DatatableModelState createState() => _DatatableModelState();
}

late bool darkMode = false;

class _DatatableModelState extends State<DatatableModel> {
  @override
  void initState() {
    widget.columns.add("Editar");
    widget.columns.add("Eliminar");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: Myapp.themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        darkMode = currentMode == ThemeMode.dark;
        return SizedBox(
          child: HorizontalDataTable(
            leftHandSideColumnWidth: widget.columnSize,
            rightHandSideColumnWidth:
                (widget.columnSize + 2) * (widget.columns.length - 1) + 2,
            isFixedHeader: true,
            headerWidgets: _getTitleWidget(),
            leftSideItemBuilder: _generateFirstColumnRow,
            rightSideItemBuilder: _generateRightHandSideColumnRow,
            itemCount: widget.data.length,
            rowSeparatorWidget: const Divider(
              color: Colors.black54,
              height: 1.0,
              thickness: 0.0,
            ),
            leftHandSideColBackgroundColor:
                Myapp.themeNotifier.value == ThemeMode.light
                    ? Colors.blueGrey
                    : const Color.fromRGBO(26, 40, 51, 1),
            rightHandSideColBackgroundColor:
                Myapp.themeNotifier.value == ThemeMode.light
                    ? const Color(0xFFFFFFFF)
                    : const Color.fromRGBO(39, 53, 66, 1),
          ),
          height: MediaQuery.of(context).size.height,
        );
      },
    );
  }

  List<Widget> _getTitleWidget() {
    List<Widget> widgets = [];
    for (var element in widget.columns) {
      widgets.add(
        _getTitleItemWidget(
          element,
          widget.columnSize,
          darkMode ? const Color.fromRGBO(41, 41, 41, 1) : Colors.pink,
        ),
      );
      widgets.add(
        Container(
          width: 2,
          height: 56,
          color: Colors.white,
        ),
      );
    }
    return widgets;
  }

  Widget _getTitleItemWidget(String label, double width, color) {
    return Container(
      color: color,
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      width: width,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(
        widget.data[index].toMap()[widget.fields[0]].toString(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      width: widget.columnSize,
      height: 52,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    List<Widget> widgets = [];
    for (var element in widget.fields) {
      if (element == widget.fields[0]) {
        continue;
      }
      widgets.add(
        Container(
          child: Text(
            widget.data[index].toMap()[element].toString(),
            style: TextStyle(
              fontSize: 18,
              color: darkMode ? Colors.white : Colors.black,
            ),
          ),
          width: widget.columnSize,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
        ),
      );
      widgets.add(
        Container(
          width: 2,
          height: 56,
          color: Colors.blueGrey,
        ),
      );
    }
    widgets.add(
      Container(
        child: IconButton(
          icon: Icon(
            Icons.edit,
            color: darkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            switch (widget.page) {
              case "cliente":
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return PageRegisterClient(
                        formKey: widget.formKey,
                        onSubmit: widget.onUpdate,
                        cliente: widget.data[index],
                      );
                    },
                  ),
                );
                break;
              case "seguro":
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return PageRegisterSeguro(
                        formKey: widget.formKey,
                        onSubmit: widget.onUpdate,
                        seguro: widget.data[index],
                      );
                    },
                  ),
                );
                break;
              case "siniestro":
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return PageRegisterSiniestro(
                        formKey: widget.formKey,
                        onSubmit: widget.onUpdate,
                        siniestro: widget.data[index],
                      );
                    },
                  ),
                );
                break;
            }
          },
        ),
        width: widget.columnSize,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
      ),
    );
    widgets.add(
      Container(
        width: 2,
        height: 56,
        color: Colors.blueGrey,
      ),
    );
    widgets.add(
      Container(
        child: IconButton(
          icon: Icon(
            Icons.delete,
            color: darkMode ? Colors.white : Colors.black,
          ),
          onPressed: () async {
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                String id =
                    widget.data[index].toMap()[widget.fields[0]].toString();
                return AlertDialog(
                  title: Text('Eliminar ${widget.page}'),
                  content: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Text(
                            '¿Esta seguro de eliminar el dato seleccionado con id $id?'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Confirmar'),
                      onPressed: () async {
                        int response = await widget.onDelete(
                            widget.data[index].toMap()[widget.fields[0]]);
                        if (response == 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("eliminado correctamente")),
                          );
                          setState(() {
                            widget.data.removeAt(index);
                          });
                          Navigator.of(context).pop();
                        } else if (response == 2) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Error al eliminar")),
                          );
                          Navigator.of(context).pop();
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
          },
        ),
        width: widget.columnSize,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
      ),
    );
    widgets.add(
      Container(
        width: 2,
        height: 56,
        color: Colors.blueGrey,
      ),
    );
    return Row(
      children: widgets,
    );
  }
}
