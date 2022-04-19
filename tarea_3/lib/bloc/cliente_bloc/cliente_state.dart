part of 'cliente_bloc.dart';

abstract class ClienteState {}

class AppStarted extends ClienteState {}

class CreateSuccess extends ClienteState {
  final Cliente client;
  CreateSuccess({
    required this.client,
  });
}

class CreateFailure extends ClienteState {
  final String error;
  CreateFailure({
    required this.error,
  });
}
