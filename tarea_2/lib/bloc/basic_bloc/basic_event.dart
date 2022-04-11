part of 'basic_bloc.dart';

abstract class BasicEvent extends Equatable {}

class ButtonPressed extends BasicEvent {
  @override
  List<Object?> get props => [];
}

class LoginStart extends BasicEvent {
  final String email;
  final String password;
  LoginStart({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}
