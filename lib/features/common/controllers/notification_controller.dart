import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../data/model/notification_model.dart';

class NotificationController extends GetxController {
  final Logger _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  StreamSubscription? _notificationSubscription;

  final RxList<NotificationModel> _notifications = <NotificationModel>[].obs;
  final RxInt _unreadCount = 0.obs;

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount.value;

  @override
  void onInit() {
    super.onInit();
    _initializeMessaging();
    _listenToNotifications();
  }

  @override
  void onClose() {
    _notificationSubscription?.cancel();
    super.onClose();
  }

  Future<void> _initializeMessaging() async {
    // Request permission for Android 13+
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get the token
      String? token = await _messaging.getToken();
      _logger.i('FCM Token: $token'); 

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          _saveNotificationToFirestore(
            message.notification!.title ?? 'New Notification',
            message.notification!.body ?? '',
          );
        } else if (message.data.isNotEmpty) {
          _saveNotificationToFirestore(
            message.data['title'] ?? 'New Notification',
            message.data['body'] ?? '',
          );
        }
      });
    }
  }

  void _listenToNotifications() {
    // Listening to global notifications
    _notificationSubscription = _firestore
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _notifications.value = snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
      _unreadCount.value = _notifications.where((n) => !n.isRead).length;
    });
  }

  Future<void> _saveNotificationToFirestore(String title, String body) async {
    await _firestore.collection('notifications').add({
      'title': title,
      'body': body,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }

  Future<void> markAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'isRead': true,
    });
  }
}
