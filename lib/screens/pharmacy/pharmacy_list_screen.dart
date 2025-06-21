import 'package:flutter/material.dart';
import '../../providers/provider_locator.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_view.dart';
import '../../models/pharmacy.dart';

class PharmacyListScreen extends StatefulWidget {
  const PharmacyListScreen({Key? key}) : super(key: key);

  @override
  State<PharmacyListScreen> createState() => _PharmacyListScreenState();
}

class _PharmacyListScreenState extends State<PharmacyListScreen> {
  @override
  void initState() {
    super.initState();
    _loadPharmacies();
  }

  Future<void> _loadPharmacies() async {
    final pharmacyProvider = ProviderLocator.getPharmacy(context);
    await pharmacyProvider.getNearbyPharmacies();
  }

  Future<void> _refreshPharmacies() async {
    final pharmacyProvider = ProviderLocator.getPharmacy(context);
    await pharmacyProvider.refreshNearbyPharmacies();
  }

  Widget _buildPharmacyCard(Pharmacy pharmacy) {
    final pharmacyProvider = ProviderLocator.getPharmacy(context);
    final isFavorite = pharmacyProvider.isFavorite(pharmacy.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.local_pharmacy_outlined,
                color: Colors.white,
              ),
            ),
            title: Text(pharmacy.nombre),
            subtitle: Text(pharmacy.direccion),
            trailing: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                pharmacyProvider.toggleFavorite(pharmacy);
              },
            ),
            onTap: () {
              // TODO: Navegar al detalle de la farmacia
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Estado (Abierto/Cerrado)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: pharmacy.isOpen
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    pharmacy.isOpen ? 'Abierto' : 'Cerrado',
                    style: TextStyle(
                      color: pharmacy.isOpen ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Servicio a domicilio
                if (pharmacy.servicioADomicilio)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.delivery_dining,
                          size: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Delivery',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Distancia
                Text(
                  '${pharmacy.distancia.toStringAsFixed(1)} km',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pharmacyProvider = ProviderLocator.watchPharmacy(context);

    if (pharmacyProvider.isError) {
      return ErrorView(
        message: pharmacyProvider.errorMessage ?? 'Error al cargar las farmacias',
        onRetry: _loadPharmacies,
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshPharmacies,
      child: pharmacyProvider.isLoading && pharmacyProvider.nearbyPharmacies.isEmpty
          ? const Center(child: LoadingIndicator())
          : pharmacyProvider.nearbyPharmacies.isEmpty
              ? const ErrorView(
                  message: 'No se encontraron farmacias cercanas',
                  icon: Icons.location_off_outlined,
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pharmacyProvider.nearbyPharmacies.length,
                  itemBuilder: (context, index) {
                    final pharmacy = pharmacyProvider.nearbyPharmacies[index];
                    return _buildPharmacyCard(pharmacy);
                  },
                ),
    );
  }
}
