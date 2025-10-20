import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/domain/entities/auth_user.dart';
import '../../domain/entities/training_goal.dart';
import '../viewmodels/training_goals_view_model.dart';

class TrainingGoalsPage extends StatelessWidget {
  const TrainingGoalsPage({super.key, required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TrainingGoalsViewModel(userId: user.id)..load(),
      child: _TrainingGoalsView(displayName: user.displayName),
    );
  }
}

class _TrainingGoalsView extends StatefulWidget {
  const _TrainingGoalsView({required this.displayName});

  final String displayName;

  @override
  State<_TrainingGoalsView> createState() => _TrainingGoalsViewState();
}

class _TrainingGoalsViewState extends State<_TrainingGoalsView> {
  Future<void> _showGoalDialog({TrainingGoal? goal}) async {
    final messenger = ScaffoldMessenger.of(context);
    final viewModel = context.read<TrainingGoalsViewModel>();

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return ChangeNotifierProvider.value(
          value: viewModel,
          child: _GoalEditorSheet(initialGoal: goal),
        );
      },
    );

    if (!mounted || result == null || result.isEmpty) return;
    messenger.showSnackBar(SnackBar(content: Text(result)));
  }

  Future<void> _removeGoal(TrainingGoal goal) async {
    final viewModel = context.read<TrainingGoalsViewModel>();
    final messenger = ScaffoldMessenger.of(context);
    final success = await viewModel.deleteGoal(goal);
    if (!mounted) return;
    if (success) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Objetivo eliminado')),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            viewModel.lastError ??
                'No pudimos eliminar el objetivo. Intenta nuevamente.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.watch<TrainingGoalsViewModel>();
    final goals = viewModel.goals;
    final isBusy = viewModel.isBusy;

    return Scaffold(
      appBar: AppBar(title: const Text('Objetivos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showGoalDialog(),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Define tus metas de entrenamiento',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Agrega objetivos de peso para tus ejercicios favoritos y realiza un seguimiento de tus progresos.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: theme.colorScheme.onPrimaryContainer,
                        child: Icon(
                          Icons.flag_rounded,
                          color: theme.colorScheme.primaryContainer,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hola ${widget.displayName.split(' ').first}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Establece metas realistas y alcanzables. Actualiza tus objetivos a medida que mejores tu fuerza.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isBusy) ...[
                const SizedBox(height: 16),
                const LinearProgressIndicator(minHeight: 3),
              ],
              const SizedBox(height: 24),
              Expanded(
                child: isBusy && goals.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : goals.isEmpty
                    ? _EmptyGoalsState(onAdd: () => _showGoalDialog())
                    : ListView.separated(
                        itemCount: goals.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final goal = goals[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              leading: CircleAvatar(
                                radius: 26,
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                child: Icon(
                                  Icons.fitness_center,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                              title: Text(
                                goal.exercise,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                'Peso objetivo: ${goal.targetWeightLabel}',
                                style: theme.textTheme.bodySmall,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Editar',
                                    icon: const Icon(Icons.edit_outlined),
                                    onPressed: () =>
                                        _showGoalDialog(goal: goal),
                                  ),
                                  IconButton(
                                    tooltip: 'Eliminar',
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => _removeGoal(goal),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalEditorSheet extends StatefulWidget {
  const _GoalEditorSheet({this.initialGoal});

  final TrainingGoal? initialGoal;

  @override
  State<_GoalEditorSheet> createState() => _GoalEditorSheetState();
}

class _GoalEditorSheetState extends State<_GoalEditorSheet> {
  late final TextEditingController _exerciseController;
  late final TextEditingController _weightController;
  late final FocusNode _weightFocusNode;

  @override
  void initState() {
    super.initState();
    final goal = widget.initialGoal;
    _exerciseController = TextEditingController(text: goal?.exercise);
    _weightController = TextEditingController(
      text: goal?.targetWeightString ?? '',
    );
    _weightFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    _weightController.dispose();
    _weightFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final messenger = ScaffoldMessenger.of(context);
    final exercise = _exerciseController.text.trim();
    final weightText = _weightController.text.trim();

    if (exercise.isEmpty || weightText.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Completa el ejercicio y el peso.')),
      );
      return;
    }

    final parsedWeight = double.tryParse(weightText.replaceAll(',', '.'));
    if (parsedWeight == null || parsedWeight <= 0) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Ingresa un peso valido.')),
      );
      _weightFocusNode.requestFocus();
      return;
    }

    final viewModel = context.read<TrainingGoalsViewModel>();

    final success = await viewModel.saveGoal(
      original: widget.initialGoal,
      exercise: exercise,
      targetWeight: parsedWeight,
    );
    if (!mounted) return;

    if (!success) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            viewModel.lastError ??
                'No pudimos guardar el objetivo. Intenta nuevamente.',
          ),
        ),
      );
      return;
    }

    Navigator.of(context).pop(
      widget.initialGoal != null
          ? 'Objetivo actualizado'
          : 'Objetivo agregado para $exercise',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSaving = context.select<TrainingGoalsViewModel, bool>(
      (vm) => vm.isBusy,
    );

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.initialGoal != null ? 'Editar objetivo' : 'Nuevo objetivo',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _exerciseController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Maquina o ejercicio',
                hintText: 'Ej. Prensa de piernas',
                prefixIcon: Icon(Icons.fitness_center_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _weightController,
              focusNode: _weightFocusNode,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Peso objetivo (kg)',
                hintText: 'Ej. 100',
                prefixIcon: Icon(Icons.monitor_weight_outlined),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isSaving ? null : _handleSave,
                icon: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(
                  widget.initialGoal != null ? 'Guardar cambios' : 'Agregar',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyGoalsState extends StatelessWidget {
  const _EmptyGoalsState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flag_outlined, size: 64, color: Colors.grey.shade500),
          const SizedBox(height: 16),
          Text(
            'Aun no tienes objetivos.',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea uno para visualizar tus metas de fuerza en cada maquina.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onAdd, child: const Text('Crear objetivo')),
        ],
      ),
    );
  }
}
