import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/pharmacy.dart';
import '../config/constants.dart';
import '../utils/helpers.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  
  factory LocationService() {
    return _instance;
  }

  LocationService._internal();

  // Verificar permisos de ubicación
  Future<bool> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Los servicios de ubicación están deshabilitados.');
    }

    // Verificar permisos de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Los permisos de ubicación fueron denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Los permisos de ubicación están permanentemente denegados. '
        'Por favor, habilítalos en la configuración del dispositivo.',
      );
    }

    return true;
  }

  // Obtener ubicación actual
  Future<Position> getCurrentLocation() async {
    await checkLocationPermission();
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Obtener farmacias cercanas
  Future<List<Pharmacy>> getNearbyPharmacies(LatLng userLocation) async {
    try {
      // TODO: Implementar llamada a API real para obtener farmacias cercanas
      // Por ahora, retornamos datos de ejemplo
      await Future.delayed(const Duration(seconds: 1));
      
      return [
        Pharmacy(
          id: '1',
          nombre: 'Farmacia El Sol - Centro',
          direccion: 'Av. Principal 123',
          lat: userLocation.latitude + 0.001,
          lng: userLocation.longitude + 0.001,
          horario: '24 horas',
          telefono: '555-0123',
          servicioADomicilio: true,
          serviciosAdicionales: ['Inyecciones', 'Presión arterial'],
          horarioSemanal: {
            'lunes': '08:00-22:00',
            'martes': '08:00-22:00',
            'miercoles': '08:00-22:00',
            'jueves': '08:00-22:00',
            'viernes': '08:00-22:00',
            'sabado': '09:00-21:00',
            'domingo': '09:00-20:00',
          },
        ),
        Pharmacy(
          id: '2',
          nombre: 'Farmacia El Sol - Norte',
          direccion: 'Calle 45 Norte',
          lat: userLocation.latitude - 0.001,
          lng: userLocation.longitude - 0.001,
          horario: '8:00 - 22:00',
          telefono: '555-0124',
          servicioADomicilio: false,
          serviciosAdicionales: ['Inyecciones'],
          horarioSemanal: {
            'lunes': '08:00-22:00',
            'martes': '08:00-22:00',
            'miercoles': '08:00-22:00',
            'jueves': '08:00-22:00',
            'viernes': '08:00-22:00',
            'sabado': '09:00-21:00',
            'domingo': 'Cerrado',
          },
        ),
      ];
    } catch (e) {
      throw Exception('Error al obtener farmacias cercanas: $e');
    }
  }

  // Calcular distancia entre dos puntos
  double calculateDistance(LatLng point1, LatLng point2) {
    return AppHelpers.calculateDistance(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
  }

  // Obtener dirección a partir de coordenadas
  Future<String> getAddressFromCoordinates(LatLng coordinates) async {
    try {
      // TODO: Implementar geocoding real
      // Por ahora, retornamos una dirección de ejemplo
      return 'Av. Principal 123, Ciudad';
    } catch (e) {
      throw Exception('Error al obtener la dirección: $e');
    }
  }

  // Obtener coordenadas a partir de dirección
  Future<LatLng> getCoordinatesFromAddress(String address) async {
    try {
      // TODO: Implementar geocoding inverso real
      // Por ahora, retornamos coordenadas de ejemplo
      return const LatLng(0, 0);
    } catch (e) {
      throw Exception('Error al obtener las coordenadas: $e');
    }
  }

  // Generar marcadores para el mapa
  Set<Marker> generatePharmacyMarkers(List<Pharmacy> pharmacies) {
    return pharmacies.map((pharmacy) {
      return Marker(
        markerId: MarkerId(pharmacy.id),
        position: LatLng(pharmacy.lat, pharmacy.lng),
        infoWindow: InfoWindow(
          title: pharmacy.nombre,
          snippet: pharmacy.direccion,
        ),
      );
    }).toSet();
  }

  // Obtener límites del mapa para incluir todos los marcadores
  LatLngBounds getBounds(List<LatLng> points) {
    if (points.isEmpty) {
      throw Exception('No hay puntos para calcular los límites');
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  // Verificar si una ubicación está dentro del radio de búsqueda
  bool isLocationInSearchRadius(LatLng center, LatLng point) {
    final distance = calculateDistance(center, point);
    return distance <= AppConstants.searchRadiusMeters;
  }

  // Obtener configuración inicial del mapa
  CameraPosition getInitialCameraPosition(LatLng location) {
    return CameraPosition(
      target: location,
      zoom: AppConstants.defaultMapZoom,
    );
  }
}
