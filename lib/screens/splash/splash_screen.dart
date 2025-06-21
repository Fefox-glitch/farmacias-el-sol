import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/provider_locator.dart';
import '../../widgets/loading_indicator.dart';
import '../main/main_screen.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Simular un tiempo mínimo de carga para mostrar el splash
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = ProviderLocator.getAuth(context);

    // Esperar a que se inicialice el estado de autenticación
    while (!authProvider.isInitialized) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
    }

    // Navegar a la pantalla correspondiente
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => authProvider.isAuthenticated
              ? const MainScreen()
              : const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                AppConstants.logoPath,
                width: 200,
                height: 200,
              ),

              const SizedBox(height: 32),

              // Nombre de la app
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 48),

              // Indicador de carga
              const LoadingIndicator(
                color: Colors.white,
                size: 48,
                message: 'Cargando...',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
