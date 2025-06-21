import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'auth_provider.dart';
import 'medicine_provider.dart';
import 'pharmacy_provider.dart';
import 'reminder_provider.dart';

class ProviderLocator {
  static List<ChangeNotifierProvider> get providers => [
    ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider(),
    ),
    ChangeNotifierProvider<MedicineProvider>(
      create: (_) => MedicineProvider(),
    ),
    ChangeNotifierProvider<PharmacyProvider>(
      create: (_) => PharmacyProvider(),
    ),
    ChangeNotifierProvider<ReminderProvider>(
      create: (_) => ReminderProvider(),
    ),
  ];

  static Widget wrapWithProviders(Widget child) {
    return MultiProvider(
      providers: providers,
      child: child,
    );
  }

  // Helpers para acceder a los providers
  static AuthProvider getAuth(BuildContext context) => 
      Provider.of<AuthProvider>(context, listen: false);
  
  static MedicineProvider getMedicine(BuildContext context) => 
      Provider.of<MedicineProvider>(context, listen: false);
  
  static PharmacyProvider getPharmacy(BuildContext context) => 
      Provider.of<PharmacyProvider>(context, listen: false);
  
  static ReminderProvider getReminder(BuildContext context) => 
      Provider.of<ReminderProvider>(context, listen: false);

  // Helpers para escuchar cambios en los providers
  static AuthProvider watchAuth(BuildContext context) => 
      Provider.of<AuthProvider>(context);
  
  static MedicineProvider watchMedicine(BuildContext context) => 
      Provider.of<MedicineProvider>(context);
  
  static PharmacyProvider watchPharmacy(BuildContext context) => 
      Provider.of<PharmacyProvider>(context);
  
  static ReminderProvider watchReminder(BuildContext context) => 
      Provider.of<ReminderProvider>(context);
}
