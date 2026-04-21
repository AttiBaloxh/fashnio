import '../../domain/models/notification_model.dart';
import '../../domain/repositories/notification_repository.dart';
import '../data_sources/local/notification_local_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource localDataSource;

  NotificationRepositoryImpl({required this.localDataSource});

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final List<dynamic> jsonList = await localDataSource.getNotifications();
    return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
  }
}
