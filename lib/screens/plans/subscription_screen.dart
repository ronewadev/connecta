import 'dart:async';
import 'package:connecta/services/subscriptions/subscription_services.dart';
import 'package:connecta/screens/plans/tokens_screen.dart';
import 'package:connecta/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:connecta/widgets/custom_button.dart';
import 'package:connecta/screens/plans/widgets/premium_badge.dart';
import 'package:connecta/database/user_database.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final UserDatabase _userDatabase = UserDatabase();
  UserData? _userData;
  StreamSubscription<UserData?>? _userDataSubscription;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() async {
    // Get current cached data immediately
    _userData = _userDatabase.currentUserData;
    if (_userData != null) {
      setState(() {});
    }
    
    // Initialize UserDatabase (this will set up real-time listener)
    await _userDatabase.initializeUserData();
    
    // Listen to user data changes
    _userDataSubscription = _userDatabase.userDataStream.listen((userData) {
      if (mounted) {
        setState(() {
          _userData = userData;
        });
      }
    });
  }

  @override
  void dispose() {
    _userDataSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionService = Provider.of<SubscriptionService>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentSubscription = _userData?.subscriptionType ?? subscriptionService.subscriptionType;
    final theme = Theme.of(context);

    // Dynamic token values from user data
    final goldTokens = _userData?.goldTokens ?? 0;
    final silverTokens = _userData?.silverTokens ?? 0;

    return AnimatedTheme(
      duration: const Duration(milliseconds: 500),
      data: theme,
      child: CustomScrollView(
        slivers: [
          // Header Section
          SliverToBoxAdapter(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeProvider.currentThemeColor.withOpacity(0.8),
                    themeProvider.currentThemeColor.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: themeProvider.currentThemeColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.crown,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ) ?? const TextStyle(),
                    child: const Text('Choose Your Plan'),
                  ),
                  const SizedBox(height: 12),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ) ?? const TextStyle(),
                    child: const Text(
                      'Unlock premium features and enhance your dating experience with unlimited possibilities',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tokens Balance Section
          SliverToBoxAdapter(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.1),
                    Colors.orange.withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.amber.withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.coins,
                        color: Colors.amber,
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
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ) ?? const TextStyle(),
                            child: const Text('Token Balance'),
                          ),
                          const SizedBox(height: 4),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ) ?? const TextStyle(),
                            child: const Text('Use tokens for premium features'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _userData == null ? 'Loading...' : '$goldTokens',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                            Text(
                              'Gold Tokens',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.amber.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.coins,
                              color: Colors.grey.shade600,
                              size: 20,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _userData == null ? 'Loading...' : '$silverTokens',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Text(
                              'Silver Tokens',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Buy Tokens',
                        backgroundColor: Colors.amber,
                        textColor: Colors.white,
                        icon: FontAwesomeIcons.plus,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TokensScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SecondaryButton(
                        text: 'View History',
                        icon: FontAwesomeIcons.clockRotateLeft,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TokensScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
        // Subscription Plans
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildSubscriptionCard(
                context,
                themeProvider,
                title: 'Basic',
                price: 'Free',
                description: 'Perfect for getting started',
                features: const [
                  'Limited daily matches',
                  'Basic filters',
                  'Earn silver tokens',
                  'Standard support',
                ],
                isCurrent: currentSubscription == 'basic',
                isPremium: false,
                gradientColors: [Colors.grey.shade300, Colors.grey.shade500],
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              _buildSubscriptionCard(
                context,
                themeProvider,
                title: 'Premium',
                price: '\$19.99/month',
                description: 'Most popular choice',
                features: const [
                  'Unlimited matches',
                  'Unlimited super likes',
                  'Advanced filters',
                  'See who liked you',
                  'Profile highlighting',
                  '5 linked social media messages per month',
                  '15 direct messages per month',
                  '20 gold tokens monthly',
                  '100 silver tokens monthly',
                  'Premium Gold badge',
                ],
                isCurrent: currentSubscription == 'premium',
                isPremium: true,
                gradientColors: [Colors.amber.shade400, Colors.orange.shade600],
                onPressed: () {
                  subscriptionService.subscribe('premium', const Duration(days: 30));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Premium subscription activated!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildSubscriptionCard(
                context,
                themeProvider,
                title: 'Elite',
                price: '\$49.99/month',
                description: 'For the truly dedicated',
                features: const [
                  'All Premium features',
                  'Unlimited returns',
                  'Unlimited live streams',
                  'Priority placement',
                  'Profile boost (3x per month)',
                  'Exclusive themes',
                  'Unlimited direct messages',
                  '15 linked social media messages per month',
                  '50 gold tokens monthly',
                  '200 silver tokens monthly',
                  'Priority customer support',
                  'Read receipts',
                  'Elite Diamond badge',
                ],
                isCurrent: currentSubscription == 'elite',
                isPremium: true,
                gradientColors: [Colors.cyanAccent.shade400, Colors.lightBlueAccent.shade700],
                onPressed: () {
                  subscriptionService.subscribe('elite', const Duration(days: 30));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Elite subscription activated!'),
                      backgroundColor: Colors.pink,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildSubscriptionCard(
                context,
                themeProvider,
                title: 'Infinity',
                price: '\$99.99/month',
                description: 'Ultimate dating experience',
                features: const [
                  'All Elite features',
                  'Unlimited profile boosts',
                  'Unlimited linked social media messages',
                  'Exclusive views & filters',
                  'Advanced analytics & insights',
                  'Exclusive events access',
                  'Personal dating coach consultation',
                  'VIP customer support',
                  'Profile verification priority',
                  'Custom themes & animations',
                  'Video call features',
                  '100 gold tokens monthly',
                  '500 silver tokens monthly',
                  'Travel mode',
                  'Incognito browsing',
                  'Infinity badge',
                ],
                isCurrent: currentSubscription == 'infinity',
                isPremium: true,
                gradientColors: [Colors.deepPurple.shade600, Colors.purpleAccent.shade400],
                onPressed: () {
                  subscriptionService.subscribe('infinity', const Duration(days: 30));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Infinity subscription activated!'),
                      backgroundColor: Colors.amber,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Current Status Card
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: currentSubscription == 'basic'
                        ? [themeProvider.currentThemeColor.withOpacity(0.1), themeProvider.currentThemeColor.withOpacity(0.1)]
                        : [Colors.green.withOpacity(0.1), Colors.teal.withOpacity(0.1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: currentSubscription == 'basic' 
                        ? themeProvider.currentThemeColor.withOpacity(0.3)
                        : Colors.green.withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: currentSubscription == 'basic'
                          ? themeProvider.currentThemeColor.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: currentSubscription == 'basic'
                            ? themeProvider.currentThemeColor.withOpacity(0.2)
                            : Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FaIcon(
                        currentSubscription == 'basic' 
                          ? FontAwesomeIcons.arrowUp
                          : FontAwesomeIcons.checkCircle,
                        color: currentSubscription == 'basic'
                            ? themeProvider.currentThemeColor
                            : Colors.green,
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
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: currentSubscription == 'basic'
                                  ? themeProvider.currentThemeColor
                                  : Colors.green,
                            ) ?? const TextStyle(),
                            child: Text(
                              currentSubscription == 'basic'
                                  ? 'Ready to Upgrade?'
                                  : 'Active Subscription',
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.8),
                            ) ?? const TextStyle(),
                            child: Text(
                              currentSubscription == 'basic'
                                  ? 'Unlock premium features now!'
                                  : 'Your current plan: ${currentSubscription.toUpperCase()}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ]),
          ),
        ),
      ],
    ),
    );
  }

  Widget _buildSubscriptionCard(
    BuildContext context,
    ThemeProvider themeProvider, {
    required String title,
    required String price,
    required String description,
    required List<String> features,
    required bool isCurrent,
    required bool isPremium,
    required List<Color> gradientColors,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isCurrent 
              ? [gradientColors[0].withOpacity(0.3), gradientColors[1].withOpacity(0.3)]
              : theme.brightness == Brightness.dark
                  ? [const Color(0xFF2A2A2A), const Color(0xFF3A3A3A)]
                  : [Colors.white, Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isCurrent 
              ? gradientColors[1] 
              : theme.brightness == Brightness.dark
                  ? themeProvider.currentThemeColor.withOpacity(0.3)
                  : Colors.grey.shade300,
          width: isCurrent ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isCurrent 
                ? gradientColors[1].withOpacity(0.3)
                : themeProvider.currentThemeColor.withOpacity(0.1),
            blurRadius: isCurrent ? 20 : 10,
            offset: Offset(0, isCurrent ? 10 : 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Builder(
                    builder: (context) {
                      if (title == 'Infinity') {
                        return FaIcon(
                          FontAwesomeIcons.infinity,
                          color: Colors.white,
                          size: 28,
                        );
                      } else if (title == 'Elite') {
                        return FaIcon(
                          FontAwesomeIcons.gem,
                          color: Colors.white,
                          size: 24,
                        );
                      } else if (isPremium) {
                        return FaIcon(
                          FontAwesomeIcons.crown,
                          color: Colors.white,
                          size: 24,
                        );
                      } else {
                        return FaIcon(
                          FontAwesomeIcons.user,
                          color: Colors.white,
                          size: 24,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ) ?? const TextStyle(),
                            child: Text(title),
                          ),
                          if (title == 'Infinity') ...[
                            const SizedBox(width: 8),
                            const PremiumBadge(type: 'infinity')
                          ] else if (title == 'Elite') ...[
                            const SizedBox(width: 8),
                            const PremiumBadge(type: 'diamond')
                          ] else if (title == 'Premium') ...[
                            const SizedBox(width: 8),
                            const PremiumBadge(type: 'gold')
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ) ?? const TextStyle(),
                        child: Text(description),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors.map((c) => c.withOpacity(0.1)).toList(),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: gradientColors[1],
                  fontWeight: FontWeight.bold,
                ) ?? const TextStyle(),
                child: Text(price),
              ),
            ),
            const SizedBox(height: 20),
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.check,
                          size: 12,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ) ?? const TextStyle(),
                          child: Text(feature),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  gradient: isCurrent 
                      ? null 
                      : LinearGradient(colors: gradientColors),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  onPressed: isCurrent ? null : onPressed,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: isCurrent
                        ? theme.colorScheme.surfaceVariant
                        : Colors.transparent,
                    foregroundColor: isCurrent
                        ? theme.colorScheme.onSurfaceVariant
                        : Colors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        isCurrent 
                          ? FontAwesomeIcons.check
                          : FontAwesomeIcons.arrowUp,
                        size: 16,
                      ),
                      const SizedBox(width: 12),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        child: Text(
                          isCurrent ? 'Current Plan' : 'Upgrade Now',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}