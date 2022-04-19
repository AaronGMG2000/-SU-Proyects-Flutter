import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(AppStarted()) {
    on<SelectPage>((event, emit) {
      switch (event.page) {
        case 'cliente':
          emit(ClienteState());
          break;
        case 'seguro':
          emit(SeguroState());
          break;
        case 'siniestro':
          emit(SiniestroState());
          break;
      }
    });
  }
}
