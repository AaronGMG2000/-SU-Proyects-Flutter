import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tarea_2/bloc/basic_bloc/basic_bloc.dart';
import 'package:tarea_2/bloc/home_bloc/home_bloc.dart';
import 'package:tarea_2/provider/api_manager.dart';
import 'package:tarea_2/repository/app_preferences.dart';
import 'package:tarea_2/util/app_type.dart';
import 'package:tarea_2/util/encrypt_function.dart';
import 'package:tarea_2/util/geolocation.dart' as geo;
import 'package:tarea_2/util/validations.dart';

void main() {
  group('encrypt decrypt', () {
    test('encrypt', () async {
      final String encrypt = await encryptText("texto");
      expect(encrypt, "QkUQAzFWwMagJsv6joY/Tg==");
    });

    test('decrypt', () async {
      final String deencrypt = await deencryptText("QkUQAzFWwMagJsv6joY/Tg==");
      expect(deencrypt, "texto");
    });
  });

  group("gelocations", () {
    test("getDeviceIdentifier", () async {
      Map<String, dynamic> deviceInfo = await geo.getDeviceIdentifier();
      expect(deviceInfo, isNotNull);
    });

    test("getLocation", () async {
      Map<String, dynamic> location =
          await geo.getGeolocation('', {}, {}, HttpType.get, 202);
      expect(location, isNotNull);
    });
  });

  group("AppReference", () {
    test("setPreference", () async {
      await AppPreferences.shared.setPreference("preference", "value");
      expect(await AppPreferences.shared.getStringPreference("preference"),
          "value");
    });
    test("getStringPreference", () async {
      final String? value =
          await AppPreferences.shared.getStringPreference("preference");
      expect(value, "value");
      await AppPreferences.shared.setPreference("preference", "");
    });
  });

  group("Validations", () {
    test("isValidPhon", () {
      expect(Validator("123456789").isValidPhon, true);
      expect(Validator("12345678901").isValidPhon, false);
      expect(Validator("1234567890123").isValidPhon, false);
    });

    test("isValidPostalCod", () {
      expect(Validator("12345").isValidPostalCod, true);
      expect(Validator("12345678a9").isValidPostalCod, false);
    });

    test("isNumber", () {
      expect(Validator("123456789").isNumber, true);
      expect(Validator("1234567a8901").isNumber, false);
    });
  });

  group("ApiManager test", () {
    test("get", () async {
      final dynamic response = await ApiManager.shared.request(
        baseUrl: "api.tvmaze.com",
        pathUrl: "/search/shows",
        uriParams: {
          "q": "rick and morty",
        },
        type: HttpType.get,
      );
      expect(response, isNotNull);
    });
  });

  group("Bloc", () {
    blocTest(
      'emits [] when nothing is added',
      build: () => BasicBloc(),
      expect: () => [],
    );

    blocTest(
      'emits [ChangePage]',
      build: () => BasicBloc(),
      act: (bloc) {
        if (bloc is BasicBloc) {
          bloc.add(ButtonPressed());
        }
      },
      expect: () => [isA<PageChanged>()],
    );

    blocTest(
      'emits [SeguroState]',
      build: () => HomeBloc(),
      act: (bloc) {
        if (bloc is HomeBloc) {
          bloc.add(SelectPage(page: "seguro"));
        }
      },
      expect: () => [isA<SeguroState>()],
    );

    blocTest(
      'emits [SiniestroState]',
      build: () => HomeBloc(),
      act: (bloc) {
        if (bloc is HomeBloc) {
          bloc.add(SelectPage(page: "siniestro"));
        }
      },
      expect: () => [isA<SiniestroState>()],
    );

    blocTest(
      'emits [ClienteState]',
      build: () => HomeBloc(),
      act: (bloc) {
        if (bloc is HomeBloc) {
          bloc.add(SelectPage(page: "cliente"));
        }
      },
      expect: () => [isA<ClienteState>()],
    );
  });
}
