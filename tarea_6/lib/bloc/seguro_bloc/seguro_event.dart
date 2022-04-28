part of 'seguro_bloc.dart';

abstract class SeguroEvent extends Equatable {}

class CreateEvent extends SeguroEvent {
  final Seguro seguro;
  CreateEvent({
    required this.seguro,
  });
  @override
  List<Object?> get props => [seguro];
}

class UpdateEvent extends SeguroEvent {
  final Seguro seguro;
  UpdateEvent({
    required this.seguro,
  });
  @override
  List<Object?> get props => [seguro];
}

class DeleteEvent extends SeguroEvent {
  final int numeroPoliza;
  final int index;
  DeleteEvent({
    required this.numeroPoliza,
    required this.index,
  });
  @override
  List<Object?> get props => [numeroPoliza];
}
