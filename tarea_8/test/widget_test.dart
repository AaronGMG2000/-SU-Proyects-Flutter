import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tarea_2/localizations/localizations.dart';
import 'package:tarea_2/models/Seguro.dart';
import 'package:tarea_2/models/cliente.dart';
import 'package:tarea_2/models/login.dart';
import 'package:tarea_2/models/siniestro.dart';
import 'package:tarea_2/pages/page_profile/page_profile.dart';
import 'package:tarea_2/pages/page_register_client/page_register_client.dart';
import 'package:tarea_2/pages/page_register_seguro/page_register_seguro.dart';
import 'package:tarea_2/pages/page_register_siniestro/page_register_siniestro.dart';
import 'package:tarea_2/pages/page_two/page_two.dart';
import 'package:tarea_2/provider/language_provider.dart';
import 'package:tarea_2/widgets/button_model1.dart';
import 'package:tarea_2/widgets/button_model2.dart';
import 'package:tarea_2/widgets/form_client_validation.dart';
import 'package:tarea_2/widgets/form_seguro_validation.dart';
import 'package:tarea_2/widgets/form_siniestro_validation.dart';
import 'package:tarea_2/widgets/form_validation.dart';
import 'package:tarea_2/widgets/navigation_drawer_widget.dart';
import 'package:tarea_2/widgets/text_input.dart';
import 'package:tarea_2/widgets/text_input_date.dart';

main() {
  Future<void> update(dynamic seguro2) async {}
  group('Home', () {
    testWidgets(
      "Button design 1",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale("es", "ES"),
            home: Scaffold(
              body: ButtonModel1(
                  text: "Botton",
                  onPressed: () {},
                  lightColor: Colors.red,
                  darkColor: Colors.blue),
            ),
          ),
        );
        await tester.pump();
        expect(find.byType(ButtonModel1), findsOneWidget);
        expect(find.text("Botton"), findsOneWidget);
        expect(find.byIcon(Icons.abc_outlined), findsNothing);
      },
    );
