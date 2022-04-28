part of 'seguro_bloc.dart';

abstract class SeguroState {}

class AppStarted extends SeguroState {}

class CreateSuccess extends SeguroState {
  final Seguro seguro;
  CreateSuccess({
    required this.seguro,
  });
}

class UpdateSuccess extends SeguroState {
  final Seguro seguro;
  UpdateSuccess({
    required this.seguro,
  });
}

class DeleteSuccess extends SeguroState {
  final int numeroPoliza;
  final int index;
  DeleteSuccess({
    required this.numeroPoliza,
    required this.index,
  });
}

class EventFailure extends SeguroState {
  final String message;
  EventFailure({
    required this.message,
  });
}

class ProccessLoad extends SeguroState {}
