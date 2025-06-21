import 'package:flutter/foundation.dart';
import '../models/medicine.dart';
import '../services/service_locator.dart';
import 'base_provider.dart';
import '../services/database_service.dart';

class MedicineProvider extends BaseProvider {
  final DatabaseService _dbService = DatabaseService();

  List<Medicine> _searchResults = [];
  List<String> _recentSearches = [];
  Medicine? _selectedMedicine;
  List<String> _categories = [];
  List<String> _activeIngredients = [];
  List<Medicine> _medicines = [];

  List<Medicine> get searchResults => _searchResults;
  List<String> get recentSearches => _recentSearches;
  Medicine? get selectedMedicine => _selectedMedicine;
  List<String> get categories => _categories;
  List<String> get activeIngredients => _activeIngredients;
  List<Medicine> get medicines => _medicines;

  MedicineProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _recentSearches = storageService.getRecentSearches();
    await _loadCategories();
    await _loadActiveIngredients();
    await loadMedicines();
  }

  Future<void> _loadCategories() async {
    try {
      _categories = await apiService.getMedicineCategories();
      notifyListeners();
    } catch (e) {
      debugPrint('Error cargando categorías: $e');
    }
  }

  Future<void> _loadActiveIngredients() async {
    try {
      _activeIngredients = await apiService.getActiveIngredients();
      notifyListeners();
    } catch (e) {
      debugPrint('Error cargando principios activos: $e');
    }
  }

  Future<void> loadMedicines() async {
    try {
      _medicines = await _dbService.getMedicines();
      notifyListeners();
    } catch (e) {
      debugPrint('Error cargando medicamentos desde DB: $e');
    }
  }

  Future<void> addMedicine(Medicine medicine) async {
    try {
      await _dbService.insertMedicine(medicine);
      _medicines.add(medicine);
      notifyListeners();
    } catch (e) {
      debugPrint('Error agregando medicamento: $e');
    }
  }

  Future<void> updateMedicine(Medicine medicine) async {
    try {
      await _dbService.updateMedicine(medicine);
      final index = _medicines.indexWhere((m) => m.id == medicine.id);
      if (index != -1) {
        _medicines[index] = medicine;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error actualizando medicamento: $e');
    }
  }

  Future<void> deleteMedicine(String id) async {
    try {
      await _dbService.deleteMedicine(id);
      _medicines.removeWhere((m) => m.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error eliminando medicamento: $e');
    }
  }

  Future<void> searchMedicines({
    required String query,
    String? category,
    String? activeIngredient,
    int page = 1,
  }) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    await handleFuture(() async {
      _searchResults = await apiService.searchMedicines(
        query: query,
        category: category,
        activeIngredient: activeIngredient,
        page: page,
      );

      // Guardar búsqueda reciente
      if (query.length > 2) {
        await storageService.addRecentSearch(query);
        _recentSearches = storageService.getRecentSearches();
      }

      notifyListeners();
    });
  }

  Future<void> getMedicineDetails(String medicineId) async {
    await handleFuture(() async {
      _selectedMedicine = await apiService.getMedicineDetails(medicineId);
      notifyListeners();
    });
  }

  Future<void> clearRecentSearches() async {
    await storageService.clearRecentSearches();
    _recentSearches = [];
    notifyListeners();
  }

  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }

  void clearSelectedMedicine() {
    _selectedMedicine = null;
    notifyListeners();
  }

  List<Medicine> filterByCategory(String category) {
    return _searchResults
        .where((medicine) => medicine.categoria == category)
        .toList();
  }

  List<Medicine> filterByActiveIngredient(String activeIngredient) {
    return _searchResults
        .where((medicine) => medicine.principioActivo == activeIngredient)
        .toList();
  }

  List<Medicine> filterByPrescriptionRequired(bool requiresPrescription) {
    return _searchResults
        .where((medicine) => medicine.requiereReceta == requiresPrescription)
        .toList();
  }

  Future<void> reportMedicineError(String medicineId, String description) async {
    await handleFuture(() async {
      await apiService.reportError(
        type: 'medicine',
        itemId: medicineId,
        description: description,
      );
    });
  }

  // Métodos de ayuda para sugerencias
  List<String> getSimilarMedicines(String query) {
    query = query.toLowerCase();
    final suggestions = <String>{};

    for (final medicine in _searchResults) {
      if (medicine.nombre.toLowerCase().contains(query)) {
        suggestions.add(medicine.nombre);
      }
      if (medicine.principioActivo.toLowerCase().contains(query)) {
        suggestions.add(medicine.principioActivo);
      }
    }

    return suggestions.take(5).toList();
  }

  List<String> getRelatedCategories(String medicineName) {
    final relatedCategories = <String>{};
    
    for (final medicine in _searchResults) {
      if (medicine.nombre.toLowerCase().contains(medicineName.toLowerCase())) {
        // TODO: Agregar categoría cuando se implemente en el modelo
        // relatedCategories.add(medicine.categoria);
      }
    }

    return relatedCategories.toList();
  }

  List<String> getRelatedActiveIngredients(String medicineName) {
    final relatedIngredients = <String>{};
    
    for (final medicine in _searchResults) {
      if (medicine.nombre.toLowerCase().contains(medicineName.toLowerCase())) {
        relatedIngredients.add(medicine.principioActivo);
      }
    }

    return relatedIngredients.toList();
  }

  // Métodos para manejo de recetas
  Future<Map<String, dynamic>> processRecipe(String imagePath) async {
    return await handleFuture(() async {
      return await apiService.processRecipe(imagePath);
    });
  }

  Future<List<Medicine>> getMedicinesFromRecipe(List<String> medicineNames) async {
    final medicines = <Medicine>[];

    for (final name in medicineNames) {
      try {
        final results = await apiService.searchMedicines(query: name, limit: 1);
        if (results.isNotEmpty) {
          medicines.add(results.first);
        }
      } catch (e) {
        debugPrint('Error buscando medicamento de receta: $e');
      }
    }

    return medicines;
  }
}
