class Perito {
  late int dniPerito;
  late String nombrePerito;
  late String apellidoPerito1;
  late String apellidoPerito2;
  late String telefonoContacto;
  late String telefonoOficina;
  late String claseVia;
  late String nombreVia;
  late String numeroVia;
  late String codPostal;
  late String ciudad;

  Perito() {
    dniPerito = 0;
    nombrePerito = "";
    apellidoPerito1 = "";
    apellidoPerito2 = "";
    telefonoContacto = "";
    telefonoOficina = "";
    claseVia = "";
    nombreVia = "";
    numeroVia = "";
    codPostal = "";
    ciudad = "";
  }

  Perito.fromService(Map<String, dynamic> data) {
    dniPerito = data['dniPerito'];
    nombrePerito = data['nombrePerito'];
    apellidoPerito1 = data['apellidoPerito1'];
    apellidoPerito2 = data['apellidoPerito2'];
    telefonoContacto = data['telefonoContacto'];
    telefonoOficina = data['telefonoOficina'];
    claseVia = data['claseVia'];
    nombreVia = data['nombreVia'];
    numeroVia = data['numeroVia'];
    codPostal = data['codPostal'];
    ciudad = data['ciudad'];
  }

  toMap() {
    return {
      'dniPerito': dniPerito,
      'nombrePerito': nombrePerito,
      'apellidoPerito1': apellidoPerito1,
      'apellidoPerito2': apellidoPerito2,
      'telefonoContacto': telefonoContacto,
      'telefonoOficina': telefonoOficina,
      'claseVia': claseVia,
      'nombreVia': nombreVia,
      'numeroVia': numeroVia,
      'codPostal': codPostal,
      'ciudad': ciudad,
    };
  }

  Map<String, dynamic> toDatabase() => {
        'dniPerito': dniPerito,
        'nombrePerito': nombrePerito,
        'apellidoPerito1': apellidoPerito1,
        'apellidoPerito2': apellidoPerito2,
        'telefonoContacto': telefonoContacto,
        'telefonoOficina': telefonoOficina,
        'claseVia': claseVia,
        'nombreVia': nombreVia,
        'numeroVia': numeroVia,
        'codPostal': codPostal,
        'ciudad': ciudad,
      };
}
