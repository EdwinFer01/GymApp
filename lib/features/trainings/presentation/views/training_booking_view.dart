import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/training_session.dart';
import '../viewmodels/client_training_view_model.dart';

class TrainingBookingView extends StatefulWidget {
  const TrainingBookingView({
    super.key,
    required this.trainingTitle,
    required this.trainingDescription,
    required this.trainingIcon,
    required this.trainingType,
    this.existingSession,
  });

  final String trainingTitle;
  final String trainingDescription;
  final IconData trainingIcon;
  final TrainingType trainingType;
  final TrainingSession? existingSession;

  @override
  State<TrainingBookingView> createState() => _TrainingBookingViewState();
}

class _TrainingBookingViewState extends State<TrainingBookingView> {
  static const List<String> _defaultTrainerOptions = <String>[
    'Natalia Vazquez',
    'Diego Rios',
    'Claudia Pereyra',
    'Martin Herrera',
  ];

  late final bool _isEditing;
  late final TrainingSession? _originalSession;
  late List<String> _trainerOptions;
  late DateTime _selectedDateTime;
  late String _selectedTrainer;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.existingSession != null;
    _originalSession = widget.existingSession;
    _trainerOptions = List<String>.from(_defaultTrainerOptions);

    final existing = _originalSession;
    if (_isEditing && existing != null) {
      _selectedDateTime = existing.scheduledAt;
      final rawTrainer = (existing.notes ?? '').trim();
      if (rawTrainer.isNotEmpty && !_trainerOptions.contains(rawTrainer)) {
        _trainerOptions.insert(0, rawTrainer);
      }
      _selectedTrainer = rawTrainer.isNotEmpty
          ? rawTrainer
          : _trainerOptions.first;
    } else {
      _selectedDateTime = DateTime.now().add(const Duration(hours: 1));
      _selectedTrainer = _trainerOptions.first;
    }
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final initial = _selectedDateTime.isBefore(now)
        ? now.add(const Duration(minutes: 30))
        : _selectedDateTime;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: now.add(const Duration(days: 180)),
    );
    if (!mounted) return;
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (!mounted) return;
    if (pickedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _confirmBooking() async {
    if (_selectedDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una fecha y hora futuras.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final viewModel = context.read<ClientTrainingViewModel>();
    final success = await viewModel.scheduleTraining(
      original: _originalSession,
      title: widget.trainingTitle,
      type: widget.trainingType,
      scheduledAt: _selectedDateTime,
      trainer: _selectedTrainer,
    );
    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No pudimos agendar el entrenamiento.')),
      );
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Editar entrenamiento' : 'Agendar entrenamiento',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: theme.colorScheme.primaryContainer,
                foregroundColor: theme.colorScheme.primary,
                child: Icon(widget.trainingIcon, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.trainingTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.trainingDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Selecciona fecha y hora',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _BookingField(
            icon: Icons.calendar_month_outlined,
            label: 'Fecha y hora',
            value: _formatSelectedDateTime(context),
            onTap: _pickDateTime,
          ),
          const SizedBox(height: 24),
          Text(
            'Elige entrenador',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedTrainer,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              labelText: 'Entrenador asignado',
            ),
            items: _trainerOptions
                .map(
                  (trainer) => DropdownMenuItem<String>(
                    value: trainer,
                    child: Text(trainer),
                  ),
                )
                .toList(growable: false),
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selectedTrainer = value);
            },
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: _isSubmitting ? null : _confirmBooking,
            icon: _isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: Text(
              _isSubmitting
                  ? 'Guardando...'
                  : _isEditing
                  ? 'Actualizar'
                  : 'Confirmar',
            ),
          ),
        ],
      ),
    );
  }

  String _formatSelectedDateTime(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final always24h =
        MediaQuery.maybeOf(context)?.alwaysUse24HourFormat ?? false;
    final dateText = localizations.formatMediumDate(_selectedDateTime);
    final timeText = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(_selectedDateTime),
      alwaysUse24HourFormat: always24h,
    );
    return '$dateText - $timeText';
  }
}

class _BookingField extends StatelessWidget {
  const _BookingField({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        child: Text(value),
      ),
    );
  }
}
