import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../models/medicine.dart';
import '../models/pharmacy.dart';
import '../models/user.dart';
import 'auth_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  final AuthService _authService = AuthService();
  
  factory ApiService() {
    return _instance;
  }
  
  ApiService._internal();

  // Headers base para todas las peticiones
  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getIdToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
    };
  }

  // URL base de la API
  String get _baseUrl => '${AppConstants.baseApiUrl}/api/${AppConstants.apiVersion}';

  // Manejo genérico de errores
  Never _handleError(dynamic error) {
    if (error is http.Response) {
      final responseData = json.decode(error.body);
      throw Exception(responseData['message'] ?? AppConstants.genericError);
    }
    throw Exception(error.toString());
  }

  // Búsqueda de medicamentos
  Future<List<Medicine>> searchMedicines({
    required String query,
    String? category,
    String? activeIngredient,
    int page = 1,
    int limit = AppConstants.defaultPageSize,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/medicines/search').replace(queryParameters: {
          'q': query,
          if (category != null) 'category': category,
          if (activeIngredient != null) 'activeIngredient': activeIngredient,
          'page': page.toString(),
          'limit': limit.toString(),
        }),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => Medicine.fromJson(json)).toList();
      }

      throw response;
    } catch (e) {
      _handleError(e);
    }
  }

  // Obtener detalles de un medicamento
  Future<Medicine> getMedicineDetails(String medicineId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/medicines/$medicineId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return Medicine.fromJson(json.decode(response.body));
      }

      throw response;
    } catch (e) {
      _handleError(e);
    }
  }

  // Obtener farmacias cercanas
  Future<List<Pharmacy>> getNearbyPharmacies({
    required double lat,
    required double lng,
    double radius = 5000, // Radio en metros
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/pharmacies/nearby').replace(queryParameters: {
          'lat': lat.toString(),
          'lng': lng.toString(),
          'radius': radius.toString(),
        }),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => Pharmacy.fromJson(json)).toList();
      }

      throw response;
    } catch (e) {
      _handleError(e);
    }
  }

  // Obtener detalles de una farmacia
  Future<Pharmacy> getPharmacyDetails(String pharmacyId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/pharmacies/$pharmacyId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return Pharmacy.fromJson(json.decode(response.body));
      }

      throw response;
    } catch (e) {
      _handleError(e);
    }
  }

  // Procesar receta (OCR)
  Future<Map<String, dynamic>> processRecipe(String imagePath) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/prescriptions/process'),
      );

      request.headers.addAll(await _getHeaders());
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imagePath,
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }

      throw response;
    } catch (e) {
      _handleError(e);
    }
  }

  // Actualizar perfil de usuario
  Future<User> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/users/$userId'),
        headers: await _getHeaders(),
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      }

      throw response;
    } catch (e) {
      _handleError(e);
    }
  }

  // Agregar dependiente
  Future<User> addDependent(String userId, Map<String, dynamic> dependentData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/users/$userId/dependents'),
        headers: await _getHeaders(),
        body: json.encode(dependentData),
      );

      if (response.statusCode == 201) {
        return User.fromJson(json.decode(response.body));
      }

      throw response;
    } catch (e) {
      _handleError(e);
    }
  }

  // Eliminar dependiente
  Future<void> removeDependent(String userId, String dependentId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/users/$userId/dependents/$dependentId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode != 204) {
        throw response;
      }
    } catch (e) {
      _handleError(e);
    }
  }

  // Verificar disponibilidad de medicamento
  Future<Map<String, dynamic>> checkMedicineAvailability(
    String medicineId,
    String pharmacyId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/pharmacies/$pharmacyId/medicines/$medicineId/availability'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }

      throw response;
    } catch (e) {
      _handleError(e);
    }
  }

  // Reportar error en la información
  Future<void> reportError({
    required String type,
    required String itemId,
    required String description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/reports'),
        headers: await _getHeaders(),
        body: json.encode({
          'type': type,
          'itemId': itemId,
          'description': description,
        }),
      );

      if (response.statusCode != 201) {
        throw response;
      }
    } catch (e) {
      _handleError(e);
    }
  }

  // Obtener categorías de medicamentos
  Future<List<String>> getMedicineCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/medicines/categories'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<String>();
      }

      throw response;
    } catch (e) {
      _handleError(e);
    }
  }

  // Obtener principios activos
  Future<List<String>> getActiveIngredients() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/medicines/active-ingredients'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<String>();
      }

      throw response;
    } catch (e) {
      _handleError(e);
    }
  }
}
