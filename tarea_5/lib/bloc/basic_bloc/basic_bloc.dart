import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarea_2/models/login.dart';
import 'package:tarea_2/provider/api_manager.dart';
import 'package:tarea_2/repository/login_repository.dart';
import 'package:tarea_2/util/app_type.dart';
import 'package:tarea_2/util/realTimeDatabase.dart';
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
          if (event.rememberMe) {
            setMode(true, 'rememberMe');
          }
          setMode(login.email, 'email');
          setMode(login.name, 'name');
          final SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString('email', login.email);
          sharedPreferences.setString('name', login.name);
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
