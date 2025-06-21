import 'package:flutter/material.dart';
import '../../models/medicine.dart';
import '../../providers/provider_locator.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_view.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  Medicine? _editingMedicine;

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final medicineProvider = ProviderLocator.getMedicine(context);
      await medicineProvider.loadMedicines();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMedicineForm([Medicine? medicine]) {
    _editingMedicine = medicine;
    showDialog(
      context: context,
      builder: (context) {
        return MedicineFormDialog(
          medicine: medicine,
          onSave: (Medicine med) async {
            final medicineProvider = ProviderLocator.getMedicine(context);
            if (med.id == null) {
              await medicineProvider.addMedicine(med);
            } else {
              await medicineProvider.updateMedicine(med);
            }
            Navigator.of(context).pop();
            _loadMedicines();
          },
        );
      },
    );
  }

  Future<void> _deleteMedicine(String id) async {
    final medicineProvider = ProviderLocator.getMedicine(context);
    await medicineProvider.deleteMedicine(id);
    _loadMedicines();
  }

  @override
  Widget build(BuildContext context) {
    final medicineProvider = ProviderLocator.watchMedicine(context);
    final medicines = medicineProvider.medicines;

    if (_isLoading) {
      return const Center(child: LoadingIndicator());
    }

    if (_errorMessage != null) {
      return ErrorView(
        message: _errorMessage!,
        onRetry: _loadMedicines,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Productos'),
      ),
      body: medicines.isEmpty
          ? const Center(child: Text('No hay productos disponibles'))
          : ListView.builder(
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final medicine = medicines[index];
                return ListTile(
                  title: Text(medicine.nombre),
                  subtitle: Text(medicine.principioActivo),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showMedicineForm(medicine),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteMedicine(medicine.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMedicineForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MedicineFormDialog extends StatefulWidget {
  final Medicine? medicine;
  final Function(Medicine) onSave;

  const MedicineFormDialog({Key? key, this.medicine, required this.onSave}) : super(key: key);

  @override
  State<MedicineFormDialog> createState() => _MedicineFormDialogState();
}

class _MedicineFormDialogState extends State<MedicineFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _principioActivoController;
  bool _requiereReceta = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.medicine?.nombre ?? '');
    _principioActivoController = TextEditingController(text: widget.medicine?.principioActivo ?? '');
    _requiereReceta = widget.medicine?.requiereReceta ?? false;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _principioActivoController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final medicine = Medicine(
      id: widget.medicine?.id,
      nombre: _nombreController.text.trim(),
      principioActivo: _principioActivoController.text.trim(),
      requiereReceta: _requiereReceta,
    );

    widget.onSave(medicine);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.medicine == null ? 'Crear Producto' : 'Editar Producto'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _principioActivoController,
                decoration: const InputDecoration(labelText: 'Principio Activo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el principio activo';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('Requiere Receta'),
                value: _requiereReceta,
                onChanged: (value) {
                  setState(() {
                    _requiereReceta = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
