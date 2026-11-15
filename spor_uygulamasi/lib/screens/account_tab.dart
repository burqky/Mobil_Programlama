import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class AccountTab extends StatefulWidget {
  final String userName;
  final String userEmail;

  const AccountTab({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  // Kullanıcı profil detaylarının (e-posta, üniversite/bölüm) tıklayınca açılıp kapanması
  bool _showProfileDetails = false;

  void _showChangePasswordDialog() {
    final currentPassController = TextEditingController();
    final newPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        Widget iptalButonu = TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('İptal'),
        );

        Widget guncelleButonu = ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            if (newPassController.text.trim().length < 4) {
              final hataSnackBar = SnackBar(
                duration: const Duration(seconds: 3),
                content: const Text('Yeni şifre en az 4 karakter olmalıdır.'),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  textColor: Colors.white,
                  label: 'TAMAM',
                  onPressed: () {},
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(hataSnackBar);
              return;
            }
            Navigator.pop(dialogContext);

            final snackBar = SnackBar(
              duration: const Duration(seconds: 3),
              content: const Text('Şifreniz başarıyla güncellendi.'),
              backgroundColor: AppColors.success,
              action: SnackBarAction(
                textColor: Colors.white,
                label: 'TAMAM',
                onPressed: () {},
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: const Text('Güncelle'),
        );

        AlertDialog alert = AlertDialog(
          title: const Text(
            'Şifre Değiştir',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mevcut Şifre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Yeni Şifre',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [iptalButonu, guncelleButonu],
        );

        return alert;
      },
    );
  }

  void _logout() {
    // 10. Hafta PDF Syf 6: Navigator.pushNamed ile giriş ekranına dönüş
    Navigator.pushNamed(context, '/auth');
  }

  // 5. Hafta PDF Syf 56 (Uygulama-33): Yardımcı fonksiyon ile ListTile oluşturma
  Widget _menuListTileOlustur(
    IconData ikon,
    String baslik,
    Color renk,
    Function tiklama, {
    bool okGoster = false,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(ikon, color: renk),
        title: Text(
          baslik,
          style: TextStyle(
            color: renk,
            fontWeight: okGoster ? FontWeight.normal : FontWeight.w600,
          ),
        ),
        trailing: okGoster ? const Icon(Icons.chevron_right) : null,
        onTap: () {
          tiklama();
        },
      ),
    );
  }

  // 1. Hafta PDF: Spread (...) yerine liste metotları ile profil detaylarını oluşturma
  List<Widget> _profilIceriginiOlustur() {
    List<Widget> icerik = [
      CircleAvatar(
        radius: 40,
        backgroundColor: AppColors.background,
        backgroundImage: const AssetImage('images/avatar.png'),
        child: ClipOval(
          child: Image.asset(
            'images/avatar.png',
            width: 72,
            height: 72,
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(height: 12),
      Text(
        widget.userName,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    ];

    if (_showProfileDetails) {
      icerik.add(const SizedBox(height: 6));
      icerik.add(
        Text(
          widget.userEmail,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      );
      icerik.add(const SizedBox(height: 4));
      icerik.add(
        const Text(
          'Isparta Uygulamalı Bilimler Üniversitesi\nBilgisayar Mühendisliği',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return icerik;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // Profil Kartı (5. Hafta PDF: Card, InkWell, ClipOval; 4. Hafta PDF: CircleAvatar, Image.asset)
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                setState(() {
                  _showProfileDetails = !_showProfileDetails;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: _profilIceriginiOlustur(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          _menuListTileOlustur(
            Icons.lock_outline,
            'Şifre Değiştir',
            AppColors.textPrimary,
            _showChangePasswordDialog,
            okGoster: true,
          ),
          const SizedBox(height: 8),

          _menuListTileOlustur(
            Icons.logout,
            'Çıkış Yap',
            AppColors.error,
            _logout,
          ),
        ],
      ),
    );
  }
}
