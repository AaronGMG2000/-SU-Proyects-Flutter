import 'package:tarea_2/models/Seguro.dart';

class Cliente {
  late int dniCl;
  late String nombreCl;
  late String apellido1;
  late String apellido2;
  late String claseVia;
  late String nombreVia;
  late String numeroVia;
  late String codPostal;
  late String ciudad;
  late String telefono;
  late String observaciones;
  late List<Seguro> segurosList = [];

  Cliente({
    required this.dniCl,
    required this.nombreCl,
    required this.apellido1,
    required this.apellido2,
    required this.claseVia,
    required this.nombreVia,
    required this.numeroVia,
    required this.codPostal,
    required this.ciudad,
    required this.telefono,
    required this.observaciones,
    required this.segurosList,
  });

  Cliente.fromService(Map<String, dynamic> data) {
    dniCl = data['dniCl'];
    nombreCl = data['nombreCl'];
    apellido1 = data['apellido1'];
    apellido2 = data['apellido2'];
    claseVia = data['claseVia'];
    nombreVia = data['nombreVia'];
    numeroVia = data['numeroVia'];
    codPostal = data['codPostal'];
    ciudad = data['ciudad'];
    telefono = data['telefono'];
    observaciones = data['observaciones'];
    if (data['segurosList'] != null) {
      List<dynamic> seguros = data['segurosList'] as List<dynamic>;
      for (var element in seguros) {
        segurosList.add(Seguro.fromService(element));
      }
    }
  }

  toMap() {
    Map<String, dynamic> data = {
      'dniCl': dniCl,
      'nombreCl': nombreCl,
      'apellido1': apellido1,
      'apellido2': apellido2,
      'claseVia': claseVia,
      'nombreVia': nombreVia,
      'numeroVia': numeroVia,
      'codPostal': codPostal,
      'ciudad': ciudad,
      'telefono': telefono,
      'observaciones': observaciones,
      'segurosList': segurosList,
    };
    return data;
  }

  clear() {
    dniCl = 0;
    nombreCl = '';
    apellido1 = '';
    apellido2 = '';
    claseVia = '';
    nombreVia = '';
    numeroVia = '';
    codPostal = '';
    ciudad = '';
    telefono = '';
    observaciones = '';
    segurosList.clear();
  }
}
