import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../data/app_state_data.dart';
import '../widgets/custom_text_field.dart';
import 'main_navigation_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // 0: Giriş Yap, 1: Kayıt Ol, 2: Şifre Sıfırla
  int _mode = 0;
  bool _isLoading = false;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  final TextEditingController _nameController = TextEditingController(
    text: 'Ahmet Yılmaz',
  );
  final TextEditingController _usernameController = TextEditingController(
    text: 'ahmetyilmaz',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'ahmet@isparta.edu.tr',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '0555 123 45 67',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: '123456',
  );
  final TextEditingController _confirmPasswordController =
      TextEditingController(
        text: '123456',
      );

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Giriş ve kayıt işlemi (2. Hafta PDF Syf 32: Future.delayed ile asenkron simülasyon)
  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (_mode == 0 && (username.isEmpty || password.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen kullanıcı adı ve şifre giriniz.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_mode == 1) {
      if (name.isEmpty ||
          username.isEmpty ||
          email.isEmpty ||
          phone.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lütfen tüm kayıt alanlarını doldurunuz.'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Şifreler birbiriyle eşleşmiyor.'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }

    if (_mode == 2) {
      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lütfen e-posta, şifre ve şifre tekrarını giriniz.'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Şifreler birbiriyle eşleşmiyor.'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (_mode == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Şifreniz güncellendi, giriş yapabilirsiniz.'),
          backgroundColor: AppColors.success,
        ),
      );
      setState(() => _mode = 0);
      return;
    }

    if (name.isNotEmpty) {
      AppStateData.currentUserName = name;
    }
    if (email.isNotEmpty) {
      AppStateData.currentUserEmail = email;
    }

    // 10. Hafta PDF Syf 9-10: Navigator.push ve Constructor üzerinden veri aktarımı
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainNavigationScreen(
          userName: AppStateData.currentUserName,
          userEmail: AppStateData.currentUserEmail,
        ),
      ),
    );
  }

  // 1. Hafta PDF Syf 41 & 62: List.add() ve if-else karar yapıları ile form alanlarını oluşturma
  List<Widget> _formElemanlariniOlustur() {
    List<Widget> elemanlar = [];

    // Sadece kayıt modunda İsim Soyisim gösterilir
    if (_mode == 1) {
      elemanlar.add(
        CustomTextField(
          controller: _nameController,
          labelText: 'İsim Soyisim',
          hintText: 'Adınız ve soyadınız',
          prefixIcon: Icons.person_outline,
        ),
      );
      elemanlar.add(const SizedBox(height: 12));
    }

    // Giriş ve kayıt modunda Kullanıcı Adı gösterilir
    if (_mode != 2) {
      elemanlar.add(
        CustomTextField(
          controller: _usernameController,
          labelText: 'Kullanıcı Adı',
          hintText: 'Kullanıcı adınız',
          prefixIcon: Icons.alternate_email,
        ),
      );
      elemanlar.add(const SizedBox(height: 12));
    }

    // Kayıt ve şifre yenileme modunda E-posta gösterilir
    if (_mode != 0) {
      elemanlar.add(
        CustomTextField(
          controller: _emailController,
          labelText: 'E-posta',
          hintText: 'ornek@mail.com',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
      );
      elemanlar.add(const SizedBox(height: 12));
    }

    // Sadece kayıt modunda Telefon gösterilir
    if (_mode == 1) {
      elemanlar.add(
        CustomTextField(
          controller: _phoneController,
          labelText: 'Telefon',
          hintText: '05XX XXX XX XX',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
      );
      elemanlar.add(const SizedBox(height: 12));
    }

    elemanlar.add(
      CustomTextField(
        controller: _passwordController,
        labelText: _mode == 2 ? 'Yeni Şifre' : 'Şifre',
        hintText: 'Şifrenizi girin',
        prefixIcon: Icons.lock_outline,
        obscureText: _hidePassword,
        suffixIcon: IconButton(
          icon: Icon(
            _hidePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 20,
          ),
          onPressed: () {
            setState(() => _hidePassword = !_hidePassword);
          },
        ),
      ),
    );

    // Kayıt ve şifre yenileme modunda Şifre Tekrar gösterilir
    if (_mode != 0) {
      elemanlar.add(const SizedBox(height: 12));
      elemanlar.add(
        CustomTextField(
          controller: _confirmPasswordController,
          labelText: 'Şifre Tekrar',
          hintText: 'Şifrenizi tekrar girin',
          prefixIcon: Icons.lock_outline,
          obscureText: _hideConfirmPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _hideConfirmPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20,
            ),
            onPressed: () {
              setState(
                () => _hideConfirmPassword = !_hideConfirmPassword,
              );
            },
          ),
        ),
      );
    }

    if (_mode == 0) {
      elemanlar.add(
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => setState(() => _mode = 2),
            child: const Text(
              'Şifremi Unuttum',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ),
      );
    } else {
      elemanlar.add(const SizedBox(height: 16));
    }

    elemanlar.add(
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: _isLoading ? null : _submit,
        child: Text(
          _isLoading
              ? 'Lütfen bekleyin...'
              : (_mode == 0
                  ? 'Giriş Yap'
                  : (_mode == 1 ? 'Kayıt Ol' : 'Şifreyi Güncelle')),
        ),
      ),
    );

    return elemanlar;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spor Takip'),
        centerTitle: true,
      ),
      body: SafeArea(
        // 6. Hafta PDF Syf 2: ListView ile kaydırılabilir ekran yapısı
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: SizedBox(
                width: screenWidth > 420 ? 380 : double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Üst logo alanı (4. Hafta PDF: AspectRatio, CircleAvatar, Image.asset)
                    AspectRatio(
                      aspectRatio: 3.5,
                      child: Center(
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: AppColors.primaryLight,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'images/logo.png',
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.fitness_center,
                                    size: 36,
                                    color: AppColors.primary,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _mode == 0
                          ? 'Hoş Geldiniz'
                          : (_mode == 1 ? 'Hesap Oluştur' : 'Şifre Yenile'),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Giriş formu kartı (5. Hafta PDF: Card)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _formElemanlariniOlustur(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Alt geçiş bağlantısı
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _mode == 0
                              ? 'Hesabınız yok mu?'
                              : 'Zaten hesabınız var mı?',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _mode = _mode == 0 ? 1 : 0;
                            });
                          },
                          child: Text(
                            _mode == 0 ? 'Kayıt Ol' : 'Giriş Yap',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
