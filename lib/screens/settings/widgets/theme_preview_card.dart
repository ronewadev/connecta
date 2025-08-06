import 'package:flutter/material.dart';
import 'package:connecta/models/theme_model.dart';
import 'package:connecta/screens/plans/widgets/premium_badge.dart';

class ThemePreviewCard extends StatelessWidget {
  final AppTheme theme;
  final bool isSelected;
  final VoidCallback onTap;

  const ThemePreviewCard({
    super.key,
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? theme.primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.primaryColor,
                      theme.secondaryColor,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: 48,
                    color: theme.textColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        theme.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? theme.primaryColor : null,
                        ),
                      ),
                      if (theme.isPremium) ...[
                        const SizedBox(width: 4),
                        const PremiumBadge(type: 'premium'),
                      ],
                    ],
                  ),
                  Text(
                    theme.description,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (theme.cost > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.monetization_on, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${theme.cost} tokens',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}