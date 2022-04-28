import 'package:tarea_2/repository/master_repository.dart';

class ClienteRepository extends MasterRepository {
  ClienteRepository._privateConstructor();
  static final ClienteRepository shared =
      ClienteRepository._privateConstructor();
}
