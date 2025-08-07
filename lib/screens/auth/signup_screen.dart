import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecta/services/auth_service.dart';
import 'package:connecta/screens/auth/login_screen.dart';
import 'package:connecta/screens/auth/onboarding/personal_details_scree.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    // Add listeners to controllers to trigger rebuilds
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
    
    _animationController.forward();
  }

  bool _isFormValid() {
    final hasValidEmail = _emailController.text.isNotEmpty &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text);
    final hasValidPassword = _passwordController.text.isNotEmpty &&
        _passwordController.text.length >= 6;
    final hasConfirmPassword = _confirmPasswordController.text.isNotEmpty;
    
    return hasValidEmail && hasValidPassword && hasConfirmPassword && _agreeToTerms;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    
    List<String> issues = [];
    
    if (value.length < 8) {
      issues.add('At least 8 characters');
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      issues.add('One uppercase letter');
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      issues.add('One lowercase letter');
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      issues.add('One number');
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      issues.add('One special character');
    }
    
    if (issues.isNotEmpty) {
      return 'Password needs: ${issues.join(', ')}';
    }
    
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF6B46C1), // Purple
              const Color(0xFF9333EA), // Purple-Pink
              const Color(0xFFEC4899), // Pink
              const Color(0xFFBE185D), // Deep Pink
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Logo Container
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'assets/logos/app_icon.png',
                            width: 130,
                            height: 130,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Title
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.white, Colors.white.withOpacity(0.8)],
                      ).createShader(bounds),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Join Connecta to find your perfect match',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 48),
                    
                    // Form Container
                    ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.25),
                                Colors.white.withOpacity(0.15),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Email Field
                                  _buildTextField(
                                    controller: _emailController,
                                    label: 'Email',
                                    icon: FontAwesomeIcons.envelope,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  // Password Field
                                  _buildTextField(
                                    controller: _passwordController,
                                    label: 'Password',
                                    icon: FontAwesomeIcons.lock,
                                    obscureText: _obscurePassword,
                                    suffixIcon: IconButton(
                                      icon: FaIcon(
                                        _obscurePassword ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                                        color: Colors.white.withOpacity(0.7),
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    validator: _validatePassword,
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  // Confirm Password Field
                                  _buildTextField(
                                    controller: _confirmPasswordController,
                                    label: 'Confirm Password',
                                    icon: FontAwesomeIcons.lock,
                                    obscureText: _obscureConfirmPassword,
                                    suffixIcon: IconButton(
                                      icon: FaIcon(
                                        _obscureConfirmPassword ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                                        color: Colors.white.withOpacity(0.7),
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword = !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                    validator: _validateConfirmPassword,
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  // Terms and Conditions Checkbox
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _agreeToTerms = !_agreeToTerms;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.6),
                                              width: 2,
                                            ),
                                            color: _agreeToTerms 
                                                ? Colors.white 
                                                : Colors.transparent,
                                          ),
                                          child: _agreeToTerms
                                              ? const Icon(
                                                  Icons.check,
                                                  size: 16,
                                                  color: Color(0xFF6B46C1),
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.9),
                                                fontSize: 14,
                                              ),
                                              children: [
                                                const TextSpan(text: 'I agree to the '),
                                                TextSpan(
                                                  text: 'Terms of Service',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () => _showTermsOfService(context),
                                                ),
                                                const TextSpan(text: ' and '),
                                                TextSpan(
                                                  text: 'Privacy Policy',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () => _showPrivacyPolicy(context),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  
                                  // Sign Up Button
                                  Container(
                                    width: double.infinity,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      gradient: _isFormValid()
                                          ? LinearGradient(
                                              colors: [
                                                const Color(0xFFEC4899),
                                                const Color(0xFFBE185D),
                                              ],
                                            )
                                          : LinearGradient(
                                              colors: [
                                                Colors.grey.withOpacity(0.5),
                                                Colors.grey.withOpacity(0.3),
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(28),
                                      boxShadow: _isFormValid()
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFFEC4899).withOpacity(0.4),
                                                blurRadius: 20,
                                                offset: const Offset(0, 8),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: (_isLoading || !_isFormValid()) ? null : _register,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(28),
                                        ),
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(
                                              'Sign Up',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: _isFormValid() ? Colors.white : Colors.white.withOpacity(0.5),
                                                letterSpacing: 1,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  // Divider
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.transparent,
                                                Colors.white.withOpacity(0.4),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(
                                          'or',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.transparent,
                                                Colors.white.withOpacity(0.4),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  // Social Login Buttons
                                  _buildSocialButton(
                                    'Continue with Google',
                                    FontAwesomeIcons.google,
                                    Colors.white,
                                    const Color(0xFF4285F4),
                                    () => _socialSignUp('google'),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildSocialButton(
                                    'Continue with Facebook',
                                    FontAwesomeIcons.facebook,
                                    Colors.white,
                                    const Color(0xFF1877F2),
                                    () => _socialSignUp('facebook'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(-1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                                transitionDuration: const Duration(milliseconds: 300),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.white.withOpacity(0.8),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: FaIcon(
              icon,
              color: Colors.white.withOpacity(0.8),
              size: 20,
            ),
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          errorStyle: const TextStyle(color: Colors.yellowAccent),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String text, IconData icon, Color textColor, Color iconColor, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              color: iconColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Just validate the form and navigate to personal details
        // We'll create the Firebase user at the end of the flow
        
        // Navigate directly to PersonalDetailsScreen with email and password
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => PersonalDetailsScreen(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigation failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please agree to the Terms of Service and Privacy Policy'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _socialSignUp(String provider) async {
    // Implement social signup logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider signup coming soon!'),
        backgroundColor: const Color(0xFF6B46C1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF6B46C1).withOpacity(0.95),
                  const Color(0xFF9333EA).withOpacity(0.95),
                  const Color(0xFFEC4899).withOpacity(0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.fileContract,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Terms of Service',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const FaIcon(
                          FontAwesomeIcons.xmark,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '''Welcome to Connecta! By using our dating app, you agree to these terms:

1. ACCOUNT RESPONSIBILITY
• You must be 18+ years old to use Connecta
• Provide accurate, truthful information in your profile
• Keep your login credentials secure and confidential
• You are responsible for all activity on your account

2. PROFILE GUIDELINES
• Use real, recent photos of yourself only
• No inappropriate, offensive, or misleading content
• Respect others' privacy and boundaries
• Report suspicious or inappropriate behavior

3. DATING SAFETY
• Meet in public places for first dates
• Trust your instincts and prioritize your safety
• Never share financial information with other users
• Block and report users who make you uncomfortable

4. PROHIBITED ACTIVITIES
• No harassment, bullying, or abusive behavior
• No spam, promotional content, or commercial use
• No fake profiles or impersonation
• No solicitation of money or gifts

5. SUBSCRIPTION & PAYMENTS
• Premium features require paid subscription
• Subscriptions auto-renew unless cancelled
• No refunds for unused portions of subscriptions
• Prices subject to change with notice

6. PRIVACY & DATA
• We protect your personal information per our Privacy Policy
• Location data used for matching purposes only
• Messages and interactions may be monitored for safety
• You can delete your account and data anytime

7. CONTENT OWNERSHIP
• You retain rights to your photos and content
• Grant Connecta license to use content for app functionality
• Respect intellectual property rights of others

8. APP AVAILABILITY
• Service provided "as-is" without warranties
• We may update, modify, or discontinue features
• Not responsible for technical issues or downtime

9. TERMINATION
• Either party may terminate account anytime
• We reserve right to suspend/ban violating accounts
• Terms survive account termination where applicable

10. CONTACT & DISPUTES
• Contact support for questions or concerns
• Disputes resolved through binding arbitration
• These terms governed by applicable local laws

By clicking "I agree," you acknowledge reading and accepting these terms. Stay safe, be respectful, and enjoy connecting with others!

Last updated: ${DateTime.now().year}''',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                // Footer
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF6B46C1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF6B46C1).withOpacity(0.95),
                  const Color(0xFF9333EA).withOpacity(0.95),
                  const Color(0xFFEC4899).withOpacity(0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.shield,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Privacy Policy',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const FaIcon(
                          FontAwesomeIcons.xmark,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '''At Connecta, your privacy is our priority. This policy explains how we collect, use, and protect your information:

INFORMATION WE COLLECT

Personal Information:
• Name, age, email, phone number
• Photos and profile descriptions
• Location data for matching
• Dating preferences and interests

Usage Data:
• App interactions and feature usage
• Message patterns and response times
• Device information and IP address
• Crash reports and performance data

HOW WE USE YOUR INFORMATION

Matching & Discovery:
• Show your profile to potential matches
• Recommend compatible users nearby
• Personalize your dating experience
• Improve matching algorithms

Communication:
• Enable messaging between matches
• Send app notifications and updates
• Provide customer support
• Share safety tips and guidelines

Safety & Security:
• Verify profile authenticity
• Detect and prevent fraudulent activity
• Monitor for inappropriate content
• Investigate reported violations

INFORMATION SHARING

We DO NOT sell your personal data. We may share information:

• With matches you connect with
• When required by law enforcement
• With service providers (encrypted)
• In anonymized form for research

YOUR PRIVACY CONTROLS

Profile Visibility:
• Control who can see your profile
• Choose what information to display
• Hide your profile anytime
• Block specific users

Location Settings:
• Enable/disable location sharing
• Set distance preferences
• Hide precise location details

Data Management:
• Download your data anytime
• Delete specific information
• Permanently delete your account
• Opt out of promotional emails

SAFETY MEASURES

Data Protection:
• End-to-end encryption for messages
• Secure servers and regular backups
• Regular security audits and updates
• Limited employee access to data

Photo Verification:
• AI-powered photo verification
• Human review of reported images
• Automatic detection of fake photos
• Regular profile authenticity checks

AGE VERIFICATION

• All users must be 18+ years old
• Age verification through various methods
• Regular monitoring for underage users
• Immediate account removal if discovered

CONTACT INFORMATION

Privacy Questions: privacy@connecta.com
Data Requests: data@connecta.com
Safety Concerns: safety@connecta.com
General Support: support@connecta.com

POLICY UPDATES

We may update this policy occasionally. You'll be notified of significant changes through the app or email.

Your trust means everything to us. We're committed to protecting your privacy while helping you find meaningful connections.

Last updated: ${DateTime.now().year}''',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                // Footer
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF6B46C1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}