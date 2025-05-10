import 'package:connecta/services/subscriptions/subscription_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connecta/widgets/premium_badge.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subscriptionService = Provider.of<SubscriptionService>(context);
    final currentSubscription = subscriptionService.subscriptionType;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSubscriptionCard(
              context,
              title: 'Basic',
              price: 'Free',
              features: const [
                'Limited daily matches',
                'Basic filters',
                'Earn silver tokens',
              ],
              isCurrent: currentSubscription == 'basic',
              isPremium: false,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            _buildSubscriptionCard(
              context,
              title: 'Premium',
              price: '\$9.99/month',
              features: const [
                'Unlimited matches',
                'Advanced filters',
                'See who liked you',
                'Priority placement',
                '5 gold tokens monthly',
              ],
              isCurrent: currentSubscription == 'premium',
              isPremium: true,
              onPressed: () {
                subscriptionService.subscribe('premium', const Duration(days: 30));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Premium subscription activated!')),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildSubscriptionCard(
              context,
              title: 'Infinity',
              price: '\$29.99/month',
              features: const [
                'All Premium features',
                'Unlimited gold tokens',
                'Profile highlighting',
                'Exclusive themes',
                'Priority customer support',
              ],
              isCurrent: currentSubscription == 'infinity',
              isPremium: true,
              onPressed: () {
                subscriptionService.subscribe('infinity', const Duration(days: 30));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Infinity subscription activated!')),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              currentSubscription == 'basic'
                  ? 'Upgrade to unlock all features!'
                  : 'Your current plan: ${currentSubscription.toUpperCase()}',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(
    BuildContext context, {
    required String title,
    required String price,
    required List<String> features,
    required bool isCurrent,
    required bool isPremium,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isCurrent
            ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isPremium) const SizedBox(width: 8),
                if (isPremium) const PremiumBadge(type: 'premium'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(child: Text(feature)),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isCurrent ? null : onPressed,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: isCurrent
                    ? Colors.grey
                    : Theme.of(context).primaryColor,
              ),
              child: Text(
                isCurrent ? 'Current Plan' : 'Upgrade Now',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}