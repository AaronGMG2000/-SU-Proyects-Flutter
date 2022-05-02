part of 'cliente_bloc.dart';

abstract class ClienteState {}

class AppStarted extends ClienteState {}

class CreateSuccess extends ClienteState {
  final Cliente client;
  CreateSuccess({
    required this.client,
  });
}

class UpdateSuccess extends ClienteState {
  final Cliente client;
  UpdateSuccess({
    required this.client,
  });
}

class DeleteSuccess extends ClienteState {
  final int dni;
  final int index;
  DeleteSuccess({
    required this.dni,
    required this.index,
  });
}

class ClientFailure extends ClienteState {
  final String message;
  ClientFailure({
    required this.message,
  });
}

class ProccessLoad extends ClienteState {}
