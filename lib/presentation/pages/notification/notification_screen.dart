import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state_managements/providers/notification_provider.dart';
import '../../state_managements/providers/profile_provider.dart';
import '../../widgets/notification_item_widget.dart';
import '../../../utils/constants/app_constants.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final profileProvider = context.watch<ProfileProvider>();
    final isDarkMode = profileProvider.profile?.isDarkMode ?? false;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : AppColors.grey100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notification',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final grouped = provider.groupedNotifications;
          final keys = grouped.keys.toList();

          if (keys.isEmpty) {
            return Center(
              child: Text(
                "No notifications yet",
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding,
            ),
            itemCount: keys.length,
            itemBuilder: (context, index) {
              final key = keys[index];
              final notifications = grouped[key]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      key,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  ...notifications.map(
                    (notification) => NotificationItemWidget(
                      notification: notification,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
