import 'package:flutter/material.dart';
import '../models/reminder.dart';
import '../services/service_locator.dart';
import 'base_provider.dart';

class ReminderProvider extends BaseProvider {
  List<Reminder> _reminders = [];
  Reminder? _selectedReminder;

  List<Reminder> get reminders => _reminders;
  Reminder? get selectedReminder => _selectedReminder;
  List<Reminder> get activeReminders => 
      _reminders.where((reminder) => reminder.isActive).toList();

  ReminderProvider() {
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    try {
      setStatus(Status.loading);
      _reminders = await storageService.getReminders();
      setStatus(Status.success);
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> addReminder(Reminder reminder) async {
    await handleFuture(() async {
      _reminders.add(reminder);
      await _saveReminders();
      await notificationService.scheduleReminder(reminder);
    });
  }

  Future<void> updateReminder(Reminder updatedReminder) async {
    await handleFuture(() async {
      final index = _reminders.indexWhere((r) => r.id == updatedReminder.id);
      if (index != -1) {
        _reminders[index] = updatedReminder;
        await _saveReminders();
        
        // Actualizar notificaciones
        await notificationService.cancelReminder(updatedReminder.id);
        if (updatedReminder.activo) {
          await notificationService.scheduleReminder(updatedReminder);
        }
      }
    });
  }

  Future<void> deleteReminder(String reminderId) async {
    await handleFuture(() async {
      _reminders.removeWhere((r) => r.id == reminderId);
      await _saveReminders();
      await notificationService.cancelReminder(reminderId);
    });
  }

  Future<void> toggleReminderActive(String reminderId) async {
    await handleFuture(() async {
      final index = _reminders.indexWhere((r) => r.id == reminderId);
      if (index != -1) {
        final reminder = _reminders[index];
        final updatedReminder = reminder.copyWith(
          activo: !reminder.activo,
        );
        _reminders[index] = updatedReminder;
        await _saveReminders();

        if (updatedReminder.activo) {
          await notificationService.scheduleReminder(updatedReminder);
        } else {
          await notificationService.cancelReminder(reminderId);
        }
      }
    });
  }

  Future<void> _saveReminders() async {
    await storageService.saveReminders(_reminders);
    notifyListeners();
  }

  void selectReminder(String reminderId) {
    _selectedReminder = _reminders.firstWhere(
      (r) => r.id == reminderId,
      orElse: () => null as Reminder,
    );
    notifyListeners();
  }

  void clearSelectedReminder() {
    _selectedReminder = null;
    notifyListeners();
  }

  List<Reminder> getRemindersByDate(DateTime date) {
    return _reminders.where((reminder) {
      if (!reminder.isActive) return false;
      
      switch (reminder.frecuencia) {
        case ReminderFrequency.once:
          return reminder.fechaInicio.year == date.year &&
              reminder.fechaInicio.month == date.month &&
              reminder.fechaInicio.day == date.day;
        
        case ReminderFrequency.daily:
          if (reminder.fechaFin != null && date.isAfter(reminder.fechaFin!)) {
            return false;
          }
          return true;
        
        case ReminderFrequency.weekly:
          if (reminder.fechaFin != null && date.isAfter(reminder.fechaFin!)) {
            return false;
          }
          return reminder.fechaInicio.weekday == date.weekday;
        
        case ReminderFrequency.monthly:
          if (reminder.fechaFin != null && date.isAfter(reminder.fechaFin!)) {
            return false;
          }
          return reminder.fechaInicio.day == date.day;
        
        case ReminderFrequency.custom:
          if (reminder.fechaFin != null && date.isAfter(reminder.fechaFin!)) {
            return false;
          }
          // Para frecuencia personalizada, verificar si hay horas programadas
          return reminder.horasPersonalizadas.isNotEmpty;
      }
    }).toList();
  }

  List<TimeOfDay> getReminderTimesByDate(DateTime date) {
    final reminders = getRemindersByDate(date);
    final times = <TimeOfDay>{};

    for (final reminder in reminders) {
      if (reminder.frecuencia == ReminderFrequency.custom) {
        times.addAll(reminder.horasPersonalizadas);
      } else {
        times.add(reminder.hora);
      }
    }

    return times.toList()
      ..sort((a, b) {
        final aMinutes = a.hour * 60 + a.minute;
        final bMinutes = b.hour * 60 + b.minute;
        return aMinutes.compareTo(bMinutes);
      });
  }

  List<Reminder> getRemindersByMedicine(String medicineId) {
    return _reminders
        .where((reminder) => reminder.medicamento == medicineId)
        .toList();
  }

  Future<void> rescheduleAllReminders() async {
    await handleFuture(() async {
      await notificationService.rescheduleAllReminders(_reminders);
    });
  }

  bool hasActiveReminders(String medicineId) {
    return _reminders.any(
      (r) => r.medicamento == medicineId && r.isActive,
    );
  }

  int getActiveRemindersCount() {
    return _reminders.where((r) => r.isActive).length;
  }

  void sortRemindersByNextOccurrence() {
    _reminders.sort((a, b) {
      final aNext = a.getNextReminders(limit: 1);
      final bNext = b.getNextReminders(limit: 1);

      if (aNext.isEmpty && bNext.isEmpty) return 0;
      if (aNext.isEmpty) return 1;
      if (bNext.isEmpty) return -1;

      return aNext.first.compareTo(bNext.first);
    });
    notifyListeners();
  }
}
