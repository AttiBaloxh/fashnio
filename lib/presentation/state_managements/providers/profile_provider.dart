import 'package:flutter/material.dart';
import '../../../domain/models/profile_model.dart';
import '../../../domain/repositories/profile_repository.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepository repository;

  ProfileProvider({required this.repository}) {
    _loadProfile();
  }

  ProfileModel? _profile;
  bool _isLoading = true;

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;

  Future<void> _loadProfile() async {
    _isLoading = true;
    notifyListeners();

    _profile = await repository.getProfile();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool isDark) async {
    if (_profile == null) return;
    _profile = _profile!.copyWith(isDarkMode: isDark);
    notifyListeners();
    await repository.updateDarkMode(isDark);
  }
}
