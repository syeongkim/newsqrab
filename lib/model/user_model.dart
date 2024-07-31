class User {
  final String id;
  final String bio;
  final String nickname;
  final List<Follower> following;
  final List<Follower> followers;

  User({
    required this.id,
    required this.bio,
    required this.nickname,
    required this.following,
    required this.followers,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      bio: json['bio'] as String? ?? "No bio available",
      nickname: json['nickname'] as String? ?? "No nickname available",
      following: (json['following'] as List<dynamic>?)
          ?.map((item) => Follower.fromJson(item))
          .toList() ?? [],
      followers: (json['followers'] as List<dynamic>?)
          ?.map((item) => Follower.fromJson(item))
          .toList() ?? [],
    );
  }
}

class Follower {
  final String name;
  final String profilePic;

  Follower({
    required this.name,
    required this.profilePic,
  });

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      name: json['name'] as String,
      profilePic: json['profilePic'] as String? ?? 'assets/images/default.png',
    );
  }
}
