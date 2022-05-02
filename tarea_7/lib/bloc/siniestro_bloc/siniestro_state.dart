part of 'siniestro_bloc.dart';

abstract class SiniestroState {}

class AppStarted extends SiniestroState {}

class CreateSuccess extends SiniestroState {
  final Siniestro siniestro;
  CreateSuccess({
    required this.siniestro,
  });
}

class UpdateSuccess extends SiniestroState {
  final Siniestro siniestro;
  UpdateSuccess({
    required this.siniestro,
  });
}

class DeleteSuccess extends SiniestroState {
  final int idSiniestro;
  final int index;
  DeleteSuccess({
    required this.idSiniestro,
    required this.index,
  });
}

class EventFailure extends SiniestroState {
  final String message;
  EventFailure({
    required this.message,
  });
}

class ProccessLoad extends SiniestroState {}
