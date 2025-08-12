import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialMediaChip extends StatelessWidget {
  final String socialLink;

  const SocialMediaChip({
    Key? key,
    required this.socialLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parts = socialLink.split(':');
    final username = parts.length > 1 ? parts[1] : '';
    final icon = _getSocialMediaIcon(socialLink);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 8),
          Text(
            username.startsWith('@') ? username : '@$username',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Get small icon for chip
  Widget _getSocialMediaIcon(String link) {
    final platform = link.split(':')[0].toLowerCase();
    IconData icon;
    Color color;

    switch (platform) {
      case 'instagram':
        icon = FontAwesomeIcons.instagram;
        color = const Color(0xFFE4405F);
        break;
      case 'facebook':
        icon = FontAwesomeIcons.facebook;
        color = const Color(0xFF1877F2);
        break;
      case 'whatsapp':
        icon = FontAwesomeIcons.whatsapp;
        color = const Color(0xFF25D366);
        break;
      case 'tiktok':
        icon = FontAwesomeIcons.tiktok;
        color = Colors.black;
        break;
      case 'spotify':
        icon = FontAwesomeIcons.spotify;
        color = const Color(0xFF1DB954);
        break;
      case 'youtube':
        icon = FontAwesomeIcons.youtube;
        color = const Color(0xFFFF0000);
        break;
      case 'linkedin':
        icon = FontAwesomeIcons.linkedin;
        color = const Color(0xFF0077B5);
        break;
      case 'twitter':
        icon = FontAwesomeIcons.twitter;
        color = const Color(0xFF1DA1F2);
        break;
      case 'behance':
        icon = FontAwesomeIcons.behance;
        color = const Color(0xFF1769FF);
        break;
      case 'pinterest':
        icon = FontAwesomeIcons.pinterest;
        color = const Color(0xFFBD081C);
        break;
      case 'strava':
        icon = FontAwesomeIcons.strava;
        color = const Color(0xFFFC4C02);
        break;
      default:
        icon = FontAwesomeIcons.link;
        color = Colors.grey;
    }

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: FaIcon(
          icon,
          size: 9,
          color: Colors.white,
        ),
      ),
    );
  }
}
