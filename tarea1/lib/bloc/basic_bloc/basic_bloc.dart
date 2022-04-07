import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'basic_event.dart';
part 'basic_state.dart';

class BasicBloc extends Bloc<BasicEvent, BasicState> {
  BasicBloc() : super(AppStarted()) {
    on<ButtonPressed>((event, emit) {
      emit(PageChanged(title: 'Hola Mundo'));
    });

    on<LoginStart>((event, emit) {
      if (event.email == "rudy.gopal.2000@gmail.com") {
        if (event.password == "Marroquin1") {
          emit(LoginSuccess(
            email: event.email,
            username: "AaronMG2000",
            name: "Rudy Aarón Gopal Marroquín Garcia",
          ));
        } else {
          emit(PasswordFail());
        }
      } else {
        emit(EmailFail());
      }
    });
  }
}
