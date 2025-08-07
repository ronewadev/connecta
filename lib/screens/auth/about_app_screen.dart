import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:connecta/utils/text_strings.dart';
import 'package:connecta/screens/auth/signup_screen.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<AboutPageData> _pages = [
    AboutPageData(
      image: 'assets/logos/app_icon_words.png',
      title: AppText.aboutConnecta,
      description: AppText.connectaDescription,
    ),
    AboutPageData(
      backgroundImage: 'assets/images/fun_activities.png',
      image: 'assets/images/fun2.jpg',
      title: AppText.funActivitiesTitle,
      description: AppText.funActivitiesDesc,
    ),
    AboutPageData(
      backgroundImage: 'assets/images/monetization.png',
      image: 'assets/images/affordable2.jpg',
      title: AppText.monetizationTitle,
      description: AppText.monetizationDesc,
    ),
    AboutPageData(
      backgroundImage: 'assets/images/cashback.jpg',
      image: 'assets/images/cashback2.png',
      title: AppText.cashbackTitle,
      description: AppText.cashbackDesc,
    ),
    AboutPageData(
      backgroundImage: 'assets/images/more_than_just_dating_app.png',
      image: 'assets/images/more_than2.jpg',
      title: AppText.moreThanDatingTitle,
      description: AppText.moreThanDatingDesc,
    ),
    AboutPageData(
      backgroundImage: 'assets/images/near_far.png',
      image: 'assets/images/connect_near_far2.jpg',
      title: AppText.nearFarTitle,
      description: AppText.nearFarDesc,
    ),
    AboutPageData(
      backgroundImage: 'assets/images/speading_love.png',
      image: 'assets/images/spread2.jpg',
      title: AppText.spreadingLoveTitle,
      description: AppText.spreadingLoveDesc,
    ),
    AboutPageData(
      backgroundImage: 'assets/images/ready.png',
      image: 'assets/images/ready2.jpg',
      title: AppText.readyTitle,
      description: AppText.readyDesc,
      isLastPage: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeAnimations();
    _animationController.forward();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _buildBackgroundDecoration(),
        child: SafeArea(
          child: Stack(
            children: [
              // Main Content
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      // Page View
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: _onPageChanged,
                          itemCount: _pages.length,
                          itemBuilder: (context, index) {
                            return _buildPage(_pages[index]);
                          },
                        ),
                      ),
                      
                      // Bottom Controls
                      _buildBottomControls(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF6B46C1),
          Color(0xFF9333EA),
          Color(0xFFEC4899),
          Color(0xFFBE185D),
        ],
        stops: [0.0, 0.3, 0.7, 1.0],
      ),
    );
  }

  Widget _buildSkipButton() {
    return GestureDetector(
      onTap: () => _goToSignup(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),

        child: Text(
          AppText.skip,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSkipTextButton() {
    return Container(
      height: 56,
      child: TextButton(
        onPressed: _goToSignup,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          AppText.skip,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPage(AboutPageData pageData) {
    final isFirstPage = _pages.indexOf(pageData) == 0;
    
    if (isFirstPage) {
      // First page with smaller circular design
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            
            // Image Container with glass morphism (smaller for first page)
            ClipRRect(
              borderRadius: BorderRadius.circular(140),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.15),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(120),
                      child: Image.asset(
                        pageData.image,
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Title
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Colors.white, Colors.white.withOpacity(0.9)],
              ).createShader(bounds),
              child: Text(
                pageData.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  height: 1.2,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Description
            Text(
              pageData.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w300,
                height: 1.6,
                letterSpacing: 0.3,
              ),
            ),
            
            const Spacer(flex: 2),
          ],
        ),
      );
    } else {
      // Other pages with large full-screen image design
      return Stack(
        children: [
          // Large background image with overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(pageData.backgroundImage ?? pageData.image),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),
          
          // Glass morphism overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Content overlay
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(flex: 3),
                  
                  // Featured image in glass container
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0.15),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            pageData.image,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Title with enhanced styling
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.white, Color(0xFFFFFBEB)],
                      ).createShader(bounds),
                      child: Text(
                        pageData.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Description with glass background
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      pageData.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Page Indicators
          _buildPageIndicators(),
          
          const SizedBox(height: 32),
          
          // Navigation Buttons
          Row(
            children: [
              // Skip Button on first page, Previous Button on other pages
              if (_currentIndex == 0)
                Expanded(
                  flex: 1,
                  child: _buildSkipTextButton(),
                )
              else if (_currentIndex > 0)
                Expanded(
                  flex: 1,
                  child: _buildPreviousButton(),
                )
              else
                const Expanded(flex: 1, child: SizedBox()),
              
              const SizedBox(width: 16),
              
              // Next/Ready Button
              Expanded(
                flex: 2,
                child: _buildNextButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentIndex == index ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentIndex == index
                ? Colors.white
                : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildPreviousButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ElevatedButton(
        onPressed: _goToPreviousPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          AppText.previous,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    final isLastPage = _currentIndex == _pages.length - 1;
    
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEC4899),
            Color(0xFFBE185D),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEC4899).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLastPage ? _goToSignup : _goToNextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLastPage ? AppText.amReady : AppText.next,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            if (!isLastPage) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _goToNextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToLastPage() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _goToSignup() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const SignupScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}

class AboutPageData {
  final String image;
  final String? backgroundImage;
  final String title;
  final String description;
  final bool isLastPage;

  AboutPageData({
    required this.image,
    this.backgroundImage,
    required this.title,
    required this.description,
    this.isLastPage = false,
  });
}
