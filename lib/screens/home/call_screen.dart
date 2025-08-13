import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecta/models/user_model.dart';
import 'package:connecta/utils/text_strings.dart';
import 'package:connecta/widgets/custom_button.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool _isCalling = false;
  UserModelInfo? _matchedUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(0.8),
              theme.colorScheme.secondary.withOpacity(0.8),
              theme.colorScheme.tertiary?.withOpacity(0.8) ?? theme.colorScheme.primary.withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isCalling && _matchedUser != null)
                Column(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        image: DecorationImage(
                          image: NetworkImage(_matchedUser!.profileImageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Calling ${_matchedUser!.username}...',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCallActionButton(
                          icon: FontAwesomeIcons.microphoneSlash,
                          color: Colors.white.withOpacity(0.3),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(AppText.comingSoon)),
                            );
                          },
                        ),
                        const SizedBox(width: 20),
                        _buildCallActionButton(
                          icon: FontAwesomeIcons.phoneSlash,
                          color: Colors.red,
                          size: 65,
                          onPressed: _endCall,
                        ),
                        const SizedBox(width: 20),
                        _buildCallActionButton(
                          icon: FontAwesomeIcons.arrowRightArrowLeft,
                          color: Colors.white.withOpacity(0.3),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(AppText.comingSoon)),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.2),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.video,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Ready to Connect?',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Find someone interesting to video chat with',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 48),
                    PrimaryButton(
                      text: 'Start Random Call',
                      icon: FontAwesomeIcons.video,
                      width: 250,
                      onPressed: _startRandomCall,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _startRandomCall() {
    setState(() {
      _isCalling = true;
      _matchedUser = UserModelInfo(
        id: _matchedUser!.id,
        username: _matchedUser!.username,
        age: _matchedUser!.age,
        gender: _matchedUser!.gender,
        nationality: _matchedUser!.nationality,
        profileImageUrl: _matchedUser!.profileImageUrl,
        email: _matchedUser!.email,
        location: _matchedUser!.location, //gotta re adjust this later
      );
    });
  }

  void _endCall() {
    setState(() {
      _isCalling = false;
      _matchedUser = null;
    });
  }

  Widget _buildCallActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    double size = 55,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          onTap: onPressed,
          child: Center(
            child: FaIcon(
              icon,
              color: Colors.white,
              size: size * 0.4,
            ),
          ),
        ),
      ),
    );
  }
}