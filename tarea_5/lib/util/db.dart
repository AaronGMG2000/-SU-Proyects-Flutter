import 'package:tarea_2/repository/cliente_repository.dart';
import 'package:tarea_2/repository/perito_repository.dart';
import 'package:tarea_2/repository/seguro_repository.dart';
import 'package:tarea_2/repository/siniestro_repository.dart';

Future<void> initData() async {
  await ClienteRepository.shared.getAllSave();

  await SeguroRepository.shared.getAllSave();

  await PeritoRepository.shared.getAllSave();

  await SiniestroRepository.shared.getAllSave();
}
