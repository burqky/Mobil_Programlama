import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../data/app_state_data.dart';
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

  final TextEditingController _nameController = TextEditingController(
    text: 'Ahmet Yılmaz',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'ahmet@isparta.edu.tr',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: '123456',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Giriş ve kayıt işlemi (Future.delayed ile asenkron simülasyon)
  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen e-posta ve şifre giriniz.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_mode == 1 && name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen ad soyad giriniz.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
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
    AppStateData.currentUserEmail = email;

    // Kullanıcı adını constructor ile ana ekrana gönderiyoruz
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainNavigationScreen(
          userName: AppStateData.currentUserName,
          userEmail: AppStateData.currentUserEmail,
        ),
      ),
    );
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: screenWidth > 420 ? 380 : double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Üst logo alanı
                  AspectRatio(
                    aspectRatio: 3.5,
                    child: Center(
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'images/logo.png',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
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
                  const SizedBox(height: 4),
                  Text(
                    _mode == 0
                        ? 'Devam etmek için giriş yapın'
                        : (_mode == 1
                            ? 'Bilgilerinizi girerek kayıt olun'
                            : 'Yeni şifrenizi belirleyin'),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Giriş formu kartı
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Sadece kayıt modunda Ad Soyad gösterilir
                          if (_mode == 1) ...[
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Ad Soyad',
                                hintText: 'Adınız ve soyadınız',
                                prefixIcon: Icon(Icons.person_outline, size: 20),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],

                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'E-posta',
                              hintText: 'ornek@mail.com',
                              prefixIcon: Icon(Icons.email_outlined, size: 20),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),

                          TextField(
                            controller: _passwordController,
                            obscureText: _hidePassword,
                            decoration: InputDecoration(
                              labelText: _mode == 2 ? 'Yeni Şifre' : 'Şifre',
                              hintText: 'Şifrenizi girin',
                              prefixIcon: const Icon(Icons.lock_outline, size: 20),
                              border: const OutlineInputBorder(),
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
                          ),

                          if (_mode == 0)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => setState(() => _mode = 2),
                                child: const Text(
                                  'Şifremi Unuttum',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            )
                          else
                            const SizedBox(height: 16),

                          ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            child: Text(
                              _isLoading
                                  ? 'Lütfen bekleyin...'
                                  : (_mode == 0
                                      ? 'Giriş Yap'
                                      : (_mode == 1
                                          ? 'Kayıt Ol'
                                          : 'Şifreyi Güncelle')),
                            ),
                          ),
                        ],
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
        ),
      ),
    );
  }
}
