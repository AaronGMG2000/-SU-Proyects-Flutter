import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tarea_2/models/cliente.dart';
import 'package:tarea_2/provider/api_manager.dart';
import 'package:tarea_2/repository/cliente_repository.dart';
import 'package:tarea_2/util/app_type.dart';
part 'cliente_event.dart';
part 'cliente_state.dart';

class ClienteBloc extends Bloc<ClienteEvent, ClienteState> {
  ClienteBloc() : super(AppStarted()) {
    on<CreateClient>(
      (event, emit) async {
        emit(ProccessLoad());
        dynamic dataSave = await ApiManager.shared.request(
            baseUrl: "192.168.1.8:8585",
            pathUrl: "/cliente/guardar",
            type: HttpType.post,
            bodyParams: {
              'nombreCl': event.cliente.nombreCl,
              'apellido1': event.cliente.apellido1,
              'apellido2': event.cliente.apellido2,
              'telefono': event.cliente.telefono,
              'ciudad': event.cliente.ciudad,
              'claseVia': event.cliente.claseVia,
              'numeroVia': event.cliente.numeroVia,
              'codPostal': event.cliente.codPostal,
              'nombreVia': event.cliente.nombreVia,
              'observaciones': event.cliente.observaciones,
            });
        if (dataSave != null) {
          Cliente clientN = Cliente.fromService(dataSave);
          await Future.delayed(const Duration(milliseconds: 1500));
          dynamic data = await ClienteRepository.shared
              .save(data: [clientN], table: 'cliente');
          if (data != null) {
            emit(CreateSuccess(client: clientN));
          } else {
            emit(ClientFailure(message: "Error al crear el cliente"));
          }
        } else {
          emit(ClientFailure(message: "Error al crear el cliente"));
        }
      },
    );
    on<UpdateClient>(
      (event, emit) async {
        emit(ProccessLoad());
        dynamic dataSave = await ApiManager.shared.request(
            baseUrl: "192.168.1.8:8585",
            pathUrl: "/cliente/actualizar",
            type: HttpType.put,
            bodyParams: {
              'dniCl': event.cliente.dniCl,
              'nombreCl': event.cliente.nombreCl,
              'apellido1': event.cliente.apellido1,
              'apellido2': event.cliente.apellido2,
              'telefono': event.cliente.telefono,
              'ciudad': event.cliente.ciudad,
              'claseVia': event.cliente.claseVia,
              'numeroVia': event.cliente.numeroVia,
              'codPostal': event.cliente.codPostal,
              'nombreVia': event.cliente.nombreVia,
              'observaciones': event.cliente.observaciones,
            });
        if (dataSave != null) {
          await Future.delayed(const Duration(milliseconds: 1500));
          dynamic data = await ClienteRepository.shared.update(
            data: event.cliente,
            table: 'cliente',
            where: 'dniCl = ?',
            whereArgs: [event.cliente.dniCl.toString()],
          );
          if (data != null) {
            emit(UpdateSuccess(client: event.cliente));
          } else {
            emit(ClientFailure(message: "Error al actualizar el cliente"));
          }
        } else {
          emit(ClientFailure(message: "Error al actualizar el cliente"));
        }
      },
    );

    on<DeleteClient>(
      (event, emit) async {
        await ApiManager.shared.request(
          baseUrl: "192.168.1.8:8585",
          pathUrl: "/cliente/eliminar/${event.dni.toString()}",
          type: HttpType.delete,
        );
        dynamic data = await ClienteRepository.shared.delete(
          table: 'cliente',
          where: 'dniCl = ?',
          whereArgs: [event.dni.toString()],
        );
        if (data != null) {
          emit(DeleteSuccess(dni: event.dni, index: event.index));
        } else {
          emit(ClientFailure(message: "Error al eliminar el cliente"));
        }
      },
    );
  }
}
