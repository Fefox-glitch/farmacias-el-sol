import 'package:flutter/material.dart';
import '../../providers/provider_locator.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_view.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _handleLogout() async {
    final authProvider = ProviderLocator.getAuth(context);

    try {
      await authProvider.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Widget _buildProfileHeader() {
    final authProvider = ProviderLocator.watchAuth(context);
    final user = authProvider.currentUser;

    if (user == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).primaryColor,
              child: user.photoUrl != null
                  ? ClipOval(
                      child: Image.network(
                        user.photoUrl!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Text(
                      user.nombre[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
            ),

            const SizedBox(height: 16),

            // Nombre
            Text(
              user.nombre,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 4),

            // Email
            Text(
              user.email,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = ProviderLocator.watchAuth(context);

    if (authProvider.isLoading) {
      return const Center(child: LoadingIndicator());
    }

    if (authProvider.isError) {
      return ErrorView(
        message: authProvider.errorMessage ?? 'Error al cargar el perfil',
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'Editar Perfil',
            onTap: () {
              // TODO: Navegar a editar perfil
            },
          ),
          _buildMenuItem(
            icon: Icons.people_outline,
            title: 'Dependientes',
            onTap: () {
              // TODO: Navegar a dependientes
            },
          ),
          _buildMenuItem(
            icon: Icons.medical_information_outlined,
            title: 'Información Médica',
            onTap: () {
              // TODO: Navegar a información médica
            },
          ),
          _buildMenuItem(
            icon: Icons.notifications_outlined,
            title: 'Notificaciones',
            onTap: () {
              // TODO: Navegar a configuración de notificaciones
            },
            trailing: Switch(
              value: true, // TODO: Obtener estado real
              onChanged: (value) {
                // TODO: Actualizar configuración de notificaciones
              },
            ),
          ),
          const Divider(height: 32),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Ayuda',
            onTap: () {
              // TODO: Navegar a ayuda
            },
          ),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'Acerca de',
            onTap: () {
              // TODO: Mostrar información de la app
            },
          ),
          _buildMenuItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacidad',
            onTap: () {
              // TODO: Mostrar política de privacidad
            },
          ),
          const Divider(height: 32),
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Cerrar Sesión',
            onTap: _handleLogout,
            trailing: null,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
