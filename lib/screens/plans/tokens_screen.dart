import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide IconButton;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecta/widgets/custom_button.dart';
import 'package:connecta/utils/text_strings.dart';

class TokensScreen extends StatelessWidget {
  const TokensScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Static token values for display
    const goldTokens = 15;
    const silverTokens = 69;

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
      body: CustomScrollView(
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
                _buildTokenPackage(
                  context,
                  title: 'Starter Pack',
                  goldTokens: 10,
                  silverTokens: 50,
                  price: '\$4.99',
                  color: Colors.blue,
                  isPopular: false,
                ),
                const SizedBox(height: 16),
                _buildTokenPackage(
                  context,
                  title: 'Popular Pack',
                  goldTokens: 25,
                  silverTokens: 100,
                  price: '\$9.99',
                  color: Colors.purple,
                  isPopular: true,
                ),
                const SizedBox(height: 16),
                _buildTokenPackage(
                  context,
                  title: 'Premium Pack',
                  goldTokens: 60,
                  silverTokens: 200,
                  price: '\$19.99',
                  color: Colors.amber,
                  isPopular: false,
                ),
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
                  description: 'Earn 5 silver tokens per ad',
                  reward: '+5 Silver',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppText.comingSoon)),
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

  Widget _buildTokenPackage(
    BuildContext context, {
    required String title,
    required int goldTokens,
    required int silverTokens,
    required String price,
    required Color color,
    required bool isPopular,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isPopular 
              ? [color.withOpacity(0.1), color.withOpacity(0.05)]
              : [Colors.white, Colors.grey.shade50],
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
                            title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            price,
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Purchase feature coming soon!'),
                            backgroundColor: Colors.green,
                          ),
                        );
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
                            'Purchase $title',
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
}