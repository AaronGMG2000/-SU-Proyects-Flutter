import 'package:tarea_2/main.dart';
import 'package:tarea_2/models/Seguro.dart';
import 'package:tarea_2/provider/api_manager.dart';
import 'package:tarea_2/repository/master_repository.dart';
import 'package:tarea_2/util/app_type.dart';

class SeguroRepository extends MasterRepository {
  SeguroRepository._privateConstructor();
  static final SeguroRepository shared = SeguroRepository._privateConstructor();
  Future<List<Map<String, dynamic>>> getAllSave() async {
    if (Myapp.connected.value) {
      shared.deleteTable(tablName: 'seguro');
      dynamic dataPerito = await ApiManager.shared.request(
        baseUrl: "192.168.1.4:8585",
        pathUrl: "/seguro/buscar",
        type: HttpType.get,
      );
      List<Seguro> segurosDB = await dataPerito.map<Seguro>((dynamic item) {
        return Seguro.fromService(item);
      }).toList();
      await SeguroRepository.shared.save(data: segurosDB, table: 'seguro');
    }
    return await shared.getAll(table: 'seguro');
  }
}
