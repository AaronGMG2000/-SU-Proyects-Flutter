part of 'siniestro_bloc.dart';

abstract class SiniestroEvent extends Equatable {}

class CreateEvent extends SiniestroEvent {
  final Siniestro siniestro;
  CreateEvent({
    required this.siniestro,
  });
  @override
  List<Object?> get props => [siniestro];
}

class UpdateEvent extends SiniestroEvent {
  final Siniestro siniestro;
  UpdateEvent({
    required this.siniestro,
  });
  @override
  List<Object?> get props => [siniestro];
}

class DeleteEvent extends SiniestroEvent {
  final int idSiniestro;
  final int index;
  DeleteEvent({
    required this.idSiniestro,
    required this.index,
  });
  @override
  List<Object?> get props => [idSiniestro];
}
