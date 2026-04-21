import 'package:fashio/data/data_sources/local/home_local_data_source.dart';

abstract class HomeRepository {
  Future<Map<String, dynamic>> getHomeData();
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl({required this.localDataSource});

  @override
  Future<Map<String, dynamic>> getHomeData() async {
    return await localDataSource.getHomeData();
  }
}
