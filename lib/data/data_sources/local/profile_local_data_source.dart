import '../../../domain/models/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel> getProfile();
  Future<void> updateDarkMode(bool isDark);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  ProfileModel _mockProfile = const ProfileModel(
    name: 'Andrew Ainsley',
    phone: '+1 111 467 378 399',
    imageUrl:
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&q=80',
    language: 'English (US)',
    isDarkMode: false,
  );

  @override
  Future<ProfileModel> getProfile() async {
    // Simulate loading/fetching
    await Future.delayed(const Duration(milliseconds: 300));
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('profile_theme_dark') ?? false;
    _mockProfile = _mockProfile.copyWith(isDarkMode: isDark);
    return _mockProfile;
  }

  @override
  Future<void> updateDarkMode(bool isDark) async {
    _mockProfile = _mockProfile.copyWith(isDarkMode: isDark);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('profile_theme_dark', isDark);
  }
}
