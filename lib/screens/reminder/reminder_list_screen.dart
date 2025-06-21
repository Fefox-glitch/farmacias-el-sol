import 'package:flutter/material.dart';
import '../../providers/provider_locator.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_view.dart';
import '../../models/reminder.dart';
import '../../utils/helpers.dart';

class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({Key? key}) : super(key: key);

  @override
  State<ReminderListScreen> createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final reminderProvider = ProviderLocator.getReminder(context);
    await reminderProvider.rescheduleAllReminders();
  }

  Widget _buildReminderCard(Reminder reminder) {
    final medicineProvider = ProviderLocator.getMedicine(context);
    final reminderProvider = ProviderLocator.getReminder(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.medication_outlined,
                color: Colors.white,
              ),
            ),
            title: Text(reminder.medicamento),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reminder.dosis),
                Text(
                  reminder.frecuencia.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            trailing: Switch(
              value: reminder.activo,
              onChanged: (value) {
                reminderProvider.toggleReminderActive(reminder.id);
              },
            ),
            onTap: () {
              // TODO: Navegar al detalle del recordatorio
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Próxima toma
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Próxima toma: ${AppHelpers.formatTime(reminder.hora)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),

                // Botón de editar
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    // TODO: Navegar a editar recordatorio
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7, // Mostrar una semana
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          final isSelected = date.day == _selectedDate.day &&
              date.month == _selectedDate.month &&
              date.year == _selectedDate.year;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            child: Container(
              width: 60,
              margin: EdgeInsets.only(
                left: index == 0 ? 16 : 8,
                right: index == 6 ? 16 : 0,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade300,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppHelpers.getDayName(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminderProvider = ProviderLocator.watchReminder(context);
    final reminders = reminderProvider.getRemindersByDate(_selectedDate);

    if (reminderProvider.isError) {
      return ErrorView(
        message: reminderProvider.errorMessage ?? 'Error al cargar los recordatorios',
        onRetry: _loadReminders,
      );
    }

    return Column(
      children: [
        // Selector de fecha
        _buildDateSelector(),

        // Lista de recordatorios
        Expanded(
          child: reminderProvider.isLoading && reminders.isEmpty
              ? const Center(child: LoadingIndicator())
              : reminders.isEmpty
                  ? const ErrorView(
                      message: 'No hay recordatorios para este día',
                      icon: Icons.calendar_today_outlined,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: reminders.length,
                      itemBuilder: (context, index) {
                        final reminder = reminders[index];
                        return _buildReminderCard(reminder);
                      },
                    ),
        ),
      ],
    );
  }
}
