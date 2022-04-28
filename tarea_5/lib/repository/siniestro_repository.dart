import 'package:tarea_2/main.dart';
import 'package:tarea_2/models/siniestro.dart';
import 'package:tarea_2/provider/api_manager.dart';
import 'package:tarea_2/repository/master_repository.dart';
import 'package:tarea_2/repository/perito_repository.dart';
import 'package:tarea_2/util/app_type.dart';

class SiniestroRepository extends MasterRepository {
  SiniestroRepository._privateConstructor();
  static final SiniestroRepository shared =
      SiniestroRepository._privateConstructor();
  Future<List<Map<String, dynamic>>> getAllSave() async {
    if (Myapp.connected.value) {
      await PeritoRepository.shared.getAllSave();
      shared.deleteTable(tablName: 'siniestro');
      dynamic dataSiniestro = await ApiManager.shared.request(
        baseUrl: "192.168.0.8:8585",
        pathUrl: "/siniestro/buscar",
        type: HttpType.get,
      );
      List<Siniestro> siniestroDB =
          await dataSiniestro.map<Siniestro>((dynamic item) {
        return Siniestro.fromService(item);
      }).toList();
      await SiniestroRepository.shared
          .save(data: siniestroDB, table: 'siniestro');
    }
    return await shared.getAll(table: 'siniestro');
  }
}
