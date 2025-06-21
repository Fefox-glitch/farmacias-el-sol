import 'package:flutter/material.dart';
import '../../providers/provider_locator.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    // Obtener el provider de medicamentos
    final medicineProvider = ProviderLocator.getMedicine(context);

    // Realizar la búsqueda
    medicineProvider.searchMedicines(query: query).then((_) {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final medicineProvider = ProviderLocator.watchMedicine(context);

    return Column(
      children: [
        // Barra de búsqueda
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar medicamentos...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        medicineProvider.clearSearchResults();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: _handleSearch,
            textInputAction: TextInputAction.search,
          ),
        ),

        // Resultados de búsqueda
        Expanded(
          child: _isSearching
              ? const Center(child: LoadingIndicator())
              : medicineProvider.searchResults.isEmpty
                  ? const ErrorView(
                      message:
                          'No se encontraron resultados.\nIntenta con otra búsqueda.',
                      icon: Icons.search_off_outlined,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: medicineProvider.searchResults.length,
                      itemBuilder: (context, index) {
                        final medicine = medicineProvider.searchResults[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(medicine.nombre),
                            subtitle: Text(medicine.principioActivo),
                            trailing: medicine.requiereReceta
                                ? const Icon(
                                    Icons.medical_information_outlined,
                                    color: Colors.red,
                                  )
                                : null,
                            onTap: () {
                              // TODO: Navegar al detalle del medicamento
                            },
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
