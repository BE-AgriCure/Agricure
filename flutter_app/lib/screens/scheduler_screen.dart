import 'package:flutter/material.dart';
import 'package:agricare/services/scheduler_service.dart';

class SchedulerScreen extends StatefulWidget {
  const SchedulerScreen({super.key});

  @override
  State<SchedulerScreen> createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
  final List<Map<String, dynamic>> _schedules = [];

  @override
  void initState() {
    super.initState();
    SchedulerService.init();
  }

  Future<void> _showAddScheduleDialog() async {
    String taskName = '';
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Schedule'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Task Name (e.g., Watering)'),
                  onChanged: (val) => taskName = val,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date: ${selectedDate.toString().split(' ')[0]}'),
                    ElevatedButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() => selectedDate = picked);
                        }
                      },
                      child: const Text('Pick Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Time: ${selectedTime.format(context)}'),
                    ElevatedButton(
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null) {
                          setState(() => selectedTime = picked);
                        }
                      },
                      child: const Text('Pick Time'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (taskName.isNotEmpty) {
                  final scheduledDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );

                  setState(() {
                    _schedules.add({
                      'id': _schedules.length,
                      'name': taskName,
                      'dateTime': scheduledDateTime,
                    });
                  });

                  SchedulerService.scheduleNotification(
                    id: _schedules.length - 1,
                    title: taskName,
                    body: 'Time for: $taskName',
                    scheduledTime: scheduledDateTime,
                  );

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$taskName scheduled!')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Care Schedule'),
        centerTitle: true,
      ),
      body: _schedules.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('No schedules yet', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _schedules.length,
              itemBuilder: (context, index) {
                final schedule = _schedules[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(schedule['name']),
                    subtitle: Text(schedule['dateTime'].toString().split('.')[0]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() => _schedules.removeAt(index));
                        SchedulerService.cancelNotification(index);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddScheduleDialog,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
