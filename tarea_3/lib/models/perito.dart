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

  Perito({
    required this.dniPerito,
    required this.nombrePerito,
    required this.apellidoPerito1,
    required this.apellidoPerito2,
    required this.telefonoContacto,
    required this.telefonoOficina,
    required this.claseVia,
    required this.nombreVia,
    required this.numeroVia,
    required this.codPostal,
    required this.ciudad,
  });

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
    Map<String, dynamic> data = {
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
    return data;
  }
}
