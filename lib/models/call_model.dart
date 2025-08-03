class Call {
  final String id;
  final String callerId;
  final String receiverId;
  final DateTime startTime;
  final DateTime? endTime;
  final CallType type;
  final CallStatus status;
  final int durationSeconds;

  Call({
    required this.id,
    required this.callerId,
    required this.receiverId,
    required this.startTime,
    this.endTime,
    required this.type,
    required this.status,
    this.durationSeconds = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'callerId': callerId,
      'receiverId': receiverId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'durationSeconds': durationSeconds,
    };
  }

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      id: map['id'],
      callerId: map['callerId'],
      receiverId: map['receiverId'],
      startTime: DateTime.parse(map['startTime']),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      type: CallType.values.firstWhere(
        (e) => e.toString() == 'CallType.${map['type']}',
        orElse: () => CallType.audio,
      ),
      status: CallStatus.values.firstWhere(
        (e) => e.toString() == 'CallStatus.${map['status']}',
        orElse: () => CallStatus.missed,
      ),
      durationSeconds: map['durationSeconds'],
    );
  }
}

enum CallType {
  audio,
  video,
}

enum CallStatus {
  missed,
  completed,
  rejected,
  ongoing,
}