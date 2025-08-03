import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import '../models/user_model.dart';

class Call {
  final String id;
  final User caller;
  DateTime startTime;
  DateTime? endTime;
  int? duration;
  bool isMuted;
  bool isFrontCamera;

  Call({
    required this.id,
    required this.caller,
    required this.startTime,
    this.endTime,
    this.duration,
    this.isMuted = false,
    this.isFrontCamera = true,
  });
}

class CallService with ChangeNotifier {
  Call? _currentCall;
  bool _isInCall = false;

  Call? get currentCall => _currentCall;
  bool get isInCall => _isInCall;

  Future<void> startCall(User otherUser) async {
    _currentCall = Call(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      caller: otherUser,
      startTime: DateTime.now(),
    );
    _isInCall = true;
    notifyListeners();
    // Demo only: no actual call logic
  }

  Future<void> endCall() async {
    if (_currentCall != null) {
      _currentCall!.endTime = DateTime.now();
      _currentCall!.duration = _currentCall!.endTime!.difference(_currentCall!.startTime).inSeconds;
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