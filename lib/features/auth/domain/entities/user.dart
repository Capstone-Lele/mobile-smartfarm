class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String image;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.image,
  });

  String get roleLabel {
    switch (role) {
      case 'pic':
        return 'Penanggung Jawab';
      case 'staff':
        return 'Petugas';
      default:
        return 'User';
    }
  }
}
