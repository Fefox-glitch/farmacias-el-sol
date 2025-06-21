import 'package:flutter/material.dart';

enum ReminderFrequency {
  once,      // Una sola vez
  daily,     // Diario
  weekly,    // Semanal
  monthly,   // Mensual
  custom     // Personalizado (horas específicas)
}

class Reminder {
  final String id;
  final String medicamento;
  final String dosis;
  final TimeOfDay hora;
  final ReminderFrequency frecuencia;
  final List<TimeOfDay> horasPersonalizadas;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final String? notas;
  final bool activo;
  final String? usuarioId;

  Reminder({
    required this.id,
    required this.medicamento,
    required this.dosis,
    required this.hora,
    required this.frecuencia,
    this.horasPersonalizadas = const [],
    required this.fechaInicio,
    this.fechaFin,
    this.notas,
    this.activo = true,
    this.usuarioId,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as String,
      medicamento: json['medicamento'] as String,
      dosis: json['dosis'] as String,
      hora: TimeOfDay(
        hour: (json['hora'] as Map<String, dynamic>)['hour'] as int,
        minute: (json['hora'] as Map<String, dynamic>)['minute'] as int,
      ),
      frecuencia: ReminderFrequency.values.firstWhere(
        (e) => e.toString() == 'ReminderFrequency.${json['frecuencia']}',
      ),
      horasPersonalizadas: (json['horasPersonalizadas'] as List<dynamic>?)
          ?.map((e) => TimeOfDay(
                hour: (e as Map<String, dynamic>)['hour'] as int,
                minute: e['minute'] as int,
              ))
          .toList() ??
          [],
      fechaInicio: DateTime.parse(json['fechaInicio'] as String),
      fechaFin: json['fechaFin'] != null
          ? DateTime.parse(json['fechaFin'] as String)
          : null,
      notas: json['notas'] as String?,
      activo: json['activo'] as bool? ?? true,
      usuarioId: json['usuarioId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicamento': medicamento,
      'dosis': dosis,
      'hora': {
        'hour': hora.hour,
        'minute': hora.minute,
      },
      'frecuencia': frecuencia.toString().split('.').last,
      'horasPersonalizadas': horasPersonalizadas
          .map((h) => {
                'hour': h.hour,
                'minute': h.minute,
              })
          .toList(),
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin?.toIso8601String(),
      'notas': notas,
      'activo': activo,
      'usuarioId': usuarioId,
    };
  }

  Reminder copyWith({
    String? id,
    String? medicamento,
    String? dosis,
    TimeOfDay? hora,
    ReminderFrequency? frecuencia,
    List<TimeOfDay>? horasPersonalizadas,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? notas,
    bool? activo,
    String? usuarioId,
  }) {
    return Reminder(
      id: id ?? this.id,
      medicamento: medicamento ?? this.medicamento,
      dosis: dosis ?? this.dosis,
      hora: hora ?? this.hora,
      frecuencia: frecuencia ?? this.frecuencia,
      horasPersonalizadas: horasPersonalizadas ?? this.horasPersonalizadas,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      notas: notas ?? this.notas,
      activo: activo ?? this.activo,
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }

  bool get isActive {
    if (!activo) return false;
    if (fechaFin != null && DateTime.now().isAfter(fechaFin!)) return false;
    return true;
  }

  List<DateTime> getNextReminders({int limit = 5}) {
    final List<DateTime> reminders = [];
    final now = DateTime.now();
    
    switch (frecuencia) {
      case ReminderFrequency.once:
        final reminderTime = DateTime(
          fechaInicio.year,
          fechaInicio.month,
          fechaInicio.day,
          hora.hour,
          hora.minute,
        );
        if (reminderTime.isAfter(now)) {
          reminders.add(reminderTime);
        }
        break;
        
      case ReminderFrequency.daily:
        var currentDate = now;
        while (reminders.length < limit) {
          final reminderTime = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            hora.hour,
            hora.minute,
          );
          if (reminderTime.isAfter(now)) {
            reminders.add(reminderTime);
          }
          currentDate = currentDate.add(const Duration(days: 1));
        }
        break;
        
      // TODO: Implementar lógica para otros tipos de frecuencia
      default:
        break;
    }
    
    return reminders;
  }

  @override
  String toString() {
    return 'Reminder(id: $id, medicamento: $medicamento, dosis: $dosis)';
  }
}
