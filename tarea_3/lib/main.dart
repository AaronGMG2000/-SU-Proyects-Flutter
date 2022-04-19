import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:tarea_2/pages/page_one/page_one.dart';
import 'package:flutter/material.dart';
import 'package:tarea_2/util/realTimeDatabase.dart';

void main() {
  runZonedGuarded(
    () => runApp(const Myapp()),
    (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack),
  );
}

class Myapp extends StatefulWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);
}

class _MyappState extends State<Myapp> {
  late Future<void> _fireBase;
  Future<void> _initializeF() async {
    await Firebase.initializeApp();
    await _initializeC();
    await _initializeRC();
    await _initializeCM();
    await _initializeRB();
  }

  Future<void> _initializeC() async {
    // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    Function onOriginError = FlutterError.onError as Function;
    FlutterError.onError = (FlutterErrorDetails details) async {
      await FirebaseCrashlytics.instance.recordFlutterError(details);
      onOriginError(details);
    };
  }

  Future<void> _initializeRC() async {
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ));
    remoteConfig.setDefaults(const {
      'Email': "rudy.gopal.2000@gmail.com",
      'Name': "Rudy Aarón Gopal Marroquín Garcia",
      'Username': "AaronMG2000",
      'Password': "Marroquin1"
    });
    await remoteConfig.fetchAndActivate();
    print("Email: " + remoteConfig.getString('Email'));
    print("Password: " + remoteConfig.getString('Password'));
  }

  Future<void> _initializeCM() async {
    FirebaseMessaging cloudMessaging = FirebaseMessaging.instance;
    String token = await cloudMessaging.getToken() ?? '';
    print('token: $token');
    FirebaseMessaging.onMessage.listen((event) {
      print(event.notification!.title);
      print(event.notification!.body);
    });
  }

  Future<void> _initializeRB() async {
    final database = FirebaseDatabase.instance.ref();
    String? macAddress = await getDeviceIdentifier();
    final mode = database.child('$macAddress/mode');
    final rememberMe = database.child('$macAddress/rememberMe');
    final email = database.child('$macAddress/email');
    await mode.get().then((value) {
      if (value.value == null) {
        mode.set(false);
        rememberMe.set(false);
        email.set("");
      } else {
        Myapp.themeNotifier.value =
            value.value as bool ? ThemeMode.dark : ThemeMode.light;
      }
    });
    database.child('$macAddress/mode').onValue.listen((event) {
      Myapp.themeNotifier.value =
          event.snapshot.value as bool ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  void initState() {
    super.initState();
    _fireBase = _initializeF();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: Myapp.themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return FutureBuilder(
          future: _fireBase,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                darkTheme: ThemeData.dark(),
                themeMode: currentMode,
                home: const PageOne(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      },
    );
  }
}
