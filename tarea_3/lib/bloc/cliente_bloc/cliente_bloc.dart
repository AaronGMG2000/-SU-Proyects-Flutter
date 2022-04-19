import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tarea_2/models/cliente.dart';
part 'cliente_event.dart';
part 'cliente_state.dart';

class ClienteBloc extends Bloc<ClienteEvent, ClienteState> {
  ClienteBloc() : super(AppStarted()) {
    on<CreateClient>((event, emit) {
      print(event.cliente.toMap());
      emit(CreateSuccess(client: event.cliente));
    });
  }
}
