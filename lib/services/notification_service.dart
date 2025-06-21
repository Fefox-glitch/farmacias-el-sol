import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../config/constants.dart';
import '../models/reminder.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> init() async {
    tz.initializeTimeZones();

    // Configuración para Android
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración para iOS
    const iOSSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Configuración general
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Configurar canal de notificaciones para recordatorios
    await _setupNotificationChannels();
  }

  Future<void> _setupNotificationChannels() async {
    // Canal para recordatorios de medicamentos
    const reminderChannel = AndroidNotificationChannel(
      AppConstants.reminderChannelId,
      AppConstants.reminderChannelName,
      description: AppConstants.reminderChannelDescription,
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(reminderChannel);
  }

  void _onNotificationTap(NotificationResponse response) {
    // TODO: Implementar navegación cuando se toca una notificación
    print('Notificación tocada: ${response.payload}');
  }

  // Programar recordatorio
  Future<void> scheduleReminder(Reminder reminder) async {
    final List<DateTime> nextReminders = reminder.getNextReminders();
    
    for (final dateTime in nextReminders) {
      final id = reminder.id.hashCode + dateTime.millisecondsSinceEpoch.hashCode;
      
      await _notifications.zonedSchedule(
        id,
        'Recordatorio de medicamento',
        'Es hora de tomar ${reminder.medicamento} - ${reminder.dosis}',
        tz.TZDateTime.from(dateTime, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            AppConstants.reminderChannelId,
            AppConstants.reminderChannelName,
            channelDescription: AppConstants.reminderChannelDescription,
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: reminder.id,
      );
    }
  }

  // Cancelar recordatorio específico
  Future<void> cancelReminder(String reminderId) async {
    final List<PendingNotificationRequest> pendingNotifications =
        await _notifications.pendingNotificationRequests();

    for (final notification in pendingNotifications) {
      if (notification.payload == reminderId) {
        await _notifications.cancel(notification.id);
      }
    }
  }

  // Cancelar todos los recordatorios
  Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
  }

  // Mostrar notificación inmediata
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _notifications.show(
      DateTime.now().millisecond,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.reminderChannelId,
          AppConstants.reminderChannelName,
          channelDescription: AppConstants.reminderChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  // Verificar permisos de notificación
  Future<bool> requestPermissions() async {
    // Solicitar permisos en iOS
    final iOS = await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Solicitar permisos en Android
    final android = await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    return ios == true && android == true;
  }

  // Obtener notificaciones pendientes
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // Reprogramar todos los recordatorios
  Future<void> rescheduleAllReminders(List<Reminder> reminders) async {
    await cancelAllReminders();
    for (final reminder in reminders) {
      await scheduleReminder(reminder);
    }
  }

  // Mostrar notificación de error
  Future<void> showErrorNotification(String message) async {
    await showNotification(
      title: 'Error',
      body: message,
    );
  }

  // Mostrar notificación de éxito
  Future<void> showSuccessNotification(String message) async {
    await showNotification(
      title: 'Éxito',
      body: message,
    );
  }
}
