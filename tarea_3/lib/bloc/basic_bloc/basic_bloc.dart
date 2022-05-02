import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarea_2/models/login.dart';
import 'package:tarea_2/provider/api_manager.dart';
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
      dynamic data = await ApiManager.shared.request(
        baseUrl: "192.168.1.5:8585",
        pathUrl: "/user/login",
        type: HttpType.post,
        bodyParams: {
          'email': event.email,
        },
      );
      if (data != null) {
        Login login = Login.fromService(data);
        if (login.password == event.password) {
          // final SharedPreferences sharedPreferences =
          //     await SharedPreferences.getInstance();
          // sharedPreferences.setString('email', login.email);
          if (event.rememberMe) {
            setMode(true, 'rememberMe');
          }
          setMode(login.email, 'email');
          setMode(login.name, 'name');
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
