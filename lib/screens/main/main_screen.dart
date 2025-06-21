import 'package:flutter/material.dart';
import '../../widgets/base_screen.dart';
import '../home/home_screen.dart';
import '../search/search_screen.dart';
import '../pharmacy/pharmacy_list_screen.dart';
import '../reminder/reminder_list_screen.dart';
import '../profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final _pageController = PageController();

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const PharmacyListScreen(),
    const ReminderListScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = [
    'Inicio',
    'Buscar',
    'Farmacias',
    'Recordatorios',
    'Perfil',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavItemTap(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: _titles[_currentIndex],
      currentIndex: _currentIndex,
      onNavItemTap: _onNavItemTap,
      showBackButton: false,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(), // Deshabilitar deslizamiento
        children: _screens,
      ),
      // Acciones específicas para cada pantalla
      actions: _buildActions(),
      // FAB específico para cada pantalla
      floatingActionButton: _buildFAB(),
    );
  }

  List<Widget>? _buildActions() {
    switch (_currentIndex) {
      case 0: // Home
        return [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Mostrar notificaciones
            },
          ),
        ];
      case 1: // Search
        return [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Mostrar filtros de búsqueda
            },
          ),
        ];
      case 2: // Pharmacies
        return [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () {
              // TODO: Cambiar a vista de mapa
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Mostrar filtros de farmacias
            },
          ),
        ];
      case 3: // Reminders
        return [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // TODO: Mostrar calendario
            },
          ),
        ];
      case 4: // Profile
        return [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Navegar a configuración
            },
          ),
        ];
      default:
        return null;
    }
  }

  Widget? _buildFAB() {
    switch (_currentIndex) {
      case 1: // Search
        return FloatingActionButton(
          onPressed: () {
            // TODO: Escanear receta
          },
          child: const Icon(Icons.document_scanner),
        );
      case 3: // Reminders
        return FloatingActionButton(
          onPressed: () {
            // TODO: Agregar recordatorio
          },
          child: const Icon(Icons.add),
        );
      default:
        return null;
    }
  }
}
