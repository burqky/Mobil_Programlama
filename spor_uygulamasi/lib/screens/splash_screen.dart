import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  Timer? _navigationTimer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    // 2.5 saniye sonra otomatik olarak Giriş Ekranına (AuthScreen) yönlendirir
    _navigationTimer = Timer(const Duration(milliseconds: 2500), _goToAuth);
  }

  void _goToAuth() {
    if (_navigated || !mounted) return;
    _navigated = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuthScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _goToAuth,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Katman: Çevrimdışı durumda da görünen koyu spor salonu / halter silüeti
            CustomPaint(
              painter: _GymBackgroundPainter(),
            ),

            // 2. Katman: Arka plan spor salonu görseli (Yüksek kontrastlı koyu spor fotoğrafı)
            Opacity(
              opacity: 0.35,
              child: Image.network(
                'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=1200&q=80',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink();
                },
              ),
            ),

            // 3. Katman: Instagram tarzı koyu siyah/lacivert karartma gradyanı
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.75),
                    const Color(0xFF070B14).withValues(alpha: 0.85),
                    Colors.black.withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),

            // 4. Katman: Merkezde Logo ve Başlık + Altta Instagram tarzı imza alanı
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 48),

                  // Orta Kısım: Animasyonlu Spor Logosu ve Uygulama Adı
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 108,
                            height: 108,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF111827),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.6),
                                width: 2.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.45,
                                  ),
                                  blurRadius: 36,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
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
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Alt Kısım: Instagram açılış ekranı tarzı alt bilgi ve yükleniyor göstergesi
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.accent.withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'from',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.45),
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
          ],
        ),
      ),
    );
  }
}

/// İnternet bağlantısı olmasa bile arka planda şık bir spor/halter silüeti çizen katman
class _GymBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0B132B),
          Color(0xFF050811),
          Color(0xFF000000),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final circlePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Sağ üst ve sol alt dekoratif ağırlık plakası halkaları
    final topCenter = Offset(size.width * 0.85, size.height * 0.18);
    canvas.drawCircle(topCenter, 160, circlePaint);
    canvas.drawCircle(topCenter, 115, circlePaint);
    canvas.drawCircle(topCenter, 45, circlePaint);

    final bottomCenter = Offset(size.width * 0.15, size.height * 0.82);
    canvas.drawCircle(bottomCenter, 180, circlePaint);
    canvas.drawCircle(bottomCenter, 130, circlePaint);
    canvas.drawCircle(bottomCenter, 50, circlePaint);

    // Merkezde çapraz büyük halter (barbell) silüeti
    canvas.save();
    canvas.translate(size.width * 0.5, size.height * 0.46);
    canvas.rotate(-0.38);

    final barbellPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;

    // Halter barı
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-220, -6, 440, 12),
        const Radius.circular(6),
      ),
      barbellPaint,
    );

    // Sol ağırlık plakaları
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-180, -70, 22, 140),
        const Radius.circular(6),
      ),
      barbellPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-150, -54, 18, 108),
        const Radius.circular(5),
      ),
      barbellPaint,
    );

    // Sağ ağırlık plakaları
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(158, -70, 22, 140),
        const Radius.circular(6),
      ),
      barbellPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(132, -54, 18, 108),
        const Radius.circular(5),
      ),
      barbellPaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