//
    testWidgets(
      "Perfil",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            locale: Locale("es", "ES"),
            home: Scaffold(
              body: PageProfile(
                email: "rudy.gopal.2000@gmail.com",
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.byType(PageProfile), findsOneWidget);
      },
    );

    testWidgets(
      "Navigator",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            locale: Locale("es", "ES"),
            home: Scaffold(
              body: NavigationDrawerWidget(),
            ),
          ),
        );
        await tester.pump();
        expect(find.byType(NavigationDrawerWidget), findsOneWidget);
      },
    );

    testWidgets(
      "PageTwo",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            locale: Locale("es", "ES"),
            home: Scaffold(
              body: PageTwo(title: "Page Two"),
            ),
          ),
        );
        await tester.pump();
        expect(find.byType(PageTwo), findsOneWidget);
        expect(find.text("Page Two"), findsOneWidget);
      },
    );

    testWidgets(
      "Button model 2",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale("es", "ES"),
            home: Scaffold(
                body: ButtonModel2(
                    text: "Prueba 2",
                    onPressed: () {},
                    lightColor: Colors.red,
                    darkColor: Colors.black,
                    iconButton: Icons.abc_outlined)),
          ),
        );
        await tester.pump();
        expect(find.byType(ButtonModel2), findsOneWidget);
        expect(find.text("Prueba 2"), findsOneWidget);
        expect(find.byIcon(Icons.abc_outlined), findsOneWidget);
      },
    );
  });

  testWidgets(
    "checkbox",
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale("es", "ES"),
          home: Scaffold(
            body: Checkbox(value: false, onChanged: (value) {}),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(Checkbox), findsOneWidget);
    },
  );

  testWidgets(
    "Page register cliente",
    (WidgetTester tester) async {
      final _formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale("es", "ES"),
          home: Scaffold(
            body: PageRegisterClient(
                cliente: Cliente(),
                formKey: _formKey,
                onSubmit: update,
                titulo: "titulo",
                update: false),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(PageRegisterClient), findsOneWidget);
      expect(find.text("titulo"), findsOneWidget);
    },
  );

  testWidgets(
    "Page register seguro",
    (WidgetTester tester) async {
      final _formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale("es", "ES"),
          home: Scaffold(
            body: PageRegisterSeguro(
                seguro: Seguro(),
                formKey: _formKey,
                onSubmit: update,
                titulo: "titulo",
                update: false),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(PageRegisterSeguro), findsOneWidget);
      expect(find.text("titulo"), findsOneWidget);
    },
  );

  testWidgets(
    "Page register siniestro",
    (WidgetTester tester) async {
      final _formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale("es", "ES"),
          home: Scaffold(
            body: PageRegisterSiniestro(
                siniestro: Siniestro(),
                formKey: _formKey,
                onSubmit: update,
                titulo: "titulo",
                update: false),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(PageRegisterSiniestro), findsOneWidget);
      expect(find.text("titulo"), findsOneWidget);
    },
  );

  testWidgets(
    "form_client_validation",
    (WidgetTester tester) async {
      final _formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale("es", "ES"),
          home: Scaffold(
            body: ListView(
              padding: const EdgeInsets.only(
                top: 0,
              ),
              scrollDirection: Axis.vertical,
              children: [
                Column(
                  children: [
                    FormClientValidation(
                      formKey: _formKey,
                      onSubmit: update,
                      cliente: Cliente(),
                      update: false,
                      showSpinner: (bool value) {},
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(FormClientValidation), findsOneWidget);
    },
  );

  testWidgets(
    "form_siniestro_validation",
    (WidgetTester tester) async {
      final _formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale("es", "ES"),
          home: Scaffold(
            body: ListView(
              padding: const EdgeInsets.only(
                top: 0,
              ),
              scrollDirection: Axis.vertical,
              children: [
                Column(
                  children: [
                    FormSiniestroValidation(
                      formKey: _formKey,
                      onSubmit: update,
                      siniestro: Siniestro(),
                      update: false,
                      showSpinner: (bool value) {},
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(FormSiniestroValidation), findsOneWidget);
    },
  );

  testWidgets(
    "form_seguro_validation",
    (WidgetTester tester) async {
      final _formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale("es", "ES"),
          home: Scaffold(
            body: ListView(
              padding: const EdgeInsets.only(
                top: 0,
              ),
              scrollDirection: Axis.vertical,
              children: [
                Column(
                  children: [
                    FormSeguroValidation(
                      formKey: _formKey,
                      onSubmit: update,
                      seguro: Seguro(),
                      update: false,
                      showSpinner: (bool value) {},
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(FormSeguroValidation), findsOneWidget);
    },
  );

  // testWidgets(
  //   "form_validation",
  //   (WidgetTester tester) async {
  //     LanguageProvider().setLanguage =
  //         await LanguageProvider().getDefaultLanguage();
  //     final _formKey = GlobalKey<FormState>();
  //     await tester.pumpWidget(
  //       MultiProvider(
  //         providers: [
  //           ChangeNotifierProvider(create: (_) => LanguageProvider()),
  //         ],
  //         child: Consumer(
  //           builder: (context, LanguageProvider languageProvider, widget) {
  //             return MaterialApp(
  //               locale: languageProvider.getLang,
  //               localizationsDelegates: const [
  //                 AppLocalizationsDelegate(),
  //                 GlobalMaterialLocalizations.delegate,
  //                 GlobalWidgetsLocalizations.delegate,
  //                 GlobalCupertinoLocalizations.delegate,
  //               ],
  //               home: Scaffold(
  //                 body: FormValidation(
  //                   formKey: _formKey,
  //                   login: Login(),
  //                   onSubmit: () {
  //                     _formKey.currentState!.validate();
  //                   },
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     );
  //     await tester.pump();
  //     expect(find.byType(FormValidation), findsOneWidget);
  //     expect(find.byType(ButtonModel1), findsOneWidget);
  //     await tester.tap(find.byType(ButtonModel1));
  //     await tester.pump();
  //     expect(find.text("Please enter an email"), findsOneWidget);
  //   },
  // );

  testWidgets(
    "text_input_date",
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale("es", "ES"),
          home: Scaffold(
            body: TextInputDate(
              initialValue: DateTime.now().toIso8601String(),
              hinText: "hinText",
              controller: TextEditingController(),
              validator: (value) {
                return "";
              },
              onSaved: (value) {},
              iconData: Icons.abc_outlined,
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(TextInputDate), findsOneWidget);
      expect(find.byIcon(Icons.abc_outlined), findsOneWidget);
    },
  );

  testWidgets(
    "text_input",
    (WidgetTester tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale("es", "ES"),
          home: Scaffold(
            body: TextInputT(
                initialValue: "Valor",
                hinText: "hinText",
                controller: controller,
                validator: (value) {
                  return "";
                },
                onSaved: (value) {},
                iconData: Icons.abc_outlined,
                onEditingComplete: () {
                  TextInput.finishAutofillContext();
                }),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(TextInputT), findsOneWidget);
      expect(find.byIcon(Icons.abc_outlined), findsOneWidget);
      expect(find.text("Valor"), findsOneWidget);
    },
  );
}
