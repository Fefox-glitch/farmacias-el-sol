import 'package:get_it/get_it.dart';
import 'api_service.dart';
import 'auth_service.dart';
import 'location_service.dart';
import 'notification_service.dart';
import 'storage_service.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Servicios principales
  serviceLocator.registerLazySingleton<ApiService>(() => ApiService());
  serviceLocator.registerLazySingleton<AuthService>(() => AuthService());
  serviceLocator.registerLazySingleton<LocationService>(() => LocationService());
  serviceLocator.registerLazySingleton<NotificationService>(() => NotificationService());
  serviceLocator.registerLazySingleton<StorageService>(() => StorageService());

  // Inicializar servicios que requieren setup
  final storageService = serviceLocator<StorageService>();
  await storageService.init();

  final notificationService = serviceLocator<NotificationService>();
  await notificationService.init();

  // Verificar permisos de ubicación
  final locationService = serviceLocator<LocationService>();
  await locationService.checkLocationPermission().catchError((e) {
    print('Warning: Location permissions not granted - $e');
    // No lanzamos el error ya que la app puede funcionar sin ubicación
  });
}

// Helpers para acceder a los servicios
ApiService get apiService => serviceLocator<ApiService>();
AuthService get authService => serviceLocator<AuthService>();
LocationService get locationService => serviceLocator<LocationService>();
NotificationService get notificationService => serviceLocator<NotificationService>();
StorageService get storageService => serviceLocator<StorageService>();
