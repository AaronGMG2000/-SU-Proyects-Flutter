import 'package:tarea_2/models/cliente.dart';
import 'package:tarea_2/util/validations.dart';
import 'package:tarea_2/widgets/button_model1.dart';
import 'package:tarea_2/widgets/text_input.dart';
import 'package:flutter/material.dart';

class FormClientValidation extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Future<int> Function(Cliente cliente) onSubmit;
  final Cliente cliente;
  const FormClientValidation({
    Key? key,
    required this.formKey,
    required this.onSubmit,
    required this.cliente,
  }) : super(key: key);

  @override
  _FormClientValidation createState() => _FormClientValidation();
}

class _FormClientValidation extends State<FormClientValidation> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextInput(
            hinText: "Nombre",
            initialValue: widget.cliente.nombreCl,
            iconData: Icons.abc,
            controller: TextEditingController(),
            inputType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, introduzca su Nombre';
              }
              return null;
            },
            onSaved: (value) {
              if (value != null && value.isNotEmpty) {
                widget.cliente.nombreCl = value;
              }
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: TextInput(
              initialValue: widget.cliente.apellido1,
              hinText: "Primer Apellido",
              iconData: Icons.abc,
              controller: TextEditingController(),
              inputType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduzca su Primer Apellido';
                }
                return null;
              },
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  widget.cliente.apellido1 = value;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: TextInput(
              initialValue: widget.cliente.apellido2,
              hinText: "Segundo Apellido",
              iconData: Icons.abc,
              controller: TextEditingController(),
              inputType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduzca su Segundo Apellido';
                }
                return null;
              },
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  widget.cliente.apellido2 = value;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: TextInput(
              hinText: "Clase de Via",
              initialValue: widget.cliente.claseVia,
              iconData: Icons.abc,
              controller: TextEditingController(),
              inputType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduzca una clase de via';
                }
                return null;
              },
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  widget.cliente.claseVia = value;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: TextInput(
              initialValue: widget.cliente.nombreVia,
              hinText: "Via",
              iconData: Icons.abc,
              controller: TextEditingController(),
              inputType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduzca el nombre de la Via';
                }
                return null;
              },
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  widget.cliente.nombreVia = value;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: TextInput(
              initialValue: widget.cliente.numeroVia,
              hinText: "No. Via",
              iconData: Icons.format_list_numbered,
              controller: TextEditingController(),
              inputType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduzca un número de Via';
                }
                return null;
              },
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  widget.cliente.numeroVia = value;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: TextInput(
              initialValue: widget.cliente.telefono,
              hinText: "Telefono",
              iconData: Icons.numbers,
              controller: TextEditingController(),
              inputType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduzca su numero de telefono';
                }
                if (Validator(value).isValidPhon) {
                  return 'Por favor, introduzca un número de telefono valido';
                }
                return null;
              },
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  widget.cliente.telefono = value;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: TextInput(
              initialValue: widget.cliente.codPostal,
              hinText: "Postal",
              iconData: Icons.numbers,
              controller: TextEditingController(),
              inputType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduzca su codigo postal';
                }
                if (Validator(value).isValidPostalCod) {
                  return 'Por favor, introduzca un codigo postal valido';
                }
                return null;
              },
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  widget.cliente.codPostal = value;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: TextInput(
              initialValue: widget.cliente.ciudad,
              hinText: "Ciudad",
              iconData: Icons.location_city,
              controller: TextEditingController(),
              inputType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduzca una ciudad';
                }
                return null;
              },
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  widget.cliente.ciudad = value;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: TextInput(
              initialValue: widget.cliente.observaciones,
              hinText: "Observaciones",
              iconData: Icons.description,
              controller: TextEditingController(),
              inputType: TextInputType.text,
              maxlines: 3,
              validator: (value) {
                return null;
              },
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  widget.cliente.observaciones = value;
                } else {
                  widget.cliente.observaciones = "***";
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonModel1(
                  text: "Guardar",
                  width: 175,
                  fontSize: 16,
                  lightColor: Colors.blue,
                  darkColor: const Color.fromRGBO(174, 124, 232, 1),
                  onPressed: () async {
                    int respuesta = await widget.onSubmit(widget.cliente);
                    if (respuesta == 2) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("cliente registrado con exito")),
                      );
                      Navigator.pop(context);
                    } else if (respuesta == 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Error al registrar al cliente")),
                      );
                    }
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: ButtonModel1(
                    text: "Cancelar",
                    width: 175,
                    fontSize: 16,
                    lightColor: Colors.black54,
                    darkColor: const Color.fromARGB(255, 65, 60, 68),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
