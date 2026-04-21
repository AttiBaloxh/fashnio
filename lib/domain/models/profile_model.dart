class ProfileModel {
  final String name;
  final String phone;
  final String imageUrl;
  final String language;
  final bool isDarkMode;

  const ProfileModel({
    required this.name,
    required this.phone,
    required this.imageUrl,
    required this.language,
    required this.isDarkMode,
  });

  ProfileModel copyWith({
    String? name,
    String? phone,
    String? imageUrl,
    String? language,
    bool? isDarkMode,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      language: language ?? this.language,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}
