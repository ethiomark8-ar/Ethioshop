import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ethioshop/presentation/providers/auth_provider.dart';
import 'package:ethioshop/core/theme/app_colors.dart';
import 'package:ethioshop/core/theme/app_spacing.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';

/// Premium Splash Screen Experience
/// Deep AMOLED black background with gradient logo reveal
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
    ));

    _controller.forward();

    // Auto-navigate after 3 seconds
    Timer(const Duration(seconds: 3), () {
      _navigate();
    });
  }

  void _navigate() {
    final authState = ref.read(authStateProvider);
    
    if (authState.isAuthenticated) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Center Logo
              Center(
                child: FadeTransition(
                  opacity: _logoAnimation,
                  child: ScaleTransition(
                    scale: _logoAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Gradient Logo
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return AppColors.logoGradient.createShader(bounds);
                          },
                          child: const Text(
                            'EthioShop',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        
                        // Subtle tagline
                        Opacity(
                          opacity: _logoAnimation.value * 0.7,
                          child: const Text(
                            'Ethiopia\'s Premier Marketplace',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Loading Bar
              Positioned(
                left: AppSpacing.xl,
                right: AppSpacing.xl,
                bottom: AppSpacing.xxl,
                child: Column(
                  children: [
                    // Progress Bar Container
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: FractionallySizedBox(
                          widthFactor: _progressAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.logoGradient,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    
                    // Loading text
                    Opacity(
                      opacity: _logoAnimation.value,
                      child: const Text(
                        'Loading your experience...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white60,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}