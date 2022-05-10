import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea_2/bloc/seguro_bloc/seguro_bloc.dart';
import 'package:tarea_2/localizations/localizations.dart';
import 'package:tarea_2/models/Seguro.dart';
import 'package:tarea_2/util/app_string.dart';
import 'package:tarea_2/util/validations.dart';
import 'package:tarea_2/widgets/button_model1.dart';
import 'package:tarea_2/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:tarea_2/widgets/text_input_date.dart';

class FormSeguroValidation extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Future<void> Function(Seguro cliente) onSubmit;
  final Seguro seguro;
  final Function(bool value) showSpinner;
  final bool update;
  const FormSeguroValidation({
    Key? key,
    required this.formKey,
    required this.onSubmit,
    required this.seguro,
    required this.showSpinner,
    this.update = false,
  }) : super(key: key);

  @override
  _FormSeguroValidation createState() => _FormSeguroValidation();
}

class _FormSeguroValidation extends State<FormSeguroValidation> {
  @override
  Widget build(BuildContext context) {
    final locatizations = AppLocalizations(Localizations.localeOf(context));
    return BlocProvider(
      create: (BuildContext context) => SeguroBloc(),
      child: BlocListener<SeguroBloc, SeguroState>(
        listener: (context, state) {
          switch (state.runtimeType) {
            case AppStarted:
              break;
            case ProccessLoad:
              widget.showSpinner(true);
              break;
            case CreateSuccess:
              final estado = state as CreateSuccess;
              widget.showSpinner(false);
              widget.onSubmit(estado.seguro);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(locatizations
                        .dictionary(Strings.guardadoSeguroString))),
              );
              Navigator.pop(context);
              break;
            case UpdateSuccess:
              final estado = state as UpdateSuccess;
              widget.showSpinner(false);
              widget.onSubmit(estado.seguro);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(locatizations
                        .dictionary(Strings.actualizadoSeguroString))),
              );
              Navigator.pop(context);
              break;
            case EventFailure:
              final estado = state as EventFailure;
              widget.showSpinner(false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(estado.message)),
              );
              break;
          }
        },
        child: BlocBuilder<SeguroBloc, SeguroState>(
          builder: (context, state) {
            return Form(
              key: widget.formKey,
              child: Column(
                children: [
                  TextInputT(
                    onEditingComplete: () {},
                    hinText:
                        locatizations.dictionary(Strings.numeroPolizaString),
                    initialValue: widget.seguro.numeroPoliza == 0
                        ? ""
                        : widget.seguro.numeroPoliza.toString(),
                    iconData: Icons.abc,
                    controller: TextEditingController(),
                    inputType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return locatizations
                            .dictionary(Strings.errorNumeroPolizaForm);
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
                    child: TextInputT(
                      onEditingComplete: () {},
                      initialValue: widget.seguro.dniCl == 0
                          ? ""
                          : widget.seguro.dniCl.toString(),
                      hinText:
                          locatizations.dictionary(Strings.dniClienteString),
                      iconData: Icons.abc,
                      controller: TextEditingController(),
                      inputType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return locatizations
                              .dictionary(Strings.errorDniClienteForm);
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
                    child: TextInputT(
                      onEditingComplete: () {},
                      initialValue: widget.seguro.ramo,
                      hinText: locatizations.dictionary(Strings.ramoString),
                      iconData: Icons.abc,
                      controller: TextEditingController(),
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return locatizations
                              .dictionary(Strings.errorRamoForm);
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
                    child: TextInputT(
                      onEditingComplete: () {},
                      initialValue: widget.seguro.condicionesParticulares,
                      hinText:
                          locatizations.dictionary(Strings.condicionesString),
                      iconData: Icons.abc,
                      controller: TextEditingController(),
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return locatizations
                              .dictionary(Strings.errorCondicionesForm);
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
                      hinText:
                          locatizations.dictionary(Strings.fechaInicioString),
                      iconData: Icons.calendar_month,
                      controller: TextEditingController(),
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return locatizations
                              .dictionary(Strings.errorFechaInicioForm);
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
                      initialValue:
                          widget.seguro.fechaVencimiento.toIso8601String(),
                      hinText: locatizations.dictionary(Strings.fechaFinString),
                      iconData: Icons.calendar_month,
                      controller: TextEditingController(),
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return locatizations
                              .dictionary(Strings.errorFechaFinForm);
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
                    child: TextInputT(
                      onEditingComplete: () {},
                      initialValue: widget.seguro.observaciones,
                      hinText:
                          locatizations.dictionary(Strings.observacionesString),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonModel1(
                          text: locatizations.dictionary(Strings.guardarString),
                          width: 175,
                          fontSize: 16,
                          lightColor: Colors.blue,
                          darkColor: const Color.fromRGBO(174, 124, 232, 1),
                          onPressed: () async {
                            if (widget.formKey.currentState!.validate()) {
                              widget.formKey.currentState?.save();
                              widget.update
                                  ? BlocProvider.of<SeguroBloc>(context).add(
                                      UpdateEvent(seguro: widget.seguro),
                                    )
                                  : BlocProvider.of<SeguroBloc>(context).add(
                                      CreateEvent(seguro: widget.seguro),
                                    );
                            }
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: ButtonModel1(
                            text: locatizations
                                .dictionary(Strings.cancelarString),
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
          },
        ),
      ),
    );
  }
}
