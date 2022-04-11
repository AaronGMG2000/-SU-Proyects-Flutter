import 'package:flutter/material.dart';

class PageThree extends StatelessWidget {
  final String username;
  final String name;
  final String email;
  const PageThree({
    Key? key,
    required this.username,
    required this.name,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            child: Text("Bienvenido $username"),
            alignment: Alignment.center,
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: double.infinity,
            child: Text("Tu nombre es $name"),
            alignment: Alignment.center,
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: double.infinity,
            child: Text("Tu email es $email"),
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}
