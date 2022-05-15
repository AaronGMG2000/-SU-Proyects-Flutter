import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarea_2/models/login.dart';
import 'package:tarea_2/repository/login_repository.dart';
import 'package:tarea_2/util/encrypt_function.dart';
part 'basic_event.dart';
part 'basic_state.dart';

class BasicBloc extends Bloc<BasicEvent, BasicState> {
  BasicBloc() : super(AppStarted()) {
    on<ButtonPressed>((event, emit) {
      emit(PageChanged(title: 'Hola Mundo'));
    });

    on<LoginStart>((event, emit) async {
      dynamic login = await LoginRepository.shared.selectWhere(
        table: 'login',
        where: 'email = ?',
        whereArgs: [event.email],
      );
      if (login.length == 0) {
        emit(EmailFail());
        return;
      }
      dynamic data = login.first;
      if (data != null) {
        Login login = Login.fromService(data);
        if (login.password == event.password) {
          final SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          if (event.rememberMe) {
            sharedPreferences.setBool('rememberMe', true);
          }
          sharedPreferences.setString('email', await encryptText(login.email));
          sharedPreferences.setString('name', await encryptText(login.name));
          sharedPreferences.setString(
              'password', await encryptText(login.password));
          emit(
            LoginSuccess(
              email: login.email,
              username: login.username,
              name: login.name,
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
