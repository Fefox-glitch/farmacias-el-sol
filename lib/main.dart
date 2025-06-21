import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home/home_screen.dart';
import 'config/theme.dart';
import 'services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar orientación de la app
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Inicializar Firebase
  await Firebase.initializeApp();

  // Configurar inyección de dependencias
  await setupServiceLocator();

  runApp(const FarmaciasElSolApp());
}

class FarmaciasElSolApp extends StatelessWidget {
  const FarmaciasElSolApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farmacias El Sol',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            // Cerrar el teclado al tocar fuera de un campo de texto
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: child!,
        );
      },
    );
  }
}
