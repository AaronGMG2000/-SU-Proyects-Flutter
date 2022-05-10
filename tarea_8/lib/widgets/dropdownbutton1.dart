import 'package:flutter/material.dart';
import 'package:tarea_2/repository/app_preferences.dart';

class Dropdownbutton1 extends StatefulWidget {
  final List<String> items;
  final Function(dynamic) onChanged;
  final double padding;
  final Function getValue;
  final String initialValue;
  const Dropdownbutton1({
    Key? key,
    required this.items,
    required this.onChanged,
    required this.getValue,
    required this.initialValue,
    this.padding = 30,
  }) : super(key: key);

  @override
  _Dropdownbutton1State createState() => _Dropdownbutton1State();
}

class _Dropdownbutton1State extends State<Dropdownbutton1> {
  late String? selectedItem = widget.initialValue;

  Future<void> getDefault() async {
    Future.delayed(Duration.zero, () async {
      dynamic value = await widget.getValue();
      setState(() {
        selectedItem = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getDefault();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 3,
              color: Colors.white,
            ),
          ),
          contentPadding: EdgeInsets.all(0),
        ),
        value: selectedItem,
        items: widget.items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (item) {
          setState(() {
            selectedItem = item;
            widget.onChanged(item);
          });
        },
      ),
    );
  }
}
