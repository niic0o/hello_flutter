// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:hello_flutter/main.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:hello_flutter/app_locale.dart';

void main() {
  testWidgets('Smoke test: app builds and shows Home label', (WidgetTester tester) async {
    // Inicializa bindings para test
    TestWidgetsFlutterBinding.ensureInitialized();

    // Configura la localización como en main.dart
    final FlutterLocalization testLocalization = FlutterLocalization.instance;

    await testLocalization.ensureInitialized();
    testLocalization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.en),
        const MapLocale('es', AppLocale.es),
      ],
      initLanguageCode: 'es',
    );

    // Monta la app
    await tester.pumpWidget(MyApp(localization: testLocalization));

    // Verifica que se muestre el texto 'Home' (por defecto está en inglés)
    expect(find.text('Home'), findsOneWidget);

    // Podés cambiar el idioma y volver a verificar si querés
    testLocalization.translate('es');
    await tester.pumpAndSettle(); // Esperá a que la UI se actualice

    expect(find.text('Inicio'), findsOneWidget);
  });
}
