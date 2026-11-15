import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spor_uygulamasi/main.dart';

void main() {
  testWidgets('Uygulama acilis (Splash) ve giris ekrani testi', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SporUygulamasiApp());

    // İlk açılışta Splash ekranının göründüğünü doğrula
    expect(find.text('SPOR TAKİP'), findsOneWidget);

    // 2.5 saniyelik Splash süresini ilerletip Giriş ekranına geçişi doğrula
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

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

  testWidgets('Tum sekmeler, Hareket Havuzu ve diyaloglar hatasiz acilir', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SporUygulamasiApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Giriş Yap'));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Haftalık Program sekmesi ve SimpleDialog
    await tester.tap(find.text('Haftalık'));
    await tester.pumpAndSettle();
    expect(find.text('Haftalık Program'), findsOneWidget);

    await tester.tap(find.text('Güne Hareket Ekle'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('İptal'));
    await tester.pumpAndSettle();
    expect(find.text('İptal'), findsOneWidget);
    await tester.tap(find.text('İptal'));
    await tester.pumpAndSettle();

    // Hareket Havuzu ekranı, Bölgeler ve HareketFormDialog
    await tester.tap(find.text('Tüm Hareketlerim'));
    await tester.pumpAndSettle();
    expect(find.text('Hareket Havuzu'), findsOneWidget);

    await tester.tap(find.text('Bölgeler'));
    await tester.pumpAndSettle();
    expect(find.text('Ekle'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Yeni Hareket Ekle'), findsOneWidget);
    await tester.tap(find.text('İptal'));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    // Ölçümler sekmesi ve Yeni Ölçüm AlertDialog
    await tester.tap(find.text('Ölçümler'));
    await tester.pumpAndSettle();
    expect(find.text('Güncel Ölçümlerim'), findsOneWidget);

    await tester.tap(find.text('Yeni Ölçüm'));
    await tester.pumpAndSettle();
    expect(find.text('Yeni Ölçüm Ekle'), findsOneWidget);
    await tester.tap(find.text('İptal'));
    await tester.pumpAndSettle();

    // Hesabım sekmesi
    await tester.tap(find.text('Hesabım').last);
    await tester.pumpAndSettle();
    expect(find.text('Şifre Değiştir'), findsOneWidget);
    expect(find.text('Çıkış Yap'), findsOneWidget);
  });
}
