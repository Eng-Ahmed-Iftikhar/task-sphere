import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tasksphere/core/constants/app_constants.dart';
import 'package:tasksphere/core/themes/app_themes.dart';

class SplashScreen extends StatefulWidget {
  final Function() onFinished;
  const SplashScreen({super.key, required this.onFinished});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  late AnimationController _progressController;

  String _displayText = '';
  final String _fullText = 'Task Sphere';

  Timer? _typingTimer;
  Timer? _navTimer;

  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    /// LOGO ANIMATION
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _logoScale = Tween<double>(begin: 0.75, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(_logoController);

    /// PROGRESS ANIMATION
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _logoController.forward();

    _startTypingAnimation();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _progressController.forward();
    });

    _navTimer = Timer(const Duration(seconds: 5), _navigateToHome);
  }

  void _startTypingAnimation() {
    int index = 0;

    _typingTimer = Timer.periodic(const Duration(milliseconds: 110), (timer) {
      if (!mounted) return;

      if (index <= _fullText.length) {
        setState(() {
          _displayText = _fullText.substring(0, index);
        });
        index++;
      } else {
        timer.cancel();
      }
    });
  }

  void _navigateToHome() {
    if (!mounted || _navigated) return;

    _navigated = true;

    widget.onFinished();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _navTimer?.cancel();
    _logoController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppConstants.primaryColor;
    final secondary = AppConstants.secondaryColor;
    final themeMode = Theme.brightnessOf(context);
    final isDarkMode = themeMode == Brightness.dark;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: darkTheme,
      theme: lightTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      title: 'Splash Screen',
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(),

              /// LOGO
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoOpacity.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .08),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Image.asset('assets/logo_icon.png'),
                ),
              ),

              const SizedBox(height: 30),

              /// TITLE
              SizedBox(
                height: 60,
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                      children: [
                        TextSpan(
                          text: _displayText.length <= 5
                              ? _displayText
                              : 'Task ',
                          style: TextStyle(color: primary),
                        ),
                        if (_displayText.length > 5)
                          TextSpan(
                            text: _displayText.substring(5),
                            style: TextStyle(color: secondary),
                          ),
                        TextSpan(
                          text: _displayText.length < _fullText.length
                              ? '|'
                              : '',
                          style: TextStyle(color: primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              /// LOADING TEXT
              const Text(
                'Loading...',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 15),

              /// PROGRESS BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: _progressController.value,
                        minHeight: 8,

                        valueColor: AlwaysStoppedAnimation<Color>(primary),
                      ),
                    );
                  },
                ),
              ),

              const Spacer(),

              /// BOTTOM DECORATION
              Container(
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      primary.withValues(alpha: .05),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(100),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
