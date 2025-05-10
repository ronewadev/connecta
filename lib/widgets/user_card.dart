import 'package:flutter/material.dart';
import 'package:connecta/models/user.dart';
import 'package:connecta/widgets/premium_badge.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    user.profileImageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${user.username}, ${user.age}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (user.subscriptionType != 'basic')
                          PremiumBadge(type: user.subscriptionType),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.nationality,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (user.bio != null && user.bio!.isNotEmpty)
                      Text(
                        user.bio!,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: user.interests
                          .map((interest) => Chip(
                        label: Text(interest),
                        backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    '2.5 km away',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}