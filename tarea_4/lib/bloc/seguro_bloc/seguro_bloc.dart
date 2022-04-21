import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'seguro_event.dart';
part 'seguro_state.dart';

class SeguroBloc extends Bloc<SeguroEvent, SeguroState> {
  SeguroBloc() : super(AppStarted()) {}
}
