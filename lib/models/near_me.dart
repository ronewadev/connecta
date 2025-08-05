class NearMeUser {
  final String id;
  final String name;
  final String avatarUrl;
  final double distance;
  final bool isOnline;

  NearMeUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.distance,
    this.isOnline = false,
  });
}
