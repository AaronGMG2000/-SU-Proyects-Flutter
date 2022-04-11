import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
part 'basic_event.dart';
part 'basic_state.dart';

class BasicBloc extends Bloc<BasicEvent, BasicState> {
  BasicBloc() : super(AppStarted()) {
    on<ButtonPressed>((event, emit) {
      emit(PageChanged(title: 'Hola Mundo'));
    });

    on<LoginStart>((event, emit) {
      if (event.email == FirebaseRemoteConfig.instance.getString('Email')) {
        if (event.password ==
            FirebaseRemoteConfig.instance.getString('Password')) {
          emit(
            LoginSuccess(
              email: event.email,
              username: FirebaseRemoteConfig.instance.getString('Username'),
              name: FirebaseRemoteConfig.instance.getString('Name'),
            ),
          );
        } else {
          emit(PasswordFail());
        }
      } else {
        emit(EmailFail());
      }
    });
  }
}
