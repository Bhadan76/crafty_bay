import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const String name = '/notifications';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: GetX<NotificationController>(
        builder: (controller) {
          if (controller.notifications.isEmpty) {
            return const Center(
              child: Text('No notifications yet'),
            );
          }

          return ListView.separated(
            itemCount: controller.notifications.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: notification.isRead ? Colors.grey.shade200 : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: notification.isRead ? Colors.red : Theme.of(context).primaryColor,
                  ),
                ),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,color: Colors.red
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.body,style: TextStyle(
                        fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,color: Colors.red
                    ),),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(notification.createdAt),
                      style: const TextStyle(fontSize: 11, color: Colors.red),
                    ),
                  ],
                ),
                onTap: () {
                  if (!notification.isRead && notification.id != null) {
                    Get.find<NotificationController>().markAsRead(notification.id!);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
