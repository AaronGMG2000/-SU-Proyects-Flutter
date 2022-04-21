import 'package:tarea_2/models/Seguro.dart';
import 'package:tarea_2/util/validations.dart';
import 'package:tarea_2/widgets/button_model1.dart';
import 'package:tarea_2/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:tarea_2/widgets/text_input_date.dart';

class FormSeguroValidation extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Future<int> Function(Seguro cliente) onSubmit;
  final Seguro seguro;
  const FormSeguroValidation({
    Key? key,
    required this.formKey,
    required this.onSubmit,
    required this.seguro,
  }) : super(key: key);

  @override
  _FormSeguroValidation createState() => _FormSeguroValidation();
}

class _FormSeguroValidation extends State<FormSeguroValidation> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextInput(
            hinText: "Numero de Poliza",
            initialValue: widget.seguro.numeroPoliza == 0
                ? ""
                : widget.seguro.numeroPoliza.toString(),
            iconData: Icons.abc,
            controller: TextEditingController(),
            inputType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, introduzca el numero de poliza';
              }
              if (!Validator(value).isNumber) {
                return 'Por favor, introduzca un numero valido';
              }
              return null;
            },
            onSaved: (value) {
              if (value != null && value.isNotEmpty) {
                widget.seguro.numeroPoliza = int.parse(value);
              }
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: TextInput(
              initialValue: widget.seguro.dniCl == 0
                  ? ""
                  : widget.seguro.dniCl.toString(),
              hinText: "DNI Cliente",
              iconData: Icons.abc,
              controller: TextEditingController(),
              inputType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduzca el Dni del cliente';
                }
                if (!Validator(value).isNumber) {
                  return 'Por favor, introduzca un numero valido';
                }
                return null;
              },
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  widget.seguro.dniCl = int.parse(value);
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: TextInput(
              initialValue: widget.seguro.ramo,
              hinText: "Ramo",
              iconData: Icons.abc,
              controller: TextEditingController(),
              inputType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduzca el ramo';
                }
                return null;
              },
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  widget.seguro.ramo = value;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: TextInput(
              initialValue: widget.seguro.condicionesParticulares,
              hinText: "Condiciones particulares",
              iconData: Icons.abc,
              controller: TextEditingController(),
              inputType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduzca las condiciones particulares';
                }
                return null;
              },
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  widget.seguro.condicionesParticulares = value;
                }
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: TextInputDate(
              initialValue: widget.seguro.fechaInicio.toIso8601String(),
              hinText: "Fecha de Inicio",
              iconData: Icons.calendar_month,
              controller: TextEditingController(),
              inputType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduzca la fecha de inicio';
                }
                return null;
              },
              onSaved: (value) {
                widget.seguro.fechaInicio = value;
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: TextInputDate(
              initialValue: widget.seguro.fechaVencimiento.toIso8601String(),
              hinText: "Fecha vencimiento",
              iconData: Icons.calendar_month,
              controller: TextEditingController(),
              inputType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduzca la fecha de vencimiento';
                }
                return null;
              },
              onSaved: (value) {
                widget.seguro.fechaVencimiento = value;
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: TextInput(
              initialValue: widget.seguro.observaciones,
              hinText: "Observaciones",
              iconData: Icons.description,
              controller: TextEditingController(),
              maxlines: 2,
              inputType: TextInputType.text,
              validator: (value) {
                return null;
              },
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  widget.seguro.observaciones = value;
                } else {
                  widget.seguro.observaciones = "***";
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
                    int respuesta = await widget.onSubmit(widget.seguro);
                    if (respuesta == 2) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Seguro registrado con exito")),
                      );
                      Navigator.pop(context);
                    } else if (respuesta == 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Error al registrar el Seguro")),
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
