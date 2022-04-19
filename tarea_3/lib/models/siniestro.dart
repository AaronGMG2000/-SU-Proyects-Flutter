import 'package:tarea_2/models/Seguro.dart';
import 'package:tarea_2/models/perito.dart';

class Siniestro {
  late int idSiniestro;
  late String causas;
  late String aceptado;
  late String indermizacion;
  late DateTime fechaSiniestro;
  late Seguro seguro;
  late Perito perito;

  Siniestro({
    required this.idSiniestro,
    required this.causas,
    required this.aceptado,
    required this.indermizacion,
    required this.fechaSiniestro,
  }) {
    perito = Perito(
      apellidoPerito1: "",
      apellidoPerito2: "",
      ciudad: "",
      claseVia: "",
      codPostal: "",
      dniPerito: 0,
      nombrePerito: "",
      numeroVia: "",
      nombreVia: "",
      telefonoContacto: "",
      telefonoOficina: "",
    );

    seguro = Seguro(
      condicionesParticulares: "",
      dniCl: 0,
      fechaInicio: DateTime.now(),
      fechaVencimiento: DateTime.now(),
      numeroPoliza: 0,
      observaciones: "",
      ramo: "",
    );
  }

  Siniestro.fromService(Map<String, dynamic> data) {
    idSiniestro = data['idSiniestro'];
    causas = data['causas'];
    aceptado = data['aceptado'];
    indermizacion = data['indermizacion'];
    fechaSiniestro = DateTime.parse(data['fechaSiniestro']);
    seguro = Seguro.fromService(data['seguro']);
    perito = Perito.fromService(data['perito']);
  }

  clear() {
    idSiniestro = 0;
    causas = "";
    aceptado = "";
    indermizacion = "";
    fechaSiniestro = DateTime.now();
    seguro = Seguro(
      condicionesParticulares: "",
      dniCl: 0,
      fechaInicio: DateTime.now(),
      fechaVencimiento: DateTime.now(),
      numeroPoliza: 0,
      observaciones: "",
      ramo: "",
    );
    perito = Perito(
      apellidoPerito1: "",
      apellidoPerito2: "",
      ciudad: "",
      claseVia: "",
      codPostal: "",
      dniPerito: 0,
      nombrePerito: "",
      numeroVia: "",
      nombreVia: "",
      telefonoContacto: "",
      telefonoOficina: "",
    );
  }

  toMap() {
    Map<String, dynamic> data = {
      'idSiniestro': idSiniestro,
      'causas': causas,
      'aceptado': aceptado,
      'indermizacion': indermizacion,
      'fechaSiniestro': fechaSiniestro.toIso8601String().split("T")[0],
      'numeroPoliza': seguro.numeroPoliza,
      'dniPerito': perito.dniPerito,
    };
    return data;
  }
}
