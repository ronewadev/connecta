import 'package:flutter/material.dart';

import '../../models/user_model.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool _isCalling = false;
  User? _matchedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orangeAccent, Colors.pink],
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
                        FloatingActionButton(
                          heroTag: 'mute',
                          onPressed: () {},
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: const Icon(Icons.mic_off, color: Colors.white),
                        ),
                        const SizedBox(width: 20),
                        FloatingActionButton(
                          heroTag: 'end',
                          onPressed: _endCall,
                          backgroundColor: Colors.red,
                          child: const Icon(Icons.call_end, color: Colors.white),
                        ),
                        const SizedBox(width: 20),
                        FloatingActionButton(
                          heroTag: 'switch',
                          onPressed: () {},
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: const Icon(Icons.cameraswitch, color: Colors.white),
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
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.video_call,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Ready to Connect?',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Find someone interesting to video chat with',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _startRandomCall,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                       // foregroundColor: const Color(0xFF6A11CB),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Start Random Call',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
      _matchedUser = User(
        id: 'call-1',
        username: 'Ron',
        age: 26,
        gender: 'Male',
        nationality: 'RSA',
        profileImageUrl: 'https://i.pravatar.cc/300?img=32',
        email: 'ro@gmail.com',
        name: 'Ronewa Lovers Muthivhi',
        location: 'Gondeni',
      );
    });
  }

  void _endCall() {
    setState(() {
      _isCalling = false;
      _matchedUser = null;
    });
  }
}