import 'package:flutter/material.dart';
import 'package:connecta/models/user.dart';
import 'package:connecta/models/call_session.dart';

class CallService with ChangeNotifier {
  CallSession? _currentCall;
  bool _isInCall = false;

  CallSession? get currentCall => _currentCall;
  bool get isInCall => _isInCall;

  Future<void> startCall(User otherUser) async {
    _currentCall = CallSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      caller: otherUser,
      startTime: DateTime.now(),
    );
    _isInCall = true;
    notifyListeners();

    // Implement actual call initiation logic
    // This would integrate with WebRTC or a service like Agora
  }

  Future<void> endCall() async {
    if (_currentCall != null) {
      _currentCall!.endTime = DateTime.now();
      _currentCall!.duration = _currentCall!.endTime!
          .difference(_currentCall!.startTime)
          .inSeconds;
      
      // Save call history or analytics here
      
      _currentCall = null;
      _isInCall = false;
      notifyListeners();
    }
  }

  Future<void> toggleMute() async {
    if (_currentCall != null) {
      _currentCall!.isMuted = !_currentCall!.isMuted;
      notifyListeners();
    }
  }

  Future<void> switchCamera() async {
    if (_currentCall != null) {
      _currentCall!.isFrontCamera = !_currentCall!.isFrontCamera;
      notifyListeners();
    }
  }
}