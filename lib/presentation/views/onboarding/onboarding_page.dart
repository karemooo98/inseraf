import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../core/storage/app_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../controllers/auth_controller.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  final List<_OnboardingSlide> _slides = const <_OnboardingSlide>[
    _OnboardingSlide(
      icon: Symbols.shield_person,
      title: 'Secure Attendance',
      description:
          'Clock in and out with confidence. Your records are encrypted and synced instantly.',
    ),
    _OnboardingSlide(
      icon: Symbols.task,
      title: 'Stay Organized',
      description:
          'Requests, approvals, and tasks all live in one streamlined workspace.',
    ),
    _OnboardingSlide(
      icon: Symbols.auto_graph,
      title: 'Insights That Matter',
      description:
          'Track trends, spot issues early, and keep teams aligned every day.',
    ),
  ];

  bool _isCompleting = false;

  AppPreferences get _preferences => Get.find<AppPreferences>();
  AuthController get _authController => Get.find<AuthController>();

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_currentPage.value < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    if (_isCompleting) return;
    setState(() => _isCompleting = true);
    await _preferences.setOnboardingSeen();
    await _authController.initSession();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color surfaceColor = Theme.of(context).colorScheme.surface;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: ValueListenableBuilder<int>(
                  valueListenable: _currentPage,
                  builder: (BuildContext context, int page, _) {
                    if (page == _slides.length - 1) {
                      return const SizedBox(height: 48);
                    }
                    return TextButton(
                      onPressed: _isCompleting ? null : _completeOnboarding,
                      child: const Text('Skip'),
                    );
                  },
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (int value) => _currentPage.value = value,
                  itemBuilder: (BuildContext context, int index) {
                    final _OnboardingSlide slide = _slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppTheme.primaryGradient,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: primaryColor.withOpacity(0.2),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Icon(
                            slide.icon,
                            size: 96,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.grey[700], height: 1.5),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              ValueListenableBuilder<int>(
                valueListenable: _currentPage,
                builder: (BuildContext context, int page, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(
                      _slides.length,
                      (int index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: page == index ? 28 : 8,
                        decoration: BoxDecoration(
                          color: page == index
                              ? primaryColor
                              : primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              ValueListenableBuilder<int>(
                valueListenable: _currentPage,
                builder: (BuildContext context, int page, _) {
                  final bool isLast = page == _slides.length - 1;
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _isCompleting
                              ? null
                              : isLast
                              ? _completeOnboarding
                              : _goNext,
                          child: _isCompleting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(isLast ? 'Get Started' : 'Next'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (!isLast)
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _isCompleting
                                ? null
                                : _completeOnboarding,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: surfaceColor,
                            ),
                            child: const Text('Skip for now'),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
