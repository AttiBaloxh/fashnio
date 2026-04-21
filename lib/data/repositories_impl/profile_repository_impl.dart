import '../../domain/models/profile_model.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/local/profile_local_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({required this.localDataSource});

  @override
  Future<ProfileModel> getProfile() => localDataSource.getProfile();

  @override
  Future<void> updateDarkMode(bool isDark) =>
      localDataSource.updateDarkMode(isDark);
}
