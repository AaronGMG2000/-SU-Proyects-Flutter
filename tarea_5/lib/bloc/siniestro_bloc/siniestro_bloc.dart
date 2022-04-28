import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tarea_2/models/siniestro.dart';
import 'package:tarea_2/provider/api_manager.dart';
import 'package:tarea_2/repository/siniestro_repository.dart';
import 'package:tarea_2/util/app_type.dart';
part 'siniestro_event.dart';
part 'siniestro_state.dart';

class SiniestroBloc extends Bloc<SiniestroEvent, SiniestroState> {
  SiniestroBloc() : super(AppStarted()) {
    on<CreateEvent>(
      (event, emit) async {
        emit(ProccessLoad());
        dynamic dataSiniestro = await ApiManager.shared.request(
            baseUrl: "192.168.0.8:8585",
            pathUrl: "/siniestro/guardar",
            type: HttpType.post,
            bodyParams: {
              "aceptado": event.siniestro.aceptado,
              "causas": event.siniestro.causas,
              "fechaSiniestro":
                  event.siniestro.fechaSiniestro.toIso8601String(),
              "idSiniestro": event.siniestro.idSiniestro,
              "indermizacion": event.siniestro.indermizacion,
              "perito": {
                "dniPerito": event.siniestro.dniPerito,
              },
              "seguro": {
                "numeroPoliza": event.siniestro.numeroPoliza,
              }
            });
        if (dataSiniestro != null) {
          Siniestro siniestroN = Siniestro.fromService(dataSiniestro);
          await Future.delayed(const Duration(milliseconds: 1500));
          dynamic data = await SiniestroRepository.shared
              .save(data: [siniestroN], table: 'siniestro');
          if (data != null) {
            emit(CreateSuccess(siniestro: siniestroN));
          } else {
            emit(EventFailure(message: "Error al crear el siniestro"));
          }
        } else {
          emit(EventFailure(message: "Error al crear el siniestro"));
        }
      },
    );
    on<UpdateEvent>(
      (event, emit) async {
        emit(ProccessLoad());
        dynamic dataSiniestro = await ApiManager.shared.request(
            baseUrl: "192.168.0.8:8585",
            pathUrl: "/siniestro/actualizar",
            type: HttpType.put,
            bodyParams: {
              "aceptado": event.siniestro.aceptado,
              "causas": event.siniestro.causas,
              "fechaSiniestro":
                  event.siniestro.fechaSiniestro.toIso8601String(),
              "idSiniestro": event.siniestro.idSiniestro,
              "indermizacion": event.siniestro.indermizacion,
              "perito": {
                "dniPerito": event.siniestro.dniPerito,
              },
              "seguro": {
                "numeroPoliza": event.siniestro.numeroPoliza,
              }
            });
        if (dataSiniestro != null) {
          await Future.delayed(const Duration(milliseconds: 1500));
          dynamic data = await SiniestroRepository.shared.update(
            data: event.siniestro,
            table: 'siniestro',
            where: 'idSiniestro = ?',
            whereArgs: [event.siniestro.idSiniestro.toString()],
          );
          if (data != null) {
            emit(UpdateSuccess(siniestro: event.siniestro));
          } else {
            emit(EventFailure(message: "Error al actualizar el siniestro"));
          }
        } else {
          emit(EventFailure(message: "Error al actualizar el siniestro"));
        }
      },
    );

    on<DeleteEvent>(
      (event, emit) async {
        await ApiManager.shared.request(
          baseUrl: "192.168.0.8:8585",
          pathUrl: "/siniestro/eliminar/${event.idSiniestro.toString()}",
          type: HttpType.delete,
        );
        dynamic data = await SiniestroRepository.shared.delete(
          table: 'siniestro',
          where: 'idSiniestro = ?',
          whereArgs: [event.idSiniestro.toString()],
        );
        if (data != null) {
          emit(DeleteSuccess(
              idSiniestro: event.idSiniestro, index: event.index));
        } else {
          emit(EventFailure(message: "Error al eliminar el siniestro"));
        }
      },
    );
  }
}
