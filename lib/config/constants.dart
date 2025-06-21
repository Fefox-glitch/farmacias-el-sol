class AppConstants {
  // App Information
  static const String appName = 'Farmacias El Sol';
  static const String appVersion = '1.0.0';
  
  // API Endpoints
  static const String baseApiUrl = 'https://api.farmaciaselsol.com'; // Example URL
  static const String apiVersion = 'v1';
  
  // Cache Keys
  static const String userCacheKey = 'user_data';
  static const String tokenCacheKey = 'auth_token';
  static const String themeModeKey = 'theme_mode';
  
  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;
  
  // Map Configuration
  static const double defaultMapZoom = 15.0;
  static const double maxMapZoom = 18.0;
  static const double minMapZoom = 10.0;
  static const int searchRadiusMeters = 5000; // 5km
  
  // Local Storage Keys
  static const String remindersKey = 'medication_reminders';
  static const String recentSearchesKey = 'recent_searches';
  static const String favoritePharmaciesKey = 'favorite_pharmacies';
  
  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  
  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int maxNameLength = 50;
  static const int maxEmailLength = 100;
  static const int maxPhoneLength = 15;
  
  // Error Messages
  static const String genericError = 'Ha ocurrido un error. Por favor, inténtalo de nuevo.';
  static const String networkError = 'Error de conexión. Verifica tu conexión a internet.';
  static const String sessionExpired = 'Tu sesión ha expirado. Por favor, inicia sesión nuevamente.';
  static const String invalidCredentials = 'Credenciales inválidas. Verifica tus datos.';
  
  // Success Messages
  static const String profileUpdateSuccess = 'Perfil actualizado correctamente';
  static const String reminderCreateSuccess = 'Recordatorio creado exitosamente';
  static const String reminderUpdateSuccess = 'Recordatorio actualizado exitosamente';
  static const String reminderDeleteSuccess = 'Recordatorio eliminado exitosamente';
  
  // Feature Flags
  static const bool enablePushNotifications = true;
  static const bool enableLocationServices = true;
  static const bool enableBiometricAuth = true;
  static const bool enableDarkMode = true;
  
  // App Settings
  static const int maxDependientes = 5;
  static const int maxRecentSearches = 10;
  static const int maxFavoritePharmacies = 10;
  static const Duration sessionTimeout = Duration(hours: 24);
  static const Duration cacheExpiration = Duration(days: 7);
  
  // Notification Channels
  static const String reminderChannelId = 'medication_reminders';
  static const String reminderChannelName = 'Recordatorios de Medicamentos';
  static const String reminderChannelDescription = 'Notificaciones para recordatorios de medicamentos';
  
  // Assets
  static const String logoPath = 'assets/images/logo.png';
  static const String placeholderImagePath = 'assets/images/placeholder.png';
  static const String defaultAvatarPath = 'assets/images/default_avatar.png';
  
  // Analytics Events
  static const String eventSearch = 'search_medicine';
  static const String eventViewPharmacy = 'view_pharmacy';
  static const String eventCreateReminder = 'create_reminder';
  static const String eventScanPrescription = 'scan_prescription';
  
  // Privacy & Terms
  static const String privacyPolicyUrl = 'https://farmaciaselsol.com/privacy';
  static const String termsOfServiceUrl = 'https://farmaciaselsol.com/terms';
  static const String supportEmail = 'soporte@farmaciaselsol.com';
  
  // Social Media
  static const String facebookUrl = 'https://facebook.com/farmaciaselsol';
  static const String instagramUrl = 'https://instagram.com/farmaciaselsol';
  static const String twitterUrl = 'https://twitter.com/farmaciaselsol';
}
