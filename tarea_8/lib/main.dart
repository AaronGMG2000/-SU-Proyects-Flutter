import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarea_2/localizations/localizations.dart';
import 'package:tarea_2/models/login.dart';
import 'package:tarea_2/pages/page_one/page_one.dart';
import 'package:flutter/material.dart';
import 'package:tarea_2/pages/page_profile/page_profile.dart';
import 'package:tarea_2/provider/language_provider.dart';
import 'package:tarea_2/repository/app_preferences.dart';
import 'package:tarea_2/repository/login_repository.dart';
import 'package:tarea_2/util/app_string.dart';
import 'package:tarea_2/util/encrypt_function.dart';
import 'package:tarea_2/util/realTimeDatabase.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
  static late ValueNotifier<bool> isLogin = ValueNotifier(false);
  static late ValueNotifier<bool> connected = ValueNotifier(false);
  static late bool autenticado = false;
}

class _MyappState extends State<Myapp> {
  final LocalAuthentication auth = LocalAuthentication();
  late Future<void> _fireBase;
  Future<void> _initializeF() async {
    await Firebase.initializeApp();
    await _initializeC();
    await _initializeRC();
    await _initializeCM();
    await _initializeRB();
    await getCurrentAppLanguage();
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
        mode.set("sistema");
        rememberMe.set(false);
        email.set("");
      } else {
        String modo = value.value as String;
        Myapp.themeNotifier.value = modo == "sistema" || modo == "system"
            ? ThemeMode.system
            : modo == "tema claro" || modo == "light"
                ? ThemeMode.light
                : ThemeMode.dark;
      }
    });
    database.child('$macAddress/mode').onValue.listen((event) {
      String modo = event.snapshot.value as String;
      Myapp.themeNotifier.value = modo == "sistema" || modo == "system"
          ? ThemeMode.system
          : modo == "tema claro" || modo == "light"
              ? ThemeMode.light
              : ThemeMode.dark;
    });
  }

  Future<void> _biometrico() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    bool remember = sharedPreferences.getBool('rememberMe') ?? false;
    if (remember) {
      Myapp.autenticado = true;
    }
    if (Myapp.autenticado && !Myapp.isLogin.value) {
      String? location =
          await AppPreferences.shared.getStringPreference('defaultLanguage');
      final locatizations = AppLocalizations(Locale(location ?? 'es', ''));
      bool authenticated = false;
      final androidString = AndroidAuthMessages(
        signInTitle: locatizations.dictionary(Strings.signInTitleString),
        cancelButton: locatizations.dictionary(Strings.cancelButtonString),
        goToSettingsButton:
            locatizations.dictionary(Strings.goToSettingsButtonString),
        biometricHint: locatizations.dictionary(Strings.biometricHintString),
        biometricNotRecognized:
            locatizations.dictionary(Strings.biometricNotRecognizedString),
        biometricSuccess:
            locatizations.dictionary(Strings.biometricSuccessString),
        goToSettingsDescription:
            locatizations.dictionary(Strings.goToSettingsDescriptionString),
      );
      try {
        authenticated = await auth.authenticate(
          localizedReason:
              locatizations.dictionary(Strings.localizedReasonString),
          authMessages: [androidString],
          options: const AuthenticationOptions(
            useErrorDialogs: false,
            stickyAuth: false,
            biometricOnly: true,
          ),
        );
        if (authenticated) {
          final SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          bool isLogin = sharedPreferences.getBool('rememberMe') ?? false;
          if (isLogin && Myapp.autenticado) {
            String email =
                await deencryptText(sharedPreferences.getString('email')!);
            dynamic data = await LoginRepository.shared.selectWhere(
                table: 'login', where: 'email = ?', whereArgs: [email]);
            if (data.first != null) {
              Login loginU = Login.fromService(data.first);
              String password =
                  await deencryptText(sharedPreferences.getString('password')!);
              if (loginU.password == password) {
                Myapp.isLogin.value = true;
              }
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error de Autenticación")),
          );
        }
      } on PlatformException catch (e) {
        if (e.code.toString() == 'LockedOut') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(locatizations.dictionary(Strings.lockedOutString))),
          );
        }
        if (e.code.toString() == 'NotAvailable') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(locatizations.dictionary(Strings.notAvailableString))),
          );
        }
        if (e.code.toString() == 'NotEnrolled') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(locatizations.dictionary(Strings.notEnrolledString))),
          );
        }
        if (e.code.toString() == 'OtherOperatingSystem') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(locatizations
                    .dictionary(Strings.otherOperatingSystemString))),
          );
        }
        if (e.code.toString() == 'PasscodeNotSet') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    locatizations.dictionary(Strings.passcodeNotSetString))),
          );
        }
        if (e.code.toString() == 'PermanentlyLockedOut') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(locatizations
                    .dictionary(Strings.permanentlyLockedOutString))),
          );
        }
      } catch (e) {
        print(e);
      }
      if (!mounted) {
        return;
      }
    }
  }

  Future<void> getCurrentAppLanguage() async {
    LanguageProvider().setLanguage =
        await LanguageProvider().getDefaultLanguage();
  }

  @override
  void initState() {
    super.initState();
    _fireBase = _initializeF();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    late Login user = Login();
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: Myapp.themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return FutureBuilder(
          future: _fireBase,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (_) => LanguageProvider()),
                ],
                child: Consumer(
                  builder:
                      (context, LanguageProvider languageProvider, widget) {
                    return MaterialApp(
                      locale: languageProvider.getLang,
                      localizationsDelegates: const [
                        AppLocalizationsDelegate(),
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      supportedLocales: const [
                        Locale('en', ''),
                        Locale('es', ''),
                      ],
                      title: 'Flutter Demo',
                      theme: ThemeData(
                        primarySwatch: Colors.blue,
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                      ),
                      darkTheme: ThemeData.dark(),
                      themeMode: currentMode,
                      // home: const PageOne(),
                      home: ValueListenableBuilder<bool>(
                        valueListenable: Myapp.isLogin,
                        builder: (_, bool login, __) {
                          return OfflineBuilder(
                            connectivityBuilder: (
                              BuildContext context,
                              ConnectivityResult connectivity,
                              Widget child,
                            ) {
                              bool isConnected =
                                  connectivity != ConnectivityResult.none;
                              Future.delayed(Duration.zero, () async {
                                Myapp.connected.value =
                                    connectivity != ConnectivityResult.none;
                              });
                              Future.delayed(const Duration(microseconds: 500),
                                  () async {
                                if (!Myapp.isLogin.value) {
                                  _biometrico();
                                }
                              });
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  child,
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    height: 50,
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      color: isConnected
                                          ? Colors.transparent
                                          : Colors.red,
                                      child: isConnected
                                          ? null
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Text(
                                                  "OFFLINE",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                SizedBox(
                                                  width: 12,
                                                  height: 12,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                      Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            child: login
                                ? PageProfile(email: user.email)
                                : PageOne(login: user),
                          );
                        },
                      ),
                    );
                  },
                ),
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
