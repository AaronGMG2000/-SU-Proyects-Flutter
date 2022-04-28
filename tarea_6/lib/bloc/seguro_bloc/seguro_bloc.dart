import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tarea_2/models/Seguro.dart';
import 'package:tarea_2/repository/seguro_repository.dart';
part 'seguro_event.dart';
part 'seguro_state.dart';

class SeguroBloc extends Bloc<SeguroEvent, SeguroState> {
  SeguroBloc() : super(AppStarted()) {
    on<CreateEvent>(
      (event, emit) async {
        emit(ProccessLoad());
        await Future.delayed(const Duration(milliseconds: 1500));
        dynamic data = await SeguroRepository.shared
            .save(data: [event.seguro], table: 'seguro');
        if (data != null) {
          emit(CreateSuccess(seguro: event.seguro));
        } else {
          emit(EventFailure(message: "Error al crear el seguro"));
        }
      },
    );
    on<UpdateEvent>(
      (event, emit) async {
        emit(ProccessLoad());
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
          emit(EventFailure(message: "Error al actualizar el seguro"));
        }
      },
    );

    on<DeleteEvent>(
      (event, emit) async {
        dynamic data = await SeguroRepository.shared.delete(
          table: 'seguro',
          where: 'numeroPoliza = ?',
          whereArgs: [event.numeroPoliza.toString()],
        );
        if (data != null) {
          emit(DeleteSuccess(
              numeroPoliza: event.numeroPoliza, index: event.index));
        } else {
          emit(EventFailure(message: "Error al eliminar el seguro"));
        }
      },
    );
  }
}
