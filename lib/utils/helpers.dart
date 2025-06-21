import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/constants.dart';

class AppHelpers {
  // Formato de fechas
  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormat).format(date);
  }

  static String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat(AppConstants.timeFormat).format(dt);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat(AppConstants.dateTimeFormat).format(dateTime);
  }

  // Validaciones
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    if (password.length < AppConstants.minPasswordLength) return false;
    if (password.length > AppConstants.maxPasswordLength) return false;
    return true;
  }

  static bool isValidPhone(String phone) {
    if (phone.isEmpty) return false;
    if (phone.length > AppConstants.maxPhoneLength) return false;
    final phoneRegex = RegExp(r'^\+?[\d\s-]+$');
    return phoneRegex.hasMatch(phone);
  }

  // Cálculo de distancias
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Implementar fórmula de Haversine para calcular distancia entre coordenadas
    const R = 6371e3; // Radio de la tierra en metros
    final phi1 = lat1 * pi / 180;
    final phi2 = lat2 * pi / 180;
    final deltaPhi = (lat2 - lat1) * pi / 180;
    final deltaLambda = (lon2 - lon1) * pi / 180;

    final a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final d = R * c;

    return d; // Distancia en metros
  }

  // Formateo de distancias
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    } else {
      final km = meters / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }

  // Manejo de errores
  static String getErrorMessage(dynamic error) {
    if (error is String) return error;
    if (error is Exception) {
      // TODO: Implementar manejo específico de excepciones
      return error.toString();
    }
    return AppConstants.genericError;
  }

  // Snackbars
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Diálogos
  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  // Cache y almacenamiento
  static Future<void> clearAppData() async {
    // TODO: Implementar limpieza de datos
    // - Borrar SharedPreferences
    // - Borrar cache
    // - Cerrar sesión
    // - Etc.
  }

  // Validación de horarios
  static bool isPharmacyOpen(Map<String, String> schedule) {
    final now = DateTime.now();
    final currentDay = DateFormat('EEEE').format(now).toLowerCase();
    final currentTime = TimeOfDay.fromDateTime(now);

    final todaySchedule = schedule[currentDay];
    if (todaySchedule == null) return false;

    // Formato esperado: "HH:mm-HH:mm"
    final times = todaySchedule.split('-');
    if (times.length != 2) return false;

    final openTime = _parseTimeString(times[0]);
    final closeTime = _parseTimeString(times[1]);

    if (openTime == null || closeTime == null) return false;

    return _isTimeBetween(currentTime, openTime, closeTime);
  }

  static TimeOfDay? _parseTimeString(String timeStr) {
    final parts = timeStr.trim().split(':');
    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

    return TimeOfDay(hour: hour, minute: minute);
  }

  static bool _isTimeBetween(TimeOfDay time, TimeOfDay start, TimeOfDay end) {
    final now = time.hour * 60 + time.minute;
    final opens = start.hour * 60 + start.minute;
    final closes = end.hour * 60 + end.minute;

    if (closes < opens) {
      // Horario que cruza la medianoche
      return now >= opens || now <= closes;
    } else {
      return now >= opens && now <= closes;
    }
  }
}

// Extensiones útiles
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String get initials {
    final parts = trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}

extension DateTimeExtension on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);
}

extension TimeOfDayExtension on TimeOfDay {
  bool isBefore(TimeOfDay other) {
    return hour < other.hour || (hour == other.hour && minute < other.minute);
  }

  bool isAfter(TimeOfDay other) {
    return hour > other.hour || (hour == other.hour && minute > other.minute);
  }
}
