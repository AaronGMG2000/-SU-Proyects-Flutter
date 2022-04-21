class Seguro {
  late int numeroPoliza;
  late int dniCl;
  late String ramo;
  late String observaciones;
  late String condicionesParticulares;
  late DateTime fechaInicio;
  late DateTime fechaVencimiento;

  Seguro() {
    numeroPoliza = 0;
    dniCl = 0;
    ramo = "";
    observaciones = "";
    condicionesParticulares = "";
    fechaInicio = DateTime.now();
    fechaVencimiento = DateTime.now();
  }

  Seguro.fromService(Map<String, dynamic> data) {
    numeroPoliza = data['numeroPoliza'];
    dniCl = data['dniCl'];
    ramo = data['ramo'];
    observaciones = data['observaciones'];
    condicionesParticulares = data['condicionesParticulares'];
    fechaInicio = DateTime.parse(data['fechaInicio']);
    fechaVencimiento = DateTime.parse(data['fechaVencimiento']);
  }

  clear() {
    numeroPoliza = 0;
    dniCl = 0;
    ramo = "";
    observaciones = "";
    condicionesParticulares = "";
    fechaInicio = DateTime.now();
    fechaVencimiento = DateTime.now();
  }

  toMap() {
    return {
      'numeroPoliza': numeroPoliza,
      'dniCl': dniCl,
      'ramo': ramo,
      'observaciones': observaciones,
      'condicionesParticulares': condicionesParticulares,
      'fechaInicio': fechaInicio.toString(),
      'fechaVencimiento': fechaVencimiento.toString(),
    };
  }

  Map<String, dynamic> toDatabase() => {
        'numeroPoliza': numeroPoliza,
        'dniCl': dniCl,
        'ramo': ramo,
        'observaciones': observaciones,
        'condicionesParticulares': condicionesParticulares,
        'fechaInicio': fechaInicio.toIso8601String(),
        'fechaVencimiento': fechaVencimiento.toIso8601String(),
      };

  Map<String, dynamic> toDatabaseU() => {
        'numeroPoliza': numeroPoliza,
        'dniCl': dniCl,
        'ramo': ramo,
        'observaciones': observaciones,
        'condicionesParticulares': condicionesParticulares,
        'fechaInicio': fechaInicio.toIso8601String(),
        'fechaVencimiento': fechaVencimiento.toIso8601String(),
      };
}
