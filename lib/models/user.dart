class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String token;
  final int streak;
  final int points;
  final String league;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.token,
    required this.streak,
    required this.points,
    required this.league,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',       // ✅ default empty string
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      streak: json['streak'] is int ? json['streak'] : int.tryParse(json['streak']?.toString() ?? '0') ?? 0,
      points: json['points'] is int ? json['points'] : int.tryParse(json['points']?.toString() ?? '0') ?? 0,
      league: json['league']?.toString() ?? 'Bronze',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'token': token,
      'streak': streak,
      'points': points,
      'league': league,
    };
  }
}
