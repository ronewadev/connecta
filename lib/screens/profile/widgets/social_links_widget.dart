import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLinkContent extends StatefulWidget {
  final Map<String, bool> initialSocialMediaStatus;
  final Future<bool> Function(String platform, bool isLinked, [String? link])
  onUpdateSocialMediaLink;

  const SocialLinkContent({
    Key? key,
    required this.initialSocialMediaStatus,
    required this.onUpdateSocialMediaLink,
  }) : super(key: key);

  @override
  State<SocialLinkContent> createState() => _SocialLinkContentState();
}

class _SocialLinkContentState extends State<SocialLinkContent> {
  late Map<String, bool> _socialMediaStatus;

  @override
  void initState() {
    super.initState();
    _socialMediaStatus = Map.from(widget.initialSocialMediaStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SocialPlatformLinkRow(
          icon: FontAwesomeIcons.facebook,
          label: 'Facebook',
          color: Colors.blue,
          isLinked: _socialMediaStatus['facebook'] ?? false,
          onPressed: () => _handleSocialMediaToggle('facebook'),
        ),
        _SocialPlatformLinkRow(
          icon: FontAwesomeIcons.xTwitter,
          label: 'X',
          color: Colors.black,
          isLinked: _socialMediaStatus['x'] ?? false,
          onPressed: () => _handleSocialMediaToggle('x'),
        ),
        _SocialPlatformLinkRow(
          icon: FontAwesomeIcons.instagram,
          label: 'Instagram',
          color: Colors.pink,
          isLinked: _socialMediaStatus['instagram'] ?? false,
          onPressed: () => _handleSocialMediaToggle('instagram'),
        ),
        _SocialPlatformLinkRow(
          icon: FontAwesomeIcons.tiktok,
          label: 'TikTok',
          color: Colors.black,
          isLinked: _socialMediaStatus['tiktok'] ?? false,
          onPressed: () => _handleSocialMediaToggle('tiktok'),
        ),
        _SocialPlatformLinkRow(
          icon: FontAwesomeIcons.whatsapp,
          label: 'WhatsApp',
          color: Colors.green,
          isLinked: _socialMediaStatus['whatsapp'] ?? false,
          onPressed: () => _handleSocialMediaToggle('whatsapp'),
        ),
      ],
    );
  }

  void _handleSocialMediaToggle(String platform) {
    final isCurrentlyLinked = _socialMediaStatus[platform] ?? false;

    if (isCurrentlyLinked) {
      _showUnlinkConfirmDialog(platform);
    } else {
      _showLinkDialog(platform);
    }
  }

  void _showLinkDialog(String platform) {
    final controller = TextEditingController();
    String hint = '';
    String example = '';

    switch (platform) {
      case 'facebook':
        hint = 'Enter your Facebook profile URL';
        example = 'facebook.com/username';
        break;
      case 'instagram':
        hint = 'Enter your Instagram username';
        example = '@username';
        break;
      case 'x':
        hint = 'Enter your X (Twitter) handle';
        example = '@username';
        break;
      case 'tiktok':
        hint = 'Enter your TikTok username';
        example = '@username';
        break;
      case 'whatsapp':
        hint = 'Enter your WhatsApp number';
        example = '+1234567890';
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            FaIcon(_getPlatformIcon(platform),
                color: _getPlatformColor(platform),
                size: 24),
            const SizedBox(width: 12),
            Text('Link ${_capitalizeFirstLetter(platform)}'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                labelText: example,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final link = controller.text.trim();
              if (link.isNotEmpty) {
                final success = await widget.onUpdateSocialMediaLink(
                  platform,
                  true,
                  link,
                );

                if (success) {
                  setState(() {
                    _socialMediaStatus[platform] = true;
                  });
                  Navigator.pop(context);
                  _showSnackBar(
                    '${_capitalizeFirstLetter(platform)} linked successfully!',
                    Colors.green,
                  );
                } else {
                  _showSnackBar(
                    'Failed to link ${_capitalizeFirstLetter(platform)}',
                    Colors.red,
                  );
                }
              }
            },
            child: const Text('Link'),
          ),
        ],
      ),
    );
  }

  void _showUnlinkConfirmDialog(String platform) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const FaIcon(FontAwesomeIcons.unlink, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Text('Unlink ${_capitalizeFirstLetter(platform)}'),
          ],
        ),
        content: Text(
          'Are you sure you want to unlink your ${_capitalizeFirstLetter(platform)} account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await widget.onUpdateSocialMediaLink(
                platform,
                false,
              );

              if (success) {
                setState(() {
                  _socialMediaStatus[platform] = false;
                });
                Navigator.pop(context);
                _showSnackBar(
                  '${_capitalizeFirstLetter(platform)} unlinked successfully!',
                  Colors.orange,
                );
              } else {
                _showSnackBar(
                  'Failed to unlink ${_capitalizeFirstLetter(platform)}',
                  Colors.red,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Unlink', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  String _capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  IconData _getPlatformIcon(String platform) {
    switch (platform) {
      case 'facebook': return FontAwesomeIcons.facebook;
      case 'instagram': return FontAwesomeIcons.instagram;
      case 'x': return FontAwesomeIcons.xTwitter;
      case 'tiktok': return FontAwesomeIcons.tiktok;
      case 'whatsapp': return FontAwesomeIcons.whatsapp;
      default: return FontAwesomeIcons.link;
    }
  }

  Color _getPlatformColor(String platform) {
    switch (platform) {
      case 'facebook': return Colors.blue;
      case 'instagram': return Colors.pink;
      case 'x': return Colors.black;
      case 'tiktok': return Colors.black;
      case 'whatsapp': return Colors.green;
      default: return Colors.grey;
    }
  }
}

class _SocialPlatformLinkRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final bool isLinked;

  const _SocialPlatformLinkRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    required this.isLinked,
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
          color: isLinked ? Colors.green.withOpacity(0.3) : color.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isLinked ? Colors.green : color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FaIcon(
              icon,
              color: isLinked ? Colors.green : color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isLinked)
                  Text(
                    'Connected',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isLinked ? Colors.red : color,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(
              isLinked ? 'Unlink' : 'Link',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}