import 'package:flutter/material.dart';

class TrainingGoalsPage extends StatefulWidget {
  const TrainingGoalsPage({super.key});

  @override
  State<TrainingGoalsPage> createState() => _TrainingGoalsPageState();
}

class _TrainingGoalsPageState extends State<TrainingGoalsPage> {
  final List<_ExerciseGoal> _goals = [];

  void _showGoalDialog({int? index}) {
    final goal = index != null ? _goals[index] : null;
    final exerciseController = TextEditingController(text: goal?.exercise);
    final weightController = TextEditingController(
      text: goal?.targetWeightString ?? '',
    );
    final weightFocusNode = FocusNode();

    Future<void> handleSave() async {
      final exercise = exerciseController.text.trim();
      final weightText = weightController.text.trim();
      if (exercise.isEmpty || weightText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Completa el ejercicio y el peso.')),
        );
        return;
      }

      final parsedWeight = double.tryParse(weightText.replaceAll(',', '.'));
      if (parsedWeight == null || parsedWeight <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ingresa un peso valido.')),
        );
        weightFocusNode.requestFocus();
        return;
      }

      final updatedGoal = _ExerciseGoal(
        exercise: exercise,
        targetWeight: parsedWeight,
      );

      setState(() {
        if (index != null) {
          _goals[index] = updatedGoal;
        } else {
          _goals.add(updatedGoal);
        }
      });

      if (!mounted) return;
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            index != null
                ? 'Objetivo actualizado'
                : 'Objetivo agregado para $exercise',
          ),
        ),
      );
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  index != null ? 'Editar objetivo' : 'Nuevo objetivo',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: exerciseController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Maquina o ejercicio',
                    hintText: 'Ej. Prensa de piernas',
                    prefixIcon: Icon(Icons.fitness_center_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: weightController,
                  focusNode: weightFocusNode,
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
                    onPressed: handleSave,
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(index != null ? 'Guardar cambios' : 'Agregar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      exerciseController.dispose();
      weightController.dispose();
      weightFocusNode.dispose();
    });
  }

  void _removeGoal(int index) {
    final removedGoal = _goals[index];
    setState(() {
      _goals.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Objetivo eliminado: ${removedGoal.exercise}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Objetivos de entrenamiento')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showGoalDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Añadir objetivo'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Define tus metas para cada ejercicio.',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Por ejemplo: prensa de piernas 120 kg, peso muerto 80 kg, o cualquier maquina que quieras trabajar.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: _goals.isEmpty
                    ? _EmptyGoalsState(onAdd: _showGoalDialog)
                    : ListView.separated(
                        itemCount: _goals.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final goal = _goals[index];
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
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                                child: Icon(
                                  Icons.fitness_center,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                              title: Text(
                                goal.exercise,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                'Peso objetivo: ${goal.targetWeightLabel}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Editar',
                                    icon: const Icon(Icons.edit_outlined),
                                    onPressed: () =>
                                        _showGoalDialog(index: index),
                                  ),
                                  IconButton(
                                    tooltip: 'Eliminar',
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => _removeGoal(index),
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

class _ExerciseGoal {
  const _ExerciseGoal({required this.exercise, required this.targetWeight});

  final String exercise;
  final double targetWeight;

  String get targetWeightLabel {
    final isInt = targetWeight == targetWeight.roundToDouble();
    return isInt
        ? '${targetWeight.toInt()} kg'
        : '${targetWeight.toStringAsFixed(1)} kg';
  }

  String get targetWeightString {
    final isInt = targetWeight == targetWeight.roundToDouble();
    return isInt ? targetWeight.toInt().toString() : targetWeight.toString();
  }
}
