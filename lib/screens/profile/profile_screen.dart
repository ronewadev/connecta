import 'package:flutter/material.dart' hide IconButton;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecta/screens/auth/welcome_screen.dart';
import 'package:connecta/screens/settings/settings_screen.dart';
import 'package:connecta/screens/plans/tokens_screen.dart';
import 'package:connecta/utils/text_strings.dart';
import 'package:connecta/widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 2,
        shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
        leading: IconButton(
          icon:
            FontAwesomeIcons.arrowLeft,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppText.profile,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        centerTitle: true,

      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
              const SizedBox(height: 8), // Reduced space since we have AppBar
              
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(56),
                          image: const DecorationImage(
                            image: NetworkImage('https://i.pravatar.cc/300?img=5'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Jeniffer Chil',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.circle,
                            size: 8,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Online',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildProfileSection(
                context,
                title: AppText.profile,
                items: [
                  _ProfileItem(label: 'Username', value: 'Jeniffer Chil'),
                  _ProfileItem(label: 'Age', value: '23'),
                  _ProfileItem(label: 'Gender', value: 'Female'),
                  _ProfileItem(label: 'Mobile', value: '(+1) 783 467 870'),
                  _ProfileItem(label: 'Nationality', value: 'Japan'),
                ],
              ),
              const SizedBox(height: 24),
              _buildProfileSection(
                context,
                title: 'Linked Accounts',
                items: [],
              ),
              const SizedBox(height: 8),
              _buildSocialLinkSection(context),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.1),
                      theme.colorScheme.secondary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.coins,
                            color: Colors.amber,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Wallet Balance',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '69 Coins',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            text: 'Recharge',
                            icon: FontAwesomeIcons.plus,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  TokensScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SecondaryButton(
                            text: 'Withdraw',
                            icon: FontAwesomeIcons.arrowDown,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  TokensScreen(),
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
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.arrowRightFromBracket,
                      color: Colors.red,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ready to leave?',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We\'ll miss you! You can always come back.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.red.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: AppText.logout,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      width: double.infinity,
                      icon: FontAwesomeIcons.arrowRightFromBracket,
                      onPressed: () => _confirmLogout(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    ])
    );
  }

  Widget _buildProfileSection(BuildContext context, {
    required String title,
    required List<_ProfileItem> items,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FaIcon(
                  FontAwesomeIcons.user,
                  color: theme.colorScheme.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (items.isNotEmpty)
            Column(
              children: items.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        item.label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item.value,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.link,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                    size: 16,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'No linked accounts yet',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
        ]
      )
    );
  }

  Widget _buildSocialLinkSection(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FaIcon(
                  FontAwesomeIcons.share,
                  color: theme.colorScheme.secondary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Link Social Platforms',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SocialPlatformLinkRow(
            icon: FontAwesomeIcons.facebook,
            label: 'Facebook',
            color: Colors.blue,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppText.comingSoon)),
              );
            },
          ),
          _SocialPlatformLinkRow(
            icon: FontAwesomeIcons.twitter,
            label: 'Twitter',
            color: Colors.lightBlue,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppText.comingSoon)),
              );
            },
          ),
          _SocialPlatformLinkRow(
            icon: FontAwesomeIcons.instagram,
            label: 'Instagram',
            color: Colors.pink,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppText.comingSoon)),
              );
            },
          ),
          _SocialPlatformLinkRow(
            icon: FontAwesomeIcons.tiktok,
            label: 'TikTok',
            color: Colors.black,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppText.comingSoon)),
              );
            },
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.triangleExclamation,
              color: Colors.orange,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              AppText.logout,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text('Are you sure you want to logout? You will need to sign in again to access your account.'),
        actions: [
          SecondaryButton(
            text: AppText.cancel,
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          CustomButton(
            text: AppText.logout,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            icon: FontAwesomeIcons.arrowRightFromBracket,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileItem {
  final String label;
  final String value;

  _ProfileItem({required this.label, required this.value});
}

class _SocialPlatformLinkRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _SocialPlatformLinkRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FaIcon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          CustomButton(
            text: 'Link',
            backgroundColor: color,
            textColor: Colors.white,
            height: 36,
            borderRadius: 18,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}