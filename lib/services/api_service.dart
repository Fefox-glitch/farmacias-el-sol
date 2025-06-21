import 'package:flutter/foundation.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  
  factory ApiService() {
    return _instance;
  }
  
  ApiService._internal();

  // Búsqueda de medicamentos
  Future<List<Map<String, dynamic>>> searchMedicines(String query) async {
    try {
      // TODO: Implementar búsqueda real con backend
      await Future.delayed(const Duration(seconds: 1)); // Simulación de delay
      return [
        {
          'id': '1',
          'nombre': 'Paracetamol',
          'descripcion': 'Analgésico y antipirético',
          'principioActivo': 'Acetaminofén',
          'presentacion': 'Tabletas 500mg',
        },
        {
          'id': '2',
          'nombre': 'Ibuprofeno',
          'descripcion': 'Antiinflamatorio no esteroideo',
          'principioActivo': 'Ibuprofeno',
          'presentacion': 'Tabletas 400mg',
        },
      ];
    } catch (e) {
      debugPrint('Error en búsqueda de medicamentos: $e');
      return [];
    }
  }

  // Obtener farmacias cercanas
  Future<List<Map<String, dynamic>>> getNearbyPharmacies(double lat, double lng) async {
    try {
      // TODO: Implementar integración con API de mapas
      await Future.delayed(const Duration(seconds: 1));
      return [
        {
          'id': '1',
          'nombre': 'Farmacia El Sol - Centro',
          'direccion': 'Av. Principal 123',
          'lat': lat + 0.001,
          'lng': lng + 0.001,
          'horario': '24 horas',
        },
        {
          'id': '2',
          'nombre': 'Farmacia El Sol - Norte',
          'direccion': 'Calle 45 Norte',
          'lat': lat - 0.001,
          'lng': lng - 0.001,
          'horario': '8:00 - 22:00',
        },
      ];
    } catch (e) {
      debugPrint('Error al obtener farmacias cercanas: $e');
      return [];
    }
  }

  // Procesar receta (OCR)
  Future<Map<String, dynamic>> processRecipe(String imagePath) async {
    try {
      // TODO: Implementar procesamiento OCR real
      await Future.delayed(const Duration(seconds: 2));
      return {
        'success': true,
        'medicamentos': [
          'Paracetamol 500mg',
          'Amoxicilina 500mg'
        ],
        'doctor': 'Dr. Juan Pérez',
        'fecha': '2024-01-15',
      };
    } catch (e) {
      debugPrint('Error en procesamiento de receta: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  // Gestionar recordatorios
  Future<bool> createReminder({
    required String medicamento,
    required DateTime fecha,
    required String dosis,
    required int frecuenciaHoras,
  }) async {
    try {
      // TODO: Implementar creación real de recordatorios
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      debugPrint('Error al crear recordatorio: $e');
      return false;
    }
  }
}
