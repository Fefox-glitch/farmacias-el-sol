import 'package:flutter/material.dart';
import '../../providers/provider_locator.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_view.dart';
import '../../models/pharmacy.dart';
import '../../models/reminder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final pharmacyProvider = ProviderLocator.getPharmacy(context);
    final reminderProvider = ProviderLocator.getReminder(context);

    await Future.wait([
      pharmacyProvider.getNearbyPharmacies(),
      reminderProvider.rescheduleAllReminders(),
    ]);
  }

  Widget _buildWelcomeCard() {
    final authProvider = ProviderLocator.watchAuth(context);
    final user = authProvider.currentUser;

    if (user == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: user.photoUrl != null
                  ? ClipOval(
                      child: Image.network(
                        user.photoUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Text(
                      user.nombre[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Hola, ${user.nombre}!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bienvenido/a de vuelta',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextRemindersCard() {
    final reminderProvider = ProviderLocator.watchReminder(context);
    final reminders = reminderProvider.getRemindersByDate(DateTime.now());

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Próximos Recordatorios',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navegar a recordatorios
                  },
                  child: const Text('Ver todos'),
                ),
              ],
            ),
          ),
          if (reminders.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No hay recordatorios para hoy'),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reminders.length.clamp(0, 3),
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.medication_outlined),
                  ),
                  title: Text(reminder.medicamento),
                  subtitle: Text(reminder.dosis),
                  trailing: Text(reminder.hora.format(context)),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildNearbyPharmaciesCard() {
    final pharmacyProvider = ProviderLocator.watchPharmacy(context);
    final pharmacies = pharmacyProvider.nearbyPharmacies;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Farmacias Cercanas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navegar a farmacias
                  },
                  child: const Text('Ver todas'),
                ),
              ],
            ),
          ),
          if (pharmacies.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No hay farmacias cercanas'),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pharmacies.length.clamp(0, 3),
              itemBuilder: (context, index) {
                final pharmacy = pharmacies[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.local_pharmacy_outlined),
                  ),
                  title: Text(pharmacy.nombre),
                  subtitle: Text(pharmacy.direccion),
                  trailing: Text('${pharmacy.distancia.toStringAsFixed(1)} km'),
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pharmacyProvider = ProviderLocator.watchPharmacy(context);
    final reminderProvider = ProviderLocator.watchReminder(context);

    if (pharmacyProvider.isError || reminderProvider.isError) {
      return ErrorView(
        message: 'Error al cargar los datos',
        onRetry: _loadData,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: pharmacyProvider.isLoading || reminderProvider.isLoading
          ? const Center(child: LoadingIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildWelcomeCard(),
                  _buildNextRemindersCard(),
                  _buildNearbyPharmaciesCard(),
                ],
              ),
            ),
    );
  }
}
