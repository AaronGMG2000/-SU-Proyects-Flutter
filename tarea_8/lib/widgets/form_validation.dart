import 'package:flutter/services.dart';
import 'package:tarea_2/localizations/localizations.dart';
import 'package:tarea_2/models/login.dart';
import 'package:tarea_2/util/app_string.dart';
import 'package:tarea_2/widgets/button_model1.dart';
import 'package:tarea_2/widgets/checkbox_model.dart';
import 'package:tarea_2/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class FormValidation extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;
  final Login login;
  const FormValidation({
    Key? key,
    required this.formKey,
    required this.onSubmit,
    required this.login,
  }) : super(key: key);

  @override
  _FormValidationState createState() => _FormValidationState();
}

class _FormValidationState extends State<FormValidation> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final RegExp reg = RegExp(
  //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  @override
  Widget build(BuildContext context) {
    final locatizations = AppLocalizations(Localizations.localeOf(context));
    return Form(
      key: widget.formKey,
      child: AutofillGroup(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: TextInputT(
                onEditingComplete: () {
                  TextInput.finishAutofillContext();
                },
                hinText: locatizations.dictionary(Strings.emailString),
                autofillHints: const [AutofillHints.email],
                initialValue: "",
                iconData: Icons.email,
                controller: _emailController,
                inputType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return locatizations.dictionary(Strings.errorEmailForm);
                  }
                  if (!EmailValidator.validate(value)) {
                    return locatizations.dictionary(Strings.errorEmailForm2);
                  }
                  // if (!reg.hasMatch(value)) {
                  //   return 'Por favor, introduzca un Email valido';
                  // }
                  return null;
                },
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    widget.login.email = value;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: TextInputT(
                initialValue: "",
                autofillHints: const [AutofillHints.password],
                onEditingComplete: () {},
                hinText: locatizations.dictionary(Strings.passwordString),
                iconData: Icons.visibility,
                controller: _passwordController,
                inputType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return locatizations.dictionary(Strings.errorPasswordForm);
                  }

                  return null;
                },
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    widget.login.password = value;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 30,
                left: 20,
              ),
              child: CheckboxModel(
                onChanged: (value) {
                  widget.login.rememberMe = value;
                },
                rememberMe: widget.login.rememberMe,
                text: locatizations.dictionary(Strings.rememberString),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Text(
                      locatizations.dictionary(Strings.helpString),
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "SegoeUI",
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: ButtonModel1(
                      text: locatizations.dictionary(Strings.signInString),
                      width: 150,
                      fontSize: 16,
                      lightColor: Colors.blue,
                      darkColor: const Color.fromRGBO(174, 124, 232, 1),
                      onPressed: widget.onSubmit,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
