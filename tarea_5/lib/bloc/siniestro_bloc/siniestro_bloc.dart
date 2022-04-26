import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tarea_2/models/siniestro.dart';
import 'package:tarea_2/repository/siniestro_repository.dart';
part 'siniestro_event.dart';
part 'siniestro_state.dart';

class SiniestroBloc extends Bloc<SiniestroEvent, SiniestroState> {
  SiniestroBloc() : super(AppStarted()) {
    on<CreateEvent>(
      (event, emit) async {
        emit(ProccessLoad());
        await Future.delayed(const Duration(milliseconds: 1500));
        dynamic data = await SiniestroRepository.shared
            .save(data: [event.siniestro], table: 'siniestro');
        if (data != null) {
          emit(CreateSuccess(siniestro: event.siniestro));
        } else {
          emit(EventFailure(message: "Error al crear el siniestro"));
        }
      },
    );
    on<UpdateEvent>(
      (event, emit) async {
        emit(ProccessLoad());
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
      },
    );

    on<DeleteEvent>(
      (event, emit) async {
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
