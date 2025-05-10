import 'package:connecta/models/user.dart';

class CallSession {
  final String id;
  final User caller;
  final DateTime startTime;
  DateTime? endTime;
  int? duration;
  bool isMuted;
  bool isFrontCamera;

  CallSession({
    required this.id,
    required this.caller,
    required this.startTime,
    this.endTime,
    this.duration,
    this.isMuted = false,
    this.isFrontCamera = true,
  });
}