import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/pharmacy.dart';
import '../services/service_locator.dart';
import 'base_provider.dart';

class PharmacyProvider extends BaseProvider {
  List<Pharmacy> _nearbyPharmacies = [];
  List<Pharmacy> _favoritePharmacies = [];
  Pharmacy? _selectedPharmacy;
  LatLng? _currentLocation;

  List<Pharmacy> get nearbyPharmacies => _nearbyPharmacies;
  List<Pharmacy> get favoritePharmacies => _favoritePharmacies;
  Pharmacy? get selectedPharmacy => _selectedPharmacy;
  LatLng? get currentLocation => _currentLocation;

  Set<Marker> get pharmacyMarkers => 
      locationService.generatePharmacyMarkers(_nearbyPharmacies);

  PharmacyProvider() {
    _loadFavoritePharmacies();
  }

  Future<void> _loadFavoritePharmacies() async {
    try {
      _favoritePharmacies = await storageService.getFavoritePharmacies();
      notifyListeners();
    } catch (e) {
      debugPrint('Error cargando farmacias favoritas: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    await handleFuture(() async {
      final position = await locationService.getCurrentLocation();
      _currentLocation = LatLng(position.latitude, position.longitude);
      notifyListeners();
    });
  }

  Future<void> getNearbyPharmacies() async {
    if (_currentLocation == null) {
      await getCurrentLocation();
    }

    if (_currentLocation != null) {
      await handleFuture(() async {
        _nearbyPharmacies = await apiService.getNearbyPharmacies(
          lat: _currentLocation!.latitude,
          lng: _currentLocation!.longitude,
        );
        notifyListeners();
      });
    }
  }

  Future<void> selectPharmacy(String pharmacyId) async {
    await handleFuture(() async {
      _selectedPharmacy = await apiService.getPharmacyDetails(pharmacyId);
      notifyListeners();
    });
  }

  Future<void> toggleFavorite(Pharmacy pharmacy) async {
    final isFavorite = _favoritePharmacies.any((p) => p.id == pharmacy.id);

    if (isFavorite) {
      _favoritePharmacies.removeWhere((p) => p.id == pharmacy.id);
      await storageService.removeFavoritePharmacy(pharmacy.id);
    } else {
      if (_favoritePharmacies.length >= AppConstants.maxFavoritePharmacies) {
        _favoritePharmacies.removeAt(0);
      }
      _favoritePharmacies.add(pharmacy);
      await storageService.addFavoritePharmacy(pharmacy);
    }

    notifyListeners();
  }

  bool isFavorite(String pharmacyId) {
    return _favoritePharmacies.any((p) => p.id == pharmacyId);
  }

  Future<void> checkMedicineAvailability(String medicineId) async {
    if (_selectedPharmacy == null) return;

    await handleFuture(() async {
      final availability = await apiService.checkMedicineAvailability(
        medicineId,
        _selectedPharmacy!.id,
      );
      // TODO: Manejar la respuesta de disponibilidad
      notifyListeners();
    });
  }

  void clearSelectedPharmacy() {
    _selectedPharmacy = null;
    notifyListeners();
  }

  Future<void> refreshNearbyPharmacies() async {
    _nearbyPharmacies = [];
    notifyListeners();
    await getNearbyPharmacies();
  }

  LatLngBounds? getPharmacyBounds() {
    if (_nearbyPharmacies.isEmpty) return null;

    final points = _nearbyPharmacies
        .map((pharmacy) => LatLng(pharmacy.lat, pharmacy.lng))
        .toList();

    if (_currentLocation != null) {
      points.add(_currentLocation!);
    }

    return locationService.getBounds(points);
  }

  List<Pharmacy> searchPharmacies(String query) {
    query = query.toLowerCase();
    return _nearbyPharmacies.where((pharmacy) {
      return pharmacy.nombre.toLowerCase().contains(query) ||
          pharmacy.direccion.toLowerCase().contains(query);
    }).toList();
  }

  void sortPharmaciesByDistance() {
    if (_currentLocation == null) return;

    _nearbyPharmacies.sort((a, b) {
      final distanceA = locationService.calculateDistance(
        _currentLocation!,
        LatLng(a.lat, a.lng),
      );
      final distanceB = locationService.calculateDistance(
        _currentLocation!,
        LatLng(b.lat, b.lng),
      );
      return distanceA.compareTo(distanceB);
    });
    notifyListeners();
  }

  List<Pharmacy> filterPharmacies({
    bool? isOpen,
    bool? hasDelivery,
    List<String>? services,
  }) {
    return _nearbyPharmacies.where((pharmacy) {
      if (isOpen == true && !pharmacy.isOpen) return false;
      if (hasDelivery == true && !pharmacy.servicioADomicilio) return false;
      if (services != null && services.isNotEmpty) {
        return services.every(
          (service) => pharmacy.serviciosAdicionales.contains(service),
        );
      }
      return true;
    }).toList();
  }
}
