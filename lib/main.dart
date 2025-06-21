import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home/home_screen.dart';
import 'config/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
