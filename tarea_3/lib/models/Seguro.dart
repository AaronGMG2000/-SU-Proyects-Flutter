class Seguro {
  late int numeroPoliza;
  late int dniCl;
  late String ramo;
  late String observaciones;
  late String condicionesParticulares;
  late DateTime fechaInicio;
  late DateTime fechaVencimiento;

  Seguro({
    required this.numeroPoliza,
    required this.dniCl,
    required this.ramo,
    required this.observaciones,
    required this.condicionesParticulares,
    required this.fechaInicio,
    required this.fechaVencimiento,
  });

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
    Map<String, dynamic> data = {
      'numeroPoliza': numeroPoliza,
      'dniCl': dniCl,
      'ramo': ramo,
      'observaciones': observaciones,
      'condicionesParticulares': condicionesParticulares,
      'fechaInicio': fechaInicio.toIso8601String().split("T")[0],
      'fechaVencimiento': fechaVencimiento.toIso8601String().split("T")[0],
    };
    return data;
  }
}
