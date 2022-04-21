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

  Cliente() {
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
  }

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
  }

  Map<String, dynamic> toDatabase() => {
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
      };

  Map<String, dynamic> toDatabaseU() => {
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
      };
  toMap() {
    return {
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
    };
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
  }
}
