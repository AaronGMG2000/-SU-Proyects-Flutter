import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea_2/bloc/cliente_bloc/cliente_bloc.dart';
import 'package:tarea_2/localizations/localizations.dart';
import 'package:tarea_2/models/cliente.dart';
import 'package:tarea_2/util/app_string.dart';
import 'package:tarea_2/util/validations.dart';
import 'package:tarea_2/widgets/button_model1.dart';
import 'package:tarea_2/widgets/text_input.dart';
import 'package:flutter/material.dart';

class FormClientValidation extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Future<void> Function(Cliente cliente) onSubmit;
  final Cliente cliente;
  final Function(bool value) showSpinner;
  final bool update;
  const FormClientValidation({
    Key? key,
    required this.formKey,
    required this.onSubmit,
    required this.cliente,
    required this.showSpinner,
    this.update = false,
  }) : super(key: key);

  @override
  _FormClientValidation createState() => _FormClientValidation();
}

class _FormClientValidation extends State<FormClientValidation> {
  @override
  Widget build(BuildContext context) {
    final locatizations = AppLocalizations(Localizations.localeOf(context));
    return BlocProvider(
      create: (BuildContext context) => ClienteBloc(),
      child: BlocListener<ClienteBloc, ClienteState>(
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
              widget.onSubmit(estado.client);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(locatizations
                        .dictionary(Strings.guardadoClienteString))),
              );
              Navigator.pop(context);
              break;
            case UpdateSuccess:
              final estado = state as UpdateSuccess;
              widget.showSpinner(false);
              widget.onSubmit(estado.client);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(locatizations
                        .dictionary(Strings.actualizadoClienteString))),
              );
              Navigator.pop(context);
              break;
            case ClientFailure:
              widget.showSpinner(false);
              final estado = state as ClientFailure;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(estado.message)),
              );
              break;
          }
        },
        child: BlocBuilder<ClienteBloc, ClienteState>(
          builder: (context, state) {
            return Form(
              key: widget.formKey,
              child: Column(
                children: [
                  TextInputT(
                    onEditingComplete: () {},
                    hinText: locatizations.dictionary(Strings.nombreString),
                    initialValue: widget.cliente.nombreCl,
                    iconData: Icons.abc,
                    controller: TextEditingController(),
                    inputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return locatizations.dictionary(Strings.errorNameForm);
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
                    child: TextInputT(
                      onEditingComplete: () {},
                      initialValue: widget.cliente.apellido1,
                      hinText: locatizations.dictionary(Strings.apellidoString),
                      iconData: Icons.abc,
                      controller: TextEditingController(),
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return locatizations
                              .dictionary(Strings.errorApelidoForm);
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
                    child: TextInputT(
                      onEditingComplete: () {},
                      initialValue: widget.cliente.apellido2,
                      hinText:
                          locatizations.dictionary(Strings.apellido2String),
                      iconData: Icons.abc,
                      controller: TextEditingController(),
                      inputType: TextInputType.text,
                      validator: (value) {
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
                    child: TextInputT(
                      onEditingComplete: () {},
                      hinText: locatizations.dictionary(Strings.claseViaString),
                      initialValue: widget.cliente.claseVia,
                      iconData: Icons.abc,
                      controller: TextEditingController(),
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return locatizations
                              .dictionary(Strings.errorClaseViaForm);
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
                    child: TextInputT(
                      initialValue: widget.cliente.nombreVia,
                      onEditingComplete: () {},
                      hinText: locatizations.dictionary(Strings.viaString),
                      iconData: Icons.abc,
                      controller: TextEditingController(),
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return locatizations.dictionary(Strings.errorViaForm);
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
                    child: TextInputT(
                      onEditingComplete: () {},
                      initialValue: widget.cliente.numeroVia,
                      hinText:
                          locatizations.dictionary(Strings.numeroViaString),
                      iconData: Icons.format_list_numbered,
                      controller: TextEditingController(),
                      inputType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return locatizations
                              .dictionary(Strings.errorNumeroViaForm);
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
                    child: TextInputT(
                      onEditingComplete: () {},
                      initialValue: widget.cliente.telefono,
                      hinText: locatizations.dictionary(Strings.telefonoString),
                      iconData: Icons.numbers,
                      controller: TextEditingController(),
                      inputType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return locatizations
                              .dictionary(Strings.errorTelefonoForm);
                        }
                        if (Validator(value).isValidPhon) {
                          return locatizations
                              .dictionary(Strings.errorTelefonoForm2);
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
                    child: TextInputT(
                      onEditingComplete: () {},
                      initialValue: widget.cliente.codPostal,
                      hinText: locatizations.dictionary(Strings.postalString),
                      iconData: Icons.numbers,
                      controller: TextEditingController(),
                      inputType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return locatizations
                              .dictionary(Strings.errorPostalForm);
                        }
                        if (!Validator(value).isValidPostalCod) {
                          return locatizations
                              .dictionary(Strings.errorPostalForm2);
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
                    child: TextInputT(
                      onEditingComplete: () {},
                      initialValue: widget.cliente.ciudad,
                      hinText: locatizations.dictionary(Strings.ciudadString),
                      iconData: Icons.location_city,
                      controller: TextEditingController(),
                      inputType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return locatizations
                              .dictionary(Strings.errorCiudadForm);
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
                    child: TextInputT(
                      onEditingComplete: () {},
                      initialValue: widget.cliente.observaciones,
                      hinText:
                          locatizations.dictionary(Strings.observacionesString),
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
                                  ? BlocProvider.of<ClienteBloc>(context).add(
                                      UpdateClient(cliente: widget.cliente),
                                    )
                                  : BlocProvider.of<ClienteBloc>(context).add(
                                      CreateClient(cliente: widget.cliente),
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