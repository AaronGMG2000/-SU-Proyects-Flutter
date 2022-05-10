import 'package:tarea_2/main.dart';
import 'package:tarea_2/models/login.dart';
import 'package:tarea_2/provider/api_manager.dart';
import 'package:tarea_2/repository/master_repository.dart';
import 'package:tarea_2/util/app_type.dart';

class LoginRepository extends MasterRepository {
  LoginRepository._privateConstructor();
  static final LoginRepository shared = LoginRepository._privateConstructor();

  Future<List<Map<String, dynamic>>> getAllSave() async {
    if (Myapp.connected.value) {
      shared.deleteTable(tablName: 'login');
      dynamic dataLogin = await ApiManager.shared.request(
        baseUrl: "192.168.1.4:8585",
        pathUrl: "/user/buscar",
        type: HttpType.get,
      );
      List<Login> loginDB = await dataLogin.map<Login>((dynamic item) {
        return Login.fromService(item);
      }).toList();

      await LoginRepository.shared.save(data: loginDB, table: 'login');
    }
    return await shared.getAll(table: 'login');
  }
}
