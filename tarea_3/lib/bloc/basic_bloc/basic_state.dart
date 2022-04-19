part of 'basic_bloc.dart';

abstract class BasicState {}

class AppStarted extends BasicState {}

class PageChanged extends BasicState {
  final String title;
  PageChanged({required this.title});
}

class LoginSuccess extends BasicState {
  final String email;
  final String username;
  final String name;
  LoginSuccess({
    required this.email,
    required this.username,
    required this.name,
  });
}

class EmailFail extends BasicState {}

class PasswordFail extends BasicState {}
