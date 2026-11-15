import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// 2. Hafta PDF (Future.delayed), 3. Hafta PDF (LinearGradient, BoxShape.circle, BoxShadow),
/// 4. Hafta PDF (Image.asset), 5. Hafta PDF (GestureDetector, ClipPath, ClipRRect) ve
/// 10. Hafta PDF (Navigator.pushNamed) kullanılarak oluşturulan Açılış Ekranı
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    // 2. Hafta PDF Syf 32: Future.delayed ile asenkron bekleme ve yönlendirme
    Future.delayed(const Duration(seconds: 2), () {
      _goToAuth();
    });
  }

  void _goToAuth() {
    if (_navigated || !mounted) {
      return;
    }
    _navigated = true;
    // 10. Hafta PDF Syf 6: Tanımlı rotaya Navigator.pushNamed ile geçiş
    Navigator.pushNamed(context, '/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          _goToAuth();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            // 3. Hafta PDF Syf 22-23: LinearGradient arka plan
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.darkBgTop,
                AppColors.darkBgBottom,
                Colors.black,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 5. Hafta PDF Syf 49-53 (Uygulama-32): ClipPath ve CustomClipper<Path>
                ClipPath(
                  clipper: OzelAcilisClipper(),
                  child: Container(
                    width: double.infinity,
                    height: 90,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.darkBgTop,
                        ],
                      ),
                    ),
                  ),
                ),

                // Orta Kısım: Dairesel Logo ve Uygulama Başlığı
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 108,
                      height: 108,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        // 3. Hafta PDF Syf 27: BoxShape.circle kullanımı (borderRadius ile birlikte kullanılmaz)
                        shape: BoxShape.circle,
                        color: AppColors.darkBgTop,
                        border: Border.all(
                          color: Colors.blue.shade400,
                          width: 2.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade900,
                            blurRadius: 28,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      // 5. Hafta PDF Syf 39: ClipRRect ile köşe yuvarlatma
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        // 4. Hafta PDF Syf 2: Image.asset kullanımı
                        child: Image.asset(
                          'images/logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.fitness_center_rounded,
                                size: 54,
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'SPOR TAKİP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Gücünü Keşfet, Gelişimini Takip Et',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),

                // Alt Kısım: Stüdyo imzası
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'from',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            color: AppColors.accent,
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'FITNESS & GYM STUDIO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 5. Hafta PDF Syf 49-53 (Uygulama-32): Özel kırpma sınıfı (`CustomClipper<Path>`)
class OzelAcilisClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height * 0.35);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(OzelAcilisClipper oldClipper) {
    return false;
  }
}
