import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connecta/providers/theme_provider.dart';
import 'package:connecta/utils/app_themes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';

class ThemeSelectorScreen extends StatefulWidget {
  const ThemeSelectorScreen({super.key});

  @override
  State<ThemeSelectorScreen> createState() => _ThemeSelectorScreenState();
}

class _ThemeSelectorScreenState extends State<ThemeSelectorScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final theme = Theme.of(context);
        
        return AnimatedTheme(
          duration: const Duration(milliseconds: 500),
          data: theme,
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: AppBar(
                    backgroundColor: theme.colorScheme.surface.withOpacity(0.8),
                    elevation: 0,
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.surface.withOpacity(0.9),
                            theme.colorScheme.surface.withOpacity(0.7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    leading: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.1),
                            theme.colorScheme.primary.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          color: theme.colorScheme.primary,
                          size: 18,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary.withOpacity(0.1),
                                theme.colorScheme.primary.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.palette,
                            color: theme.colorScheme.primary,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ) ?? const TextStyle(),
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.secondary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: const Text(
                              'Choose Theme',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    centerTitle: true,
                  ),
                ),
              ),
            ),
            body: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              'Select your favorite theme color. Each theme includes both light and dark modes.',
                              style: TextStyle(
                                fontSize: 16,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Current Theme Display
                          _buildCurrentThemeCard(themeProvider, theme),
                          const SizedBox(height: 24),
                          
                          // Theme Options
                          ...AppThemeType.values.asMap().entries.map((entry) {
                            final index = entry.key;
                            final themeType = entry.value;
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300 + (index * 100)),
                              child: _buildThemeOption(
                                context, 
                                themeProvider, 
                                themeType,
                                index,
                              ),
                            );
                          }),
                          
                          const SizedBox(height: 32),
                          
                          // Live Preview Section
                          _buildLivePreview(themeProvider, theme),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentThemeCard(ThemeProvider themeProvider, ThemeData theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeProvider.currentThemeColor.withOpacity(0.1),
            themeProvider.currentThemeColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: themeProvider.currentThemeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  themeProvider.currentThemeColor,
                  themeProvider.currentThemeColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: themeProvider.currentThemeColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              FontAwesomeIcons.paintBrush,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.currentThemeColor,
                  ),
                  child: Text('Current Theme'),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.textTheme.titleLarge?.color,
                    fontWeight: FontWeight.w600,
                  ),
                  child: Text(themeProvider.currentThemeName),
                ),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                  child: Text(themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, 
    ThemeProvider themeProvider, 
    AppThemeType themeType,
    int index,
  ) {
    final isSelected = themeProvider.selectedTheme == themeType;
    final themeColor = AppThemes.getThemeColor(themeType);
    final themeName = AppThemes.getThemeName(themeType);
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? const Color(0xFF2A2A2A)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? Border.all(color: themeColor, width: 3)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: isSelected 
                        ? themeColor.withOpacity(0.3)
                        : Colors.black.withOpacity(0.1),
                    blurRadius: isSelected ? 20 : 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () async {
                    await themeProvider.setSelectedTheme(themeType);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Theme changed to $themeName'),
                          backgroundColor: themeColor,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                themeColor.withOpacity(0.8),
                                themeColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: themeColor.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            FontAwesomeIcons.palette,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: theme.textTheme.titleLarge?.color,
                                ),
                                child: Text(themeName),
                              ),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style: TextStyle(
                                  color: theme.textTheme.bodyMedium?.color,
                                ),
                                child: const Text('Light & Dark modes available'),
                              ),
                            ],
                          ),
                        ),
                        AnimatedScale(
                          duration: const Duration(milliseconds: 200),
                          scale: isSelected ? 1.0 : 0.0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: themeColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              FontAwesomeIcons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLivePreview(ThemeProvider themeProvider, ThemeData theme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF2A2A2A)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: themeProvider.currentThemeColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.eye,
                color: themeProvider.currentThemeColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.currentThemeColor,
                ),
                child: const Text('Live Preview'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildThemePreview(
                  'Light Mode',
                  AppThemes.getLightTheme(themeProvider.selectedTheme),
                  false,
                  themeProvider,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildThemePreview(
                  'Dark Mode',
                  AppThemes.getDarkTheme(themeProvider.selectedTheme),
                  true,
                  themeProvider,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemePreview(
    String title, 
    ThemeData previewTheme, 
    bool isDark,
    ThemeProvider themeProvider,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: previewTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeProvider.currentThemeColor.withOpacity(0.3),
          width: themeProvider.isDarkMode == isDark ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: themeProvider.currentThemeColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: previewTheme.colorScheme.primary,
                ),
              ),
              const Spacer(),
              if (themeProvider.isDarkMode == isDark)
                Icon(
                  FontAwesomeIcons.circleCheck,
                  size: 12,
                  color: previewTheme.colorScheme.primary,
                ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 30,
            decoration: BoxDecoration(
              color: previewTheme.appBarTheme.backgroundColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Icon(
                  FontAwesomeIcons.heart,
                  size: 12,
                  color: previewTheme.iconTheme.color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Connecta',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: previewTheme.appBarTheme.titleTextStyle?.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: 20,
            decoration: BoxDecoration(
              color: previewTheme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                'Sample Content',
                style: TextStyle(
                  fontSize: 8,
                  color: previewTheme.textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
