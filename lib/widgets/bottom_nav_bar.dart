import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          activeIcon: Icon(Icons.search),
          label: 'Buscar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_pharmacy_outlined),
          activeIcon: Icon(Icons.local_pharmacy),
          label: 'Farmacias',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          activeIcon: Icon(Icons.notifications),
          label: 'Recordatorios',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}

class BottomNavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;

  const BottomNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });

  static const List<BottomNavItem> items = [
    BottomNavItem(
      label: 'Inicio',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      route: '/home',
    ),
    BottomNavItem(
      label: 'Buscar',
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      route: '/search',
    ),
    BottomNavItem(
      label: 'Farmacias',
      icon: Icons.local_pharmacy_outlined,
      activeIcon: Icons.local_pharmacy,
      route: '/pharmacies',
    ),
    BottomNavItem(
      label: 'Recordatorios',
      icon: Icons.notifications_outlined,
      activeIcon: Icons.notifications,
      route: '/reminders',
    ),
    BottomNavItem(
      label: 'Perfil',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      route: '/profile',
    ),
  ];
}
