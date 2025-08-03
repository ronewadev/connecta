import 'package:connecta/services/subscriptions/token_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TokensScreen extends StatelessWidget {
  const TokensScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokenService = Provider.of<TokenService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tokens'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Your Balance',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTokenBadge(
                          'Gold',
                          tokenService.goldTokens,
                          Colors.amber,
                        ),
                        const SizedBox(width: 20),
                        _buildTokenBadge(
                          'Silver',
                          tokenService.silverTokens,
                          Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Earn Silver Tokens',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildEarnTokenOption(
              icon: Icons.video_library,
              title: 'Watch Ads',
              description: 'Earn 5 silver tokens per ad',
              onTap: () {
                tokenService.earnSilverTokens(5);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('+5 Silver Tokens!')),
                );
              },
            ),
            _buildEarnTokenOption(
              icon: Icons.person_add,
              title: 'Invite Friends',
              description: 'Get 20 silver tokens per friend',
              onTap: () {
                // Implement referral logic
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Buy Gold Tokens',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildTokenPurchaseOption(
                  amount: 10,
                  price: '\$1.99',
                  onTap: () {
                    tokenService.buyGoldTokens(10);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('+10 Gold Tokens!')),
                    );
                  },
                ),
                _buildTokenPurchaseOption(
                  amount: 30,
                  price: '\$4.99',
                  onTap: () {
                    tokenService.buyGoldTokens(30);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('+30 Gold Tokens!')),
                    );
                  },
                ),
                _buildTokenPurchaseOption(
                  amount: 60,
                  price: '\$8.99',
                  onTap: () {
                    tokenService.buyGoldTokens(60);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('+60 Gold Tokens!')),
                    );
                  },
                ),
                _buildTokenPurchaseOption(
                  amount: 100,
                  price: '\$14.99',
                  onTap: () {
                    tokenService.buyGoldTokens(100);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('+100 Gold Tokens!')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenBadge(String type, int amount, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(
            Icons.monetization_on,
            color: color,
            size: 30,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$amount',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          type,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildEarnTokenOption({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildTokenPurchaseOption({
    required int amount,
    required String price,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.monetization_on, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    '$amount',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                price,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}