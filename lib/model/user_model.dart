class User {
  final String id;
  final String bio;
  final String nickname;
  final String profilePicture;
  final List<String> following;
  final List<String> followers;

  User({
    required this.id,
    required this.bio,
    required this.nickname,
    required this.profilePicture,
    required this.following,
    required this.followers,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      bio: json['bio'] as String? ?? "No bio available",
      nickname: json['nickname'] as String? ?? "No nickname available",
      profilePicture: json['profilePicture'] as String? ?? "",
      following: List<String>.from(json['following'] ?? []),
      followers: List<String>.from(json['followers'] ?? []),
    );
  }
}
