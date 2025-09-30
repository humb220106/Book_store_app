import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:sizer/sizer.dart';

/// Custom AppTheme for colors (white, cream, brown)
class AppTheme {
  static const Color pureWhite = Colors.white;
  static const Color softCream = Color(0xFFF5F5DC);
  static const Color brown = Colors.brown;
  static const Color textSecondary = Colors.grey;

  static ThemeData lightTheme = ThemeData(
    primaryColor: brown,
    scaffoldBackgroundColor: softCream,
    textTheme: const TextTheme(
      titleSmall: TextStyle(color: brown),
      bodyMedium: TextStyle(color: brown),
    ),
  );
}

/// ---------------- MAIN ONBOARDING (WELCOME) SCREEN ----------------
class OnboardingWelcomeScreen extends StatefulWidget {
  const OnboardingWelcomeScreen({super.key});

  @override
  State<OnboardingWelcomeScreen> createState() =>
      _OnboardingWelcomeScreenState();
}

class _OnboardingWelcomeScreenState extends State<OnboardingWelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleGetStarted() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingFeatureSlides()),
    );
  }

  void _handleSkip() {
    HapticFeedback.selectionClick();
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pureWhite,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.pureWhite,
                AppTheme.softCream.withOpacity(0.3),
                AppTheme.pureWhite,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
            children: [
              _buildBackgroundIllustrations(),
              _buildMainContent(),
              _buildSkipButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Background circles + floating icons
  Widget _buildBackgroundIllustrations() {
    final size = MediaQuery.of(context).size;
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: size.height * 0.05,
            right: -size.width * 0.05,
            child: _circle(
              size.width * 0.3,
              AppTheme.softCream.withOpacity(0.3),
            ),
          ),
          Positioned(
            bottom: size.height * 0.10,
            left: -size.width * 0.10,
            child: _circle(size.width * 0.4, AppTheme.brown.withOpacity(0.1)),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );

  /// Skip button
  Widget _buildSkipButton() {
    final size = MediaQuery.of(context).size;
    return Positioned(
      top: size.height * 0.02,
      right: size.width * 0.04,
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) => Opacity(
          opacity: _fadeAnimation.value,
          child: TextButton(
            onPressed: _handleSkip,
            child: const Text(
              "Skip",
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
        ),
      ),
    );
  }

  /// Main onboarding welcome content
  Widget _buildMainContent() {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.08),
                  const WelcomeLogoWidget(),
                  SizedBox(height: size.height * 0.06),
                  const WelcomeContentWidget(),
                  SizedBox(height: size.height * 0.06),
                  WelcomeActionsWidget(
                    onGetStarted: _handleGetStarted,
                    onSkip: _handleSkip,
                  ),
                  SizedBox(height: size.height * 0.04),
                  const ProgressIndicatorWidget(currentStep: 0, totalSteps: 3),
                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ---------------- FEATURE SLIDES ----------------
class OnboardingFeatureSlides extends StatefulWidget {
  const OnboardingFeatureSlides({super.key});

  @override
  State<OnboardingFeatureSlides> createState() =>
      _OnboardingFeatureSlidesState();
}

class _OnboardingFeatureSlidesState extends State<OnboardingFeatureSlides> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      "title": "Easy Booking",
      "description": "Book your favorite services with just a few taps.",
      "imageUrl":
          "https://images.unsplash.com/photo-1611224923853-80b023f02d71",
      "backgroundColor": AppTheme.softCream,
    },
    {
      "title": "Ultimate Convenience",
      "description": "Manage all your appointments anytime, anywhere.",
      "imageUrl":
          "https://images.pexels.com/photos/607812/pexels-photo-607812.jpeg",
      "backgroundColor": AppTheme.softCream,
    },
    {
      "title": "Trust & Security",
      "description": "Your data is safe. Providers are verified.",
      "imageUrl":
          "https://files.resources.altium.com/sites/default/files/blogs/Implementing%20Zero%20Trust%20Security%20in%20Electronics%20Design%20Environments-95995.jpg",
      "backgroundColor": AppTheme.softCream,
    },
  ];

  void _onPageChanged(int page) => setState(() => _currentPage = page);

  void _onSkip() => Navigator.pushNamed(context, '/signup');

  void _onNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onContinue() => Navigator.pushNamed(context, '/signup');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.softCream,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _slides.length,
              itemBuilder: (context, index) {
                final slide = _slides[index];
                return SlideContentWidget(
                  title: slide["title"],
                  description: slide["description"],
                  imageUrl: slide["imageUrl"],
                  backgroundColor: slide["backgroundColor"],
                  height: size.height,
                  width: size.width,
                );
              },
            ),
          ),
          NavigationControlsWidget(
            pageController: _pageController,
            currentPage: _currentPage,
            totalPages: _slides.length,
            onSkip: _onSkip,
            onNext: _onNext,
            onContinue: _onContinue,
          ),
          SizedBox(height: size.height * 0.02),
        ],
      ),
    );
  }
}

/// ---------------- WIDGETS ----------------
class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  const ProgressIndicatorWidget({
    required this.currentStep,
    required this.totalSteps,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentStep == index ? 20 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: currentStep == index ? AppTheme.brown : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(5),
          ),
        );
      }),
    );
  }
}

class WelcomeLogoWidget extends StatelessWidget {
  const WelcomeLogoWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.book, size: 80, color: AppTheme.brown);
  }
}

class WelcomeContentWidget extends StatelessWidget {
  const WelcomeContentWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          "Welcome to ChapterHouse",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.brown,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Your all-in-one booking solution",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}

class WelcomeActionsWidget extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onSkip;
  const WelcomeActionsWidget({
    required this.onGetStarted,
    required this.onSkip,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onGetStarted,
          child: const Text("Get Started"),
        ),
        TextButton(onPressed: onSkip, child: const Text("Skip for now")),
      ],
    );
  }
}

class NavigationControlsWidget extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final int totalPages;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final VoidCallback onContinue;

  const NavigationControlsWidget({
    required this.pageController,
    required this.currentPage,
    required this.totalPages,
    required this.onSkip,
    required this.onNext,
    required this.onContinue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentPage == totalPages - 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(onPressed: onSkip, child: const Text("Skip")),
        Row(
          children: List.generate(totalPages, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: currentPage == index ? 16 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: currentPage == index
                    ? AppTheme.brown
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        isLastPage
            ? ElevatedButton(
                onPressed: onContinue,
                child: const Text("Continue"),
              )
            : ElevatedButton(onPressed: onNext, child: const Text("Next")),
      ],
    );
  }
}

class SlideContentWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final Color backgroundColor;
  final double height;
  final double width;

  const SlideContentWidget({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.backgroundColor,
    required this.height,
    required this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(imageUrl, height: height * 0.4, fit: BoxFit.cover),
          SizedBox(height: height * 0.04),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.brown,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.08,
              vertical: height * 0.02,
            ),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
