import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea_2/bloc/siniestro_bloc/siniestro_bloc.dart';
import 'package:tarea_2/localizations/localizations.dart';
import 'package:tarea_2/models/siniestro.dart';
import 'package:tarea_2/util/app_string.dart';
import 'package:tarea_2/util/validations.dart';
import 'package:tarea_2/widgets/button_model1.dart';
import 'package:tarea_2/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:tarea_2/widgets/text_input_date.dart';

class FormSiniestroValidation extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Future<void> Function(Siniestro siniestro) onSubmit;
  final Siniestro siniestro;
  final Function(bool value) showSpinner;
  final bool update;
  const FormSiniestroValidation({
    Key? key,
    required this.formKey,
    required this.onSubmit,
    required this.siniestro,
    required this.showSpinner,
    this.update = false,
  }) : super(key: key);

  @override
  _FormSiniestroValidation createState() => _FormSiniestroValidation();
}

class _FormSiniestroValidation extends State<FormSiniestroValidation> {
  @override
  Widget build(BuildContext context) {
    final locatizations = AppLocalizations(Localizations.localeOf(context));
    return BlocProvider(
      create: (BuildContext context) => SiniestroBloc(),
      child: BlocListener<SiniestroBloc, SiniestroState>(
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
              widget.onSubmit(estado.siniestro);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(locatizations
                        .dictionary(Strings.guardadoSiniestroString))),
              );
              Navigator.pop(context);
              break;
            case UpdateSuccess:
              final estado = state as UpdateSuccess;
              widget.showSpinner(false);
              widget.onSubmit(estado.siniestro);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(locatizations
                        .dictionary(Strings.actualizadoSiniestroString))),
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
        child: BlocBuilder<SiniestroBloc, SiniestroState>(
          builder: (context, state) {
            return Form(
              key: widget.formKey,
              child: Column(
                children: [
                  TextInputT(
                    onEditingComplete: () {},
                    hinText:
                        locatizations.dictionary(Strings.idSiniestroString),
                    initialValue: widget.siniestro.idSiniestro == 0
                        ? ""
                        : widget.siniestro.idSiniestro.toString(),
                    iconData: Icons.numbers,
                    controller: TextEditingController(),
                    inputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return locatizations
                            .dictionary(Strings.errorIdSiniestroForm);
                      }
                      if (!Validator(value).isNumber) {
                        return 'Por favor, introduzca un numero valido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null && value.isNotEmpty) {
                        widget.siniestro.idSiniestro = int.parse(value);
                      }
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: TextInputT(
                      onEditingComplete: () {},
                      initialValue: widget.siniestro.indermizacion,
                      hinText:
                          locatizations.dictionary(Strings.indermizacionString),
                      iconData: Icons.numbers,
                      controller: TextEditingController(),
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return locatizations
                              .dictionary(Strings.errorIndermizacionForm);
                        }
                        if (!Validator(value).isNumber) {
                          return 'Por favor, introduzca una indermización válida';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty) {
                          widget.siniestro.indermizacion = value;
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: TextInputT(
                      initialValue: widget.siniestro.causas,
                      onEditingComplete: () {},
                      hinText: locatizations.dictionary(Strings.causasString),
                      iconData: Icons.abc,
                      controller: TextEditingController(),
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return locatizations
                              .dictionary(Strings.errorCausasForm);
                        }

                        return null;
                      },
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty) {
                          widget.siniestro.causas = value;
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: TextInputT(
                      onEditingComplete: () {},
                      initialValue: widget.siniestro.aceptado,
                      hinText: locatizations.dictionary(Strings.aceptadoString),
                      iconData: Icons.abc,
                      controller: TextEditingController(),
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return locatizations
                              .dictionary(Strings.errorAceptadoForm);
                        }

                        return null;
                      },
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty) {
                          widget.siniestro.aceptado = value;
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: TextInputDate(
                      initialValue:
                          widget.siniestro.fechaSiniestro.toIso8601String(),
                      hinText: locatizations
                          .dictionary(Strings.fechaSiniestroString),
                      iconData: Icons.abc,
                      controller: TextEditingController(),
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return locatizations
                              .dictionary(Strings.errorFechaSiniestroForm);
                        }
                        return null;
                      },
                      onSaved: (value) {
                        widget.siniestro.fechaSiniestro = value;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: TextInputT(
                      onEditingComplete: () {},
                      initialValue: widget.siniestro.numeroPoliza == 0
                          ? ""
                          : widget.siniestro.numeroPoliza.toString(),
                      hinText:
                          locatizations.dictionary(Strings.numeroPolizaString),
                      iconData: Icons.abc,
                      controller: TextEditingController(),
                      inputType: TextInputType.text,
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
                          widget.siniestro.numeroPoliza = int.parse(value);
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: TextInputT(
                      onEditingComplete: () {},
                      initialValue: widget.siniestro.dniPerito == 0
                          ? ""
                          : widget.siniestro.dniPerito.toString(),
                      hinText:
                          locatizations.dictionary(Strings.dniPeritoString),
                      iconData: Icons.abc,
                      controller: TextEditingController(),
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return locatizations
                              .dictionary(Strings.errorDniPeritoForm);
                        }
                        if (!Validator(value).isNumber) {
                          return 'Por favor, introduzca un numero valido';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty) {
                          widget.siniestro.dniPerito = int.parse(value);
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
                                  ? BlocProvider.of<SiniestroBloc>(context).add(
                                      UpdateEvent(siniestro: widget.siniestro),
                                    )
                                  : BlocProvider.of<SiniestroBloc>(context).add(
                                      CreateEvent(siniestro: widget.siniestro),
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
