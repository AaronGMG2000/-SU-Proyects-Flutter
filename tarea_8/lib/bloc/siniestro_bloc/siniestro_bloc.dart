import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarea_2/localizations/localizations.dart';
import 'package:tarea_2/models/siniestro.dart';
import 'package:tarea_2/provider/api_manager.dart';
import 'package:tarea_2/repository/app_preferences.dart';
import 'package:tarea_2/repository/siniestro_repository.dart';
import 'package:tarea_2/util/app_string.dart';
import 'package:tarea_2/util/app_type.dart';
part 'siniestro_event.dart';
part 'siniestro_state.dart';

class SiniestroBloc extends Bloc<SiniestroEvent, SiniestroState> {
  SiniestroBloc() : super(AppStarted()) {
    on<CreateEvent>(
      (event, emit) async {
        String? location =
            await AppPreferences.shared.getStringPreference('defaultLanguage');
        final locatizations = AppLocalizations(Locale(location ?? 'es', ''));
        emit(ProccessLoad());
        dynamic dataSiniestro = await ApiManager.shared.request(
            baseUrl: "192.168.1.4:8585",
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
            emit(EventFailure(
                message: locatizations
                    .dictionary(Strings.errorRegistrarSiniestroString)));
          }
        } else {
          emit(EventFailure(
              message: locatizations
                  .dictionary(Strings.errorRegistrarSiniestroString)));
        }
      },
    );
    on<UpdateEvent>(
      (event, emit) async {
        String? location =
            await AppPreferences.shared.getStringPreference('defaultLanguage');
        final locatizations = AppLocalizations(Locale(location ?? 'es', ''));
        emit(ProccessLoad());
        dynamic dataSiniestro = await ApiManager.shared.request(
            baseUrl: "192.168.1.4:8585",
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
            emit(EventFailure(
                message: locatizations
                    .dictionary(Strings.errorActualizarSiniestroString)));
          }
        } else {
          emit(EventFailure(
              message: locatizations
                  .dictionary(Strings.errorActualizarSiniestroString)));
        }
      },
    );

    on<DeleteEvent>(
      (event, emit) async {
        String? location =
            await AppPreferences.shared.getStringPreference('defaultLanguage');
        final locatizations = AppLocalizations(Locale(location ?? 'es', ''));
        await ApiManager.shared.request(
          baseUrl: "192.168.1.4:8585",
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
          emit(EventFailure(
              message: locatizations
                  .dictionary(Strings.errorEliminarSiniestroString)));
        }
      },
    );
  }
}
