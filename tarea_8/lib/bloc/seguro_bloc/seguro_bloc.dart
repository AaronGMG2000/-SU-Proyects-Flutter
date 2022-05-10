import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:tarea_2/localizations/localizations.dart';
import 'package:tarea_2/models/Seguro.dart';
import 'package:tarea_2/provider/api_manager.dart';
import 'package:tarea_2/repository/app_preferences.dart';
import 'package:tarea_2/repository/seguro_repository.dart';
import 'package:tarea_2/util/app_string.dart';
import 'package:tarea_2/util/app_type.dart';
part 'seguro_event.dart';
part 'seguro_state.dart';

class SeguroBloc extends Bloc<SeguroEvent, SeguroState> {
  SeguroBloc() : super(AppStarted()) {
    on<CreateEvent>(
      (event, emit) async {
        String? location =
            await AppPreferences.shared.getStringPreference('defaultLanguage');
        final locatizations = AppLocalizations(Locale(location ?? 'es', ''));
        emit(ProccessLoad());
        dynamic dataSeguro = await ApiManager.shared.request(
            baseUrl: "192.168.1.4:8585",
            pathUrl: "/seguro/guardar",
            type: HttpType.post,
            bodyParams: {
              "condicionesParticulares": event.seguro.condicionesParticulares,
              "dniCl": event.seguro.dniCl,
              "fechaInicio": event.seguro.fechaInicio.toIso8601String(),
              "fechaVencimiento":
                  event.seguro.fechaVencimiento.toIso8601String(),
              "numeroPoliza": event.seguro.numeroPoliza,
              "observaciones": event.seguro.observaciones,
              "ramo": event.seguro.ramo,
            });
        if (dataSeguro != null) {
          Seguro seguroN = Seguro.fromService(dataSeguro);
          await Future.delayed(const Duration(milliseconds: 1500));
          dynamic data = await SeguroRepository.shared
              .save(data: [seguroN], table: 'seguro');
          if (data != null) {
            emit(CreateSuccess(seguro: seguroN));
          } else {
            emit(EventFailure(
                message: locatizations
                    .dictionary(Strings.errorRegistrarSeguroString)));
          }
        } else {
          emit(EventFailure(
              message: locatizations
                  .dictionary(Strings.errorRegistrarSeguroString)));
        }
      },
    );
    on<UpdateEvent>(
      (event, emit) async {
        String? location =
            await AppPreferences.shared.getStringPreference('defaultLanguage');
        final locatizations = AppLocalizations(Locale(location ?? 'es', ''));
        emit(ProccessLoad());
        dynamic dataSeguro = await ApiManager.shared.request(
            baseUrl: "192.168.1.4:8585",
            pathUrl: "/seguro/actualizar",
            type: HttpType.put,
            bodyParams: {
              "condicionesParticulares": event.seguro.condicionesParticulares,
              "dniCl": event.seguro.dniCl,
              "fechaInicio": event.seguro.fechaInicio.toIso8601String(),
              "fechaVencimiento":
                  event.seguro.fechaVencimiento.toIso8601String(),
              "numeroPoliza": event.seguro.numeroPoliza,
              "observaciones": event.seguro.observaciones,
              "ramo": event.seguro.ramo,
            });
        if (dataSeguro != null) {
          await Future.delayed(const Duration(milliseconds: 1500));
          dynamic data = await SeguroRepository.shared.update(
            data: event.seguro,
            table: 'seguro',
            where: 'numeroPoliza = ?',
            whereArgs: [event.seguro.numeroPoliza.toString()],
          );
          if (data != null) {
            emit(UpdateSuccess(seguro: event.seguro));
          } else {
            emit(EventFailure(
                message: locatizations
                    .dictionary(Strings.errorActualizarSeguroString)));
          }
        } else {
          emit(EventFailure(
              message: locatizations
                  .dictionary(Strings.errorActualizarSeguroString)));
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
          pathUrl: "/seguro/eliminar/${event.numeroPoliza.toString()}",
          type: HttpType.delete,
        );
        dynamic data = await SeguroRepository.shared.delete(
          table: 'seguro',
          where: 'numeroPoliza = ?',
          whereArgs: [event.numeroPoliza.toString()],
        );
        if (data != null) {
          emit(DeleteSuccess(
              numeroPoliza: event.numeroPoliza, index: event.index));
        } else {
          emit(EventFailure(
              message:
                  locatizations.dictionary(Strings.errorEliminarSeguroString)));
        }
      },
    );
  }
}
