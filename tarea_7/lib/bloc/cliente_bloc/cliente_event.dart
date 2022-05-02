part of 'cliente_bloc.dart';

abstract class ClienteEvent extends Equatable {}

class CreateClient extends ClienteEvent {
  final Cliente cliente;
  CreateClient({
    required this.cliente,
  });
  @override
  List<Object?> get props => [cliente];
}

class UpdateClient extends ClienteEvent {
  final Cliente cliente;
  UpdateClient({
    required this.cliente,
  });
  @override
  List<Object?> get props => [cliente];
}

class DeleteClient extends ClienteEvent {
  final int dni;
  final int index;
  DeleteClient({
    required this.dni,
    required this.index,
  });
  @override
  List<Object?> get props => [dni];
}
