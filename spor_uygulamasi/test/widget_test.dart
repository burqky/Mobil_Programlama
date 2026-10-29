import 'package:flutter_test/flutter_test.dart';
import 'package:spor_uygulamasi/main.dart';

void main() {
  testWidgets(
    'LoginView renders and navigates to RegisterView and ForgotPasswordView',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('Kullanıcı Adı'), findsOneWidget);
      expect(find.text('Şifre'), findsOneWidget);
      expect(find.text('Şifremi Unuttum?'), findsOneWidget);
      expect(find.text('Giriş Yap'), findsOneWidget);
      expect(find.text('Hesabınız yok mu?'), findsOneWidget);
      expect(find.text('Kayıt Oluştur'), findsOneWidget);

      // Şifremi Unuttum sayfasına geçiş
      await tester.tap(find.text('Şifremi Unuttum?'));
      await tester.pumpAndSettle();

      expect(find.text('Şifremi Unuttum'), findsOneWidget);
      expect(find.text('E-posta'), findsOneWidget);
      expect(find.text('Yeni Şifre'), findsOneWidget);
      expect(find.text('Yeni Şifre Tekrar'), findsOneWidget);
      expect(find.text('Şifreyi Güncelle'), findsOneWidget);
    },
  );
}
