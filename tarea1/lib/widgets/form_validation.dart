import 'package:tarea1/models/login.dart';
import 'package:tarea1/widgets/text_input.dart';
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
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: TextInput(
              hinText: "Email",
              controller: _emailController,
              inputType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduzca un Email';
                }
                if (!EmailValidator.validate(value)) {
                  return 'Por favor, introduzca un Email valido';
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
            child: TextInput(
              hinText: "Password",
              controller: _passwordController,
              inputType: TextInputType.visiblePassword,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduzca su Password';
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: widget.onSubmit,
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
