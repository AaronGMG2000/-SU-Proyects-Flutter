import 'package:tarea_2/main.dart';
import 'package:tarea_2/models/cliente.dart';
import 'package:tarea_2/provider/api_manager.dart';
import 'package:tarea_2/repository/master_repository.dart';
import 'package:tarea_2/util/app_type.dart';

class ClienteRepository extends MasterRepository {
  ClienteRepository._privateConstructor();
  static final ClienteRepository shared =
      ClienteRepository._privateConstructor();
  Future<List<Map<String, dynamic>>> getAllSave() async {
    if (Myapp.connected.value) {
      shared.deleteTable(tablName: 'cliente');
      dynamic dataCliente = await ApiManager.shared.request(
        baseUrl: "192.168.1.8:8585",
        pathUrl: "/cliente/buscar",
        type: HttpType.get,
      );
      List<Cliente> clienteDB = await dataCliente.map<Cliente>((dynamic item) {
        return Cliente.fromService(item);
      }).toList();
      await ClienteRepository.shared.save(data: clienteDB, table: 'cliente');
    }
    return await shared.getAll(table: 'cliente');
  }
}
