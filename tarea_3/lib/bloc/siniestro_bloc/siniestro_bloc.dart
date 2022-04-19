import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'siniestro_event.dart';
part 'siniestro_state.dart';

class SiniestroBloc extends Bloc<SiniestroEvent, SiniestroState> {
  SiniestroBloc() : super(AppStarted()) {}
}
