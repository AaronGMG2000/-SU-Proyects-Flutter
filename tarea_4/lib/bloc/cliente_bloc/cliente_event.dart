part of 'cliente_bloc.dart';

abstract class ClienteEvent extends Equatable {}

class CreateClient extends ClienteEvent {
  final Cliente cliente;
  CreateClient({
    required this.cliente,
  });
  @override
  List<Object?> get props => [Cliente];
}
