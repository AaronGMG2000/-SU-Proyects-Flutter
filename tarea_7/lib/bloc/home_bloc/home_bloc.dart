import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tarea_2/provider/api_manager.dart';
import 'package:tarea_2/util/app_type.dart';
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

    on<CloseSession>((event, emit) {
      ApiManager.shared.request(
        baseUrl: "192.168.1.8:8585",
        pathUrl: "/user/getToken",
        type: HttpType.get,
      );
    });
  }
}
