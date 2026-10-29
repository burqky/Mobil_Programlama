import 'package:flutter_test/flutter_test.dart';
import 'package:spor_uygulamasi/main.dart';

void main() {
  testWidgets('Uygulama baslatma ve giris ekrani testi', (WidgetTester tester) async {
    await tester.pumpWidget(const SporUygulamasiApp());

    // Giriş ekranı başlığını ve butonunu doğrula
    expect(find.text('Hoş Geldiniz'), findsOneWidget);
    expect(find.text('Giriş Yap'), findsOneWidget);

    // Giriş Yap butonuna tıkla ve Future.delayed (500ms) süresini ilerlet
    await tester.tap(find.text('Giriş Yap'));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Ana ekranda Günün Programı sekmesinin açıldığını doğrula
    expect(find.text('Günün Programı'), findsOneWidget);
  });
}
