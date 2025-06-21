import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
import 'custom_app_bar.dart';

class BaseScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final int currentIndex;
  final Function(int) onNavItemTap;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;
  final bool showAppBar;
  final bool showBottomNav;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Widget? drawer;
  final Widget? endDrawer;

  const BaseScreen({
    Key? key,
    required this.title,
    required this.body,
    required this.currentIndex,
    required this.onNavItemTap,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = false,
    this.showAppBar = true,
    this.showBottomNav = true,
    this.bottomSheet,
    this.backgroundColor,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawer,
    this.endDrawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? CustomAppBar(
              title: title,
              showBackButton: showBackButton,
              actions: actions,
            )
          : null,
      body: SafeArea(
        bottom: !showBottomNav,
        child: body,
      ),
      bottomNavigationBar: showBottomNav
          ? BottomNavBar(
              currentIndex: currentIndex,
              onTap: onNavItemTap,
            )
          : null,
      floatingActionButton: floatingActionButton,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      drawer: drawer,
      endDrawer: endDrawer,
    );
  }
}

class BaseScreenState<T extends StatefulWidget> extends State<T> {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  @protected
  void onNavItemTap(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    // Implementar navegación según el índice
    switch (index) {
      case 0:
        // Inicio
        break;
      case 1:
        // Buscar
        break;
      case 2:
        // Farmacias
        break;
      case 3:
        // Recordatorios
        break;
      case 4:
        // Perfil
        break;
    }
  }

  @protected
  PreferredSizeWidget buildAppBar({
    required String title,
    List<Widget>? actions,
    bool showBackButton = false,
  }) {
    return CustomAppBar(
      title: title,
      showBackButton: showBackButton,
      actions: actions,
    );
  }

  @protected
  Widget buildBottomNavBar() {
    return BottomNavBar(
      currentIndex: _currentIndex,
      onTap: onNavItemTap,
    );
  }

  @protected
  Widget buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @protected
  Widget buildErrorView(String message, {VoidCallback? onRetry}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
          ],
        ],
      ),
    );
  }

  @protected
  Widget buildEmptyView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}
