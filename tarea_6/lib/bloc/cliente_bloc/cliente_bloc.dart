import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tarea_2/models/cliente.dart';
import 'package:tarea_2/repository/cliente_repository.dart';
part 'cliente_event.dart';
part 'cliente_state.dart';

class ClienteBloc extends Bloc<ClienteEvent, ClienteState> {
  ClienteBloc() : super(AppStarted()) {
    on<CreateClient>(
      (event, emit) async {
        emit(ProccessLoad());
        await Future.delayed(const Duration(milliseconds: 1500));
        dynamic data = await ClienteRepository.shared
            .save(data: [event.cliente], table: 'cliente');
        if (data != null) {
          event.cliente.dniCl = data.first;
          emit(CreateSuccess(client: event.cliente));
        } else {
          emit(ClientFailure(message: "Error al crear el cliente"));
        }
      },
    );
    on<UpdateClient>(
      (event, emit) async {
        emit(ProccessLoad());
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
      },
    );

    on<DeleteClient>(
      (event, emit) async {
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
