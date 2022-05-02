import 'package:tarea_2/main.dart';
import 'package:tarea_2/models/perito.dart';
import 'package:tarea_2/provider/api_manager.dart';
import 'package:tarea_2/repository/master_repository.dart';
import 'package:tarea_2/util/app_type.dart';

class PeritoRepository extends MasterRepository {
  PeritoRepository._privateConstructor();
  static final PeritoRepository shared = PeritoRepository._privateConstructor();

  Future<List<Map<String, dynamic>>> getAllSave() async {
    if (Myapp.connected.value) {
      shared.deleteTable(tablName: 'perito');
      dynamic dataPerito = await ApiManager.shared.request(
        baseUrl: "192.168.1.8:8585",
        pathUrl: "/perito/buscar",
        type: HttpType.get,
      );
      List<Perito> peritosDB = await dataPerito.map<Perito>((dynamic item) {
        return Perito.fromService(item);
      }).toList();
      await PeritoRepository.shared.save(data: peritosDB, table: 'perito');
    }
    return await shared.getAll(table: 'perito');
  }
}
