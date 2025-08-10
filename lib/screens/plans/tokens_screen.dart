import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecta/screens/plans/stream_ads_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide IconButton;
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecta/widgets/custom_button.dart';
import 'package:connecta/utils/text_strings.dart';
import 'package:connecta/models/user_model.dart' as UserModel;
import 'package:firebase_auth/firebase_auth.dart';

import '../../functions/submitCollection.dart';

class TokensScreen extends StatefulWidget {
  const TokensScreen({super.key});

  @override
  State<TokensScreen> createState() => _TokensScreenState();
}

class _TokensScreenState extends State<TokensScreen> {
  UserModel.User? _userData;
  StreamSubscription<DocumentSnapshot>? _userSubscription;
  
  // Token packages from Firestore
  Map<String, Map<String, dynamic>> _tokenPackages = {};
  bool _packagesLoading = true;
  
  // Custom token purchase values
  double _goldTokensSlider = 5.0; // Minimum 5 tokens
  final TextEditingController _customAmountController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _customAmountController.text = _goldTokensSlider.round().toString();
    _initializeUserData();
    _loadTokenPackages();
  }
  
  void _initializeUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Set up real-time listener for current user
      _userSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          setState(() {
            _userData = UserModel.User.fromMap(snapshot.data()!, user.uid);
          });
        }
      });
    }
  }

  Future<void> _loadTokenPackages() async {
    try {
      setState(() {
        _packagesLoading = true;
      });

      // Initialize packages if they don't exist
      //await TokenPackageService.initializeTokenPackages();
      
      // Fetch packages from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('token_packages')
          .where('isActive', isEqualTo: true)
          .get();

      final Map<String, Map<String, dynamic>> packages = {};
      
      for (var doc in snapshot.docs) {
        packages[doc.id] = {
          'id': doc.id,
          ...doc.data(),
        };
      }

      if (mounted) {
        setState(() {
          _tokenPackages = packages;
          _packagesLoading = false;
        });
      }
    } catch (e) {
      print('Error loading token packages: $e');
      if (mounted) {
        setState(() {
          _packagesLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    _customAmountController.dispose();
    super.dispose();
  }
  
  // Calculate silver tokens (2x for every 5 gold tokens)
  int get _calculatedSilverTokens {
    final goldTokens = _goldTokensSlider.round();
    return (goldTokens ~/ 5) * 10 + (goldTokens % 5) * 2;
  }
  
  // Calculate price based on gold tokens using custom pack pricing from Firestore
  double get _calculatedPrice {
    final customPack = _tokenPackages['customTokenPack'];
    if (customPack != null) {
      final pricePerGold = (customPack['pricePerGold'] as num?)?.toDouble() ?? 0.50;
      final pricePerSilver = (customPack['pricePerSilver'] as num?)?.toDouble() ?? 0.05;
      return (_goldTokensSlider.round() * pricePerGold) + (_calculatedSilverTokens * pricePerSilver);
    }
    return _goldTokensSlider.round() * 0.99; // Fallback
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Dynamic token values from user data
    final goldTokens = _userData?.goldTokens ?? 0;
    final silverTokens = _userData?.silverTokens ?? 0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 2,
        shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
        leading: IconButton(
          icon:  FontAwesomeIcons.arrowLeft,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tokens & Balance',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: _userData == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              ),
            )
          : CustomScrollView(
        slivers: [
          // Header Section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.withOpacity(0.8),
                    Colors.orange.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.coins,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Your Token Balance',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Manage your tokens and unlock premium features',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Token Balance Cards
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: _buildTokenCard(
                      context,
                      title: 'Gold Tokens',
                      amount: goldTokens,
                      icon: FontAwesomeIcons.star,
                      color: Colors.amber,
                      description: 'Premium features',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTokenCard(
                      context,
                      title: 'Silver Tokens',
                      amount: silverTokens,
                      icon: FontAwesomeIcons.coins,
                      color: Colors.grey.shade600,
                      description: 'Standard features',
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),

          // Token Purchase Packages
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Buy Token Packages',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (_packagesLoading)
                  Container(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading token packages...',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  // Dynamic packages from Firestore
                  if (_tokenPackages.containsKey('starterPack'))
                    _buildDynamicTokenPackage(
                      context,
                      packageData: _tokenPackages['starterPack']!,
                      color: Colors.blue,
                      isPopular: false,
                    ),
                  const SizedBox(height: 16),
                  if (_tokenPackages.containsKey('popularPack'))
                    _buildDynamicTokenPackage(
                      context,
                      packageData: _tokenPackages['popularPack']!,
                      color: Colors.purple,
                      isPopular: true,
                    ),
                  const SizedBox(height: 16),
                  if (_tokenPackages.containsKey('premiumPack'))
                    _buildDynamicTokenPackage(
                      context,
                      packageData: _tokenPackages['premiumPack']!,
                      color: Colors.amber,
                      isPopular: false,
                    ),
                ],
                const SizedBox(height: 32),
                // Custom Token Purchase Section
                _buildCustomTokenPurchase(context),
                const SizedBox(height: 32),
                Text(
                  'Earn Free Tokens',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildEarnTokenOption(
                  context,
                  icon: FontAwesomeIcons.video,
                  title: 'Watch Ads',
                  description: 'Earn silver tokens per ad',
                  reward:'5+ Silver',
                  onPressed: () {
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) => const StreamAdsScreen(),
                     ),
                   );
                  },
                ),
                const SizedBox(height: 12),
                _buildEarnTokenOption(
                  context,
                  icon: FontAwesomeIcons.userCheck,
                  title: 'Daily Check-in',
                  description: 'Login daily to earn tokens',
                  reward: '+10 Silver',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppText.comingSoon)),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildEarnTokenOption(
                  context,
                  icon: FontAwesomeIcons.share,
                  title: 'Invite Friends',
                  description: 'Get tokens for each friend you invite',
                  reward: '+2 Gold',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppText.comingSoon)),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenCard(
    BuildContext context, {
    required String title,
    required int amount,
    required IconData icon,
    required Color color,
    required String description,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: FaIcon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$amount',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicTokenPackage(
    BuildContext context, {
    required Map<String, dynamic> packageData,
    required Color color,
    required bool isPopular,
  }) {
    final theme = Theme.of(context);
    
    final name = packageData['name'] as String? ?? 'Token Package';
    final goldTokens = packageData['goldCoins'] as int? ?? 0;
    final silverTokens = packageData['silverCoins'] as int? ?? 0;
    final price = packageData['price'] as double? ?? 0.0;
    final currency = packageData['currency'] as String? ?? 'USD';
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isPopular 
              ? [color.withAlpha(10), color.withAlpha(90)]
              : [Colors.white, Colors.grey.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isPopular ? color : Colors.grey.shade300,
          width: isPopular ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isPopular 
                ? color.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: isPopular ? 15 : 10,
            offset: Offset(0, isPopular ? 8 : 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (isPopular)
            Positioned(
              top: 0,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  'POPULAR',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.boxOpen,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currency == 'USD' ? '\$${price.toStringAsFixed(2)}' : '$price $currency',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
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
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$goldTokens Gold',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.coins,
                              color: Colors.grey.shade600,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$silverTokens Silver',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _showPurchaseDialog(context, packageData);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.creditCard,
                            size: 16,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Purchase $name',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, Map<String, dynamic> packageData) {
    final theme = Theme.of(context);
    final name = packageData['name'] as String? ?? 'Token Package';
    final goldTokens = packageData['goldCoins'] as int? ?? 0;
    final silverTokens = packageData['silverCoins'] as int? ?? 0;
    final price = packageData['price'] as double? ?? 0.0;
    final currency = packageData['currency'] as String? ?? 'USD';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.indigo],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const FaIcon(
                FontAwesomeIcons.shoppingCart,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Confirm Purchase',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Gold Tokens:', style: theme.textTheme.bodyMedium),
                      Text(
                        '$goldTokens',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Silver Tokens:', style: theme.textTheme.bodyMedium),
                      Text(
                        '$silverTokens',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Price:',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        currency == 'USD' ? '\$${price.toStringAsFixed(2)}' : '$price $currency',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.indigo],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Purchase feature coming soon!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text(
                'Purchase',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
            );
  }

  Widget _buildEarnTokenOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String reward,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FaIcon(
              icon,
              color: Colors.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              reward,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: onPressed,
            icon:
              FontAwesomeIcons.chevronRight,

          ),
        ],
      ),
    );
  }

  Widget _buildCustomTokenPurchase(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.withOpacity(0.1),
            Colors.indigo.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.deepPurple.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.indigo],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.sliders,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Token Pack',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Text(
                      'Choose your perfect amount',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.deepPurple.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'CUSTOM',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Token Display Cards
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
                      const FaIcon(
                        FontAwesomeIcons.star,
                        color: Colors.amber,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_goldTokensSlider.round()}',
                        style: theme.textTheme.headlineMedium?.copyWith(
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
              const SizedBox(width: 16),
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
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_calculatedSilverTokens',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        'Silver Tokens',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Custom Amount Input
          Text(
            'Gold Tokens Amount',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
                  ),
                  child: TextField(
                    controller: _customAmountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter amount',
                    ),
                    onChanged: (value) {
                      final amount = int.tryParse(value) ?? 5;
                      if (amount >= 5 && amount <= 1000) {
                        setState(() {
                          _goldTokensSlider = amount.toDouble();
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total: \$${_calculatedPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Text(
                      '\$${(_calculatedPrice / _goldTokensSlider.round()).toStringAsFixed(2)} per gold token',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.deepPurple.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Drag Bar / Slider
          Text(
            'Drag to adjust amount (5 - 1000 tokens)',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    activeTrackColor: Colors.deepPurple,
                    inactiveTrackColor: Colors.deepPurple.withOpacity(0.3),
                    thumbColor: Colors.deepPurple,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 12,
                    ),
                    overlayColor: Colors.deepPurple.withOpacity(0.2),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 20,
                    ),
                    valueIndicatorColor: Colors.deepPurple,
                    valueIndicatorTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Slider(
                    value: _goldTokensSlider,
                    min: 5,
                    max: 1000,
                    divisions: 199, // (1000-5)/5 = 199 divisions for increments of 5
                    label: '${_goldTokensSlider.round()} Gold',
                    onChanged: (value) {
                      setState(() {
                        _goldTokensSlider = value;
                        _customAmountController.text = value.round().toString();
                      });
                      HapticFeedback.lightImpact();
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '5',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '1000',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Bonus Information
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.gift,
                  color: Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Bonus: For every 5 Gold tokens, get 2x bonus Silver tokens (10 Silver tokens)',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Purchase Button
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.indigo],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: () {
                  _showCustomPurchaseDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.shoppingCart,
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Buy ${_goldTokensSlider.round()} Gold + $_calculatedSilverTokens Silver',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomPurchaseDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.indigo],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const FaIcon(
                FontAwesomeIcons.shoppingCart,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Confirm Purchase',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Gold Tokens:', style: theme.textTheme.bodyMedium),
                      Text(
                        '${_goldTokensSlider.round()}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Silver Tokens:', style: theme.textTheme.bodyMedium),
                      Text(
                        '$_calculatedSilverTokens',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Price:',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${_calculatedPrice.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.indigo],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Purchase feature coming soon!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text(
                'Purchase',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}