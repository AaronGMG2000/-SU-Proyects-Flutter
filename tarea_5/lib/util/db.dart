import 'package:tarea_2/models/Seguro.dart';
import 'package:tarea_2/models/cliente.dart';
import 'package:tarea_2/models/login.dart';
import 'package:tarea_2/models/perito.dart';
import 'package:tarea_2/models/siniestro.dart';
import 'package:tarea_2/provider/api_manager.dart';
import 'package:tarea_2/repository/cliente_repository.dart';
import 'package:tarea_2/repository/login_repository.dart';
import 'package:tarea_2/repository/perito_repository.dart';
import 'package:tarea_2/repository/seguro_repository.dart';
import 'package:tarea_2/repository/siniestro_repository.dart';
import 'package:tarea_2/util/app_type.dart';

Future<void> initData() async {
  dynamic dataLogin = await ApiManager.shared.request(
    baseUrl: "192.168.1.13:8585",
    pathUrl: "/user/buscar",
    type: HttpType.get,
  );
  List<Login> loginDB = await dataLogin.map<Login>((dynamic item) {
    return Login.fromService(item);
  }).toList();

  await LoginRepository.shared.save(data: loginDB, table: 'login');

  dynamic dataClient = await ApiManager.shared.request(
    baseUrl: "192.168.1.13:8585",
    pathUrl: "/cliente/buscar",
    type: HttpType.get,
  );
  List<Cliente> clientesDB = await dataClient.map<Cliente>((dynamic item) {
    return Cliente.fromService(item);
  }).toList();
  await ClienteRepository.shared.save(data: clientesDB, table: 'cliente');
  dynamic dataSeguro = await ApiManager.shared.request(
    baseUrl: "192.168.1.13:8585",
    pathUrl: "/seguro/buscar",
    type: HttpType.get,
  );
  List<Seguro> segurosDB = await dataSeguro.map<Seguro>((dynamic item) {
    return Seguro.fromService(item);
  }).toList();
  await SeguroRepository.shared.save(data: segurosDB, table: 'seguro');

  dynamic dataPerito = await ApiManager.shared.request(
    baseUrl: "192.168.1.13:8585",
    pathUrl: "/perito/buscar",
    type: HttpType.get,
  );
  List<Perito> peritosDB = await dataPerito.map<Perito>((dynamic item) {
    return Perito.fromService(item);
  }).toList();
  await PeritoRepository.shared.save(data: peritosDB, table: 'perito');

  dynamic dataSiniestro = await ApiManager.shared.request(
    baseUrl: "192.168.1.13:8585",
    pathUrl: "/siniestro/buscar",
    type: HttpType.get,
  );
  List<Siniestro> siniestrosDB =
      await dataSiniestro.map<Siniestro>((dynamic item) {
    return Siniestro.fromService(item);
  }).toList();
  await SiniestroRepository.shared.save(data: siniestrosDB, table: 'siniestro');
}
