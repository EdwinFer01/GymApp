import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/domain/entities/auth_user.dart';
import '../../domain/entities/training_session.dart';
import '../viewmodels/client_training_view_model.dart';
import 'training_booking_view.dart';

class ClientTrainingScheduleView extends StatelessWidget {
  const ClientTrainingScheduleView({super.key, required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClientTrainingViewModel>(
      create: (_) => ClientTrainingViewModel(clientId: user.id)..load(),
      child: const _TrainingScheduleContent(),
    );
  }
}

class _TrainingScheduleContent extends StatelessWidget {
  const _TrainingScheduleContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.watch<ClientTrainingViewModel>();
    final sessions = viewModel.sessions;
    final isBusy = viewModel.isBusy;
    final error = viewModel.lastError;

    return RefreshIndicator(
      onRefresh: viewModel.load,
      child: ListView(
        key: const ValueKey('client-training-schedule'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        children: [
          Text(
            'Agenda tus entrenamientos',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Organiza tus proximas sesiones y mantente al dia con tu plan.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Proximas sesiones',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: () => _handleScheduleTraining(context),
                icon: const Icon(Icons.event_available_outlined),
                label: const Text('Agendar'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isBusy && sessions.isEmpty)
            const _ScheduleLoading()
          else if (sessions.isEmpty)
            _EmptyScheduleNotice(theme: theme)
          else
            ...sessions.map(
              (session) => _ClientTrainingSessionCard(
                session: session,
                canEdit: _canModifyTrainingSession(session),
                onEdit: () => _editTrainingSession(context, session),
                onDelete: () => _deleteTrainingSession(context, session),
              ),
            ),
          if (isBusy && sessions.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text(
                  'Actualizando lista...',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ],
          if (error != null) ...[
            const SizedBox(height: 16),
            Text(
              error,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ScheduleLoading extends StatelessWidget {
  const _ScheduleLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

void _handleScheduleTraining(BuildContext context) {
  final trainingViewModel = context.read<ClientTrainingViewModel>();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (modalContext) {
      final theme = Theme.of(modalContext);
      final options = <_TrainingOption>[
        _trainingOptionForType(TrainingType.standard),
        _trainingOptionForType(TrainingType.circuit),
        _trainingOptionForType(TrainingType.custom),
        _trainingOptionForType(TrainingType.superset),
      ];

      return SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            24,
            16,
            24,
            24 + MediaQuery.of(modalContext).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Elige el tipo de entrenamiento',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Selecciona la modalidad que deseas agendar.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              ...options.map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer
                          .withValues(alpha: 0.25),
                      foregroundColor: theme.colorScheme.primary,
                      child: Icon(option.icon),
                    ),
                    title: Text(
                      option.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(option.description),
                    onTap: () async {
                      Navigator.of(modalContext).pop();
                      final booked = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (_) =>
                              ChangeNotifierProvider<
                                ClientTrainingViewModel
                              >.value(
                                value: trainingViewModel,
                                child: TrainingBookingView(
                                  trainingTitle: option.title,
                                  trainingDescription: option.description,
                                  trainingIcon: option.icon,
                                  trainingType: option.type,
                                ),
                              ),
                        ),
                      );
                      if (booked == true && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Entrenamiento "${option.title}" agendado.',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _editTrainingSession(
  BuildContext context,
  TrainingSession session,
) async {
  if (!_canModifyTrainingSession(session)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Solo puedes editar hasta una hora antes del inicio.'),
      ),
    );
    return;
  }

  final trainingViewModel = context.read<ClientTrainingViewModel>();
  final option = _trainingOptionForType(session.type);
  final updated = await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (_) => ChangeNotifierProvider<ClientTrainingViewModel>.value(
        value: trainingViewModel,
        child: TrainingBookingView(
          trainingTitle: session.title,
          trainingDescription: option.description,
          trainingIcon: option.icon,
          trainingType: session.type,
          existingSession: session,
        ),
      ),
    ),
  );

  if (updated == true && context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Entrenamiento actualizado.')));
  }
}

Future<void> _deleteTrainingSession(
  BuildContext context,
  TrainingSession session,
) async {
  final confirmed =
      await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Eliminar entrenamiento'),
          content: Text('Seguro que quieres eliminar "${session.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        ),
      ) ??
      false;
  if (!confirmed || !context.mounted) return;

  final trainingViewModel = context.read<ClientTrainingViewModel>();
  final success = await trainingViewModel.deleteTraining(session);

  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        success
            ? 'Entrenamiento eliminado.'
            : 'No pudimos eliminar el entrenamiento.',
      ),
    ),
  );
}

bool _canModifyTrainingSession(TrainingSession session) {
  final threshold = DateTime.now().add(const Duration(hours: 1));
  return session.scheduledAt.isAfter(threshold);
}

class _TrainingOption {
  const _TrainingOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.type,
  });

  final IconData icon;
  final String title;
  final String description;
  final TrainingType type;
}

_TrainingOption _trainingOptionForType(TrainingType type) {
  switch (type) {
    case TrainingType.standard:
      return const _TrainingOption(
        icon: Icons.fitness_center_outlined,
        title: 'Entrenamiento de fuerza',
        description: 'Sesiones enfocadas en fuerza y resistencia.',
        type: TrainingType.standard,
      );
    case TrainingType.superset:
      return const _TrainingOption(
        icon: Icons.group_outlined,
        title: 'Grupales',
        description: 'Agenda sesiones compartidas con otros miembros.',
        type: TrainingType.superset,
      );
    case TrainingType.triset:
      return const _TrainingOption(
        icon: Icons.repeat_outlined,
        title: 'Triset',
        description: 'Tres ejercicios consecutivos sin descanso.',
        type: TrainingType.triset,
      );
    case TrainingType.circuit:
      return const _TrainingOption(
        icon: Icons.directions_run_outlined,
        title: 'Cardio intensivo',
        description: 'Clases para mejorar resistencia aerobica.',
        type: TrainingType.circuit,
      );
    case TrainingType.custom:
      return const _TrainingOption(
        icon: Icons.self_improvement_outlined,
        title: 'Rehabilitacion',
        description: 'Movilidad, estiramientos y recuperacion guiada.',
        type: TrainingType.custom,
      );
  }
}

class _ClientTrainingSessionCard extends StatelessWidget {
  const _ClientTrainingSessionCard({
    required this.session,
    required this.canEdit,
    required this.onEdit,
    required this.onDelete,
  });

  final TrainingSession session;
  final bool canEdit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final option = _trainingOptionForType(session.type);
    final scheduleText = _formatSessionDateTime(context, session.scheduledAt);
    final trainerText = (session.notes ?? '').trim().isEmpty
        ? 'Entrenador por asignar'
        : 'Entrenador: ${session.notes}';
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            foregroundColor: theme.colorScheme.primary,
            child: Icon(option.icon),
          ),
          title: Text(
            session.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(scheduleText),
              const SizedBox(height: 4),
              Text(trainerText),
              if (!canEdit) ...[
                const SizedBox(height: 8),
                Text(
                  'La edicion se habilita solo hasta 1 hora antes.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
          trailing: PopupMenuButton<_TrainingCardAction>(
            onSelected: (action) {
              switch (action) {
                case _TrainingCardAction.edit:
                  if (canEdit) {
                    onEdit();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Solo puedes editar hasta una hora antes del inicio.',
                        ),
                      ),
                    );
                  }
                  break;
                case _TrainingCardAction.delete:
                  onDelete();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<_TrainingCardAction>(
                value: _TrainingCardAction.edit,
                enabled: canEdit,
                child: const Text('Editar'),
              ),
              const PopupMenuItem<_TrainingCardAction>(
                value: _TrainingCardAction.delete,
                child: Text('Eliminar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatSessionDateTime(BuildContext context, DateTime value) {
    final localizations = MaterialLocalizations.of(context);
    final date = localizations.formatMediumDate(value);
    final time = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(value),
      alwaysUse24HourFormat:
          MediaQuery.maybeOf(context)?.alwaysUse24HourFormat ?? false,
    );
    return '$date - $time';
  }
}

enum _TrainingCardAction { edit, delete }

class _EmptyScheduleNotice extends StatelessWidget {
  const _EmptyScheduleNotice({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.event_note_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sin sesiones programadas',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Agenda tu primera sesion desde el boton de arriba.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
