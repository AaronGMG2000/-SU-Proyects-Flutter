class Siniestro {
  late int idSiniestro;
  late String causas;
  late String aceptado;
  late String indermizacion;
  late DateTime fechaSiniestro;
  late int numeroPoliza;
  late int dniPerito;

  Siniestro() {
    idSiniestro = 0;
    causas = "";
    aceptado = "";
    indermizacion = "";
    fechaSiniestro = DateTime.now();
    numeroPoliza = 0;
    dniPerito = 0;
  }

  Siniestro.fromService(Map<String, dynamic> data) {
    idSiniestro = data['idSiniestro'];
    causas = data['causas'];
    aceptado = data['aceptado'];
    indermizacion = data['indermizacion'];
    fechaSiniestro = DateTime.parse(data['fechaSiniestro']);
    numeroPoliza = data['seguro']['numeroPoliza'];
    dniPerito = data['perito']['dniPerito'];
  }

  Siniestro.fromLocal(Map<String, dynamic> data) {
    idSiniestro = data['idSiniestro'];
    causas = data['causas'];
    aceptado = data['aceptado'];
    indermizacion = data['indermizacion'];
    fechaSiniestro = DateTime.parse(data['fechaSiniestro']);
    numeroPoliza = data['numeroPoliza'];
    dniPerito = data['dniPerito'];
  }

  clear() {
    idSiniestro = 0;
    causas = "";
    aceptado = "";
    indermizacion = "";
    fechaSiniestro = DateTime.now();
    numeroPoliza = 0;
    dniPerito = 0;
  }

  Map<String, dynamic> toDatabase() => {
        'idSiniestro': idSiniestro,
        'causas': causas,
        'aceptado': aceptado,
        'indermizacion': indermizacion,
        'fechaSiniestro': fechaSiniestro.toIso8601String(),
        'numeroPoliza': numeroPoliza,
        'dniPerito': dniPerito,
      };

  Map<String, dynamic> toDatabaseU() => {
        'idSiniestro': idSiniestro,
        'causas': causas,
        'aceptado': aceptado,
        'indermizacion': indermizacion,
        'fechaSiniestro': fechaSiniestro.toIso8601String(),
        'numeroPoliza': numeroPoliza,
        'dniPerito': dniPerito,
      };
}
