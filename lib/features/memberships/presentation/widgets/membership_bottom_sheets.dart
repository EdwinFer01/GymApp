import 'package:flutter/material.dart';

import '../../domain/entities/membership.dart';

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();
  return '$day/$month/$year';
}

String _statusLabel(MembershipStatus status) {
  switch (status) {
    case MembershipStatus.active:
      return 'Activa';
    case MembershipStatus.pending:
      return 'Pendiente';
    case MembershipStatus.expired:
      return 'Vencida';
    case MembershipStatus.cancelled:
      return 'Cancelada';
  }
}

Future<void> showMembershipDetailSheet(
  BuildContext context, {
  required Membership membership,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (modalContext) {
      final theme = Theme.of(modalContext);
      final textTheme = theme.textTheme;

      final infoItems = <_DetailEntry>[
        _DetailEntry(
          icon: Icons.badge_outlined,
          label: 'Plan',
          value: membership.planName,
        ),
        _DetailEntry(
          icon: Icons.verified_outlined,
          label: 'Estado',
          value: _statusLabel(membership.status),
        ),
        _DetailEntry(
          icon: Icons.payments_outlined,
          label: 'Precio',
          value: '\$${membership.price.toStringAsFixed(2)} MXN',
        ),
        _DetailEntry(
          icon: Icons.play_circle_outline,
          label: 'Inicio',
          value: _formatDate(membership.startDate),
        ),
        _DetailEntry(
          icon: Icons.event_available_outlined,
          label: 'Fin',
          value: _formatDate(membership.endDate),
        ),
        if (membership.billingCycleDays != null)
          _DetailEntry(
            icon: Icons.schedule_outlined,
            label: 'Ciclo de cobro',
            value: '${membership.billingCycleDays} dias',
          ),
        if ((membership.notes ?? '').trim().isNotEmpty)
          _DetailEntry(
            icon: Icons.sticky_note_2_outlined,
            label: 'Notas',
            value: membership.notes!.trim(),
          ),
      ];

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Detalle de membresia',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Consulta la informacion mas reciente de tu plan.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                ...infoItems.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(entry.icon, color: theme.colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.label,
                                style: textTheme.labelLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(entry.value, style: textTheme.bodyLarge),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<bool?> showMembershipEditSheet(
  BuildContext context, {
  required Membership initialMembership,
  required Future<bool> Function(Membership membership) onSubmit,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (modalContext) {
      return _MembershipEditSheet(
        initialMembership: initialMembership,
        onSubmit: onSubmit,
      );
    },
  );
}

class _DetailEntry {
  const _DetailEntry({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class _MembershipEditSheet extends StatefulWidget {
  const _MembershipEditSheet({
    required this.initialMembership,
    required this.onSubmit,
  });

  final Membership initialMembership;
  final Future<bool> Function(Membership) onSubmit;

  @override
  State<_MembershipEditSheet> createState() => _MembershipEditSheetState();
}

enum _PlanType { daily, weekly, monthly, annual, custom }

String _planLabel(_PlanType type) {
  switch (type) {
    case _PlanType.daily:
      return 'Diario';
    case _PlanType.weekly:
      return 'Semanal';
    case _PlanType.monthly:
      return 'Mensual';
    case _PlanType.annual:
      return 'Anual';
    case _PlanType.custom:
      return 'Personalizado';
  }
}

_PlanType _planTypeFromName(String name) {
  switch (name.toLowerCase()) {
    case 'diario':
      return _PlanType.daily;
    case 'semanal':
      return _PlanType.weekly;
    case 'mensual':
      return _PlanType.monthly;
    case 'anual':
      return _PlanType.annual;
    default:
      return _PlanType.custom;
  }
}

DateTime _calculateEndDate(DateTime start, _PlanType type) {
  switch (type) {
    case _PlanType.daily:
      return start.add(const Duration(days: 1));
    case _PlanType.weekly:
      return start.add(const Duration(days: 7));
    case _PlanType.monthly:
      return DateTime(start.year, start.month + 1, start.day);
    case _PlanType.annual:
      return DateTime(start.year + 1, start.month, start.day);
    case _PlanType.custom:
      return start.add(const Duration(days: 30));
  }
}

class _MembershipEditSheetState extends State<_MembershipEditSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _priceController;
  late final TextEditingController _notesController;
  late _PlanType _planType;
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final membership = widget.initialMembership;
    _planType = _planTypeFromName(membership.planName);
    _priceController = TextEditingController(
      text: membership.price.toStringAsFixed(2),
    );
    _notesController = TextEditingController(text: membership.notes ?? '');
    _startDate = membership.startDate;
    _endDate = _planType == _PlanType.custom
        ? membership.endDate
        : _calculateEndDate(membership.startDate, _planType);
  }

  bool get _isCustomPlan => _planType == _PlanType.custom;

  void _updateEndDateForPlan() {
    if (_isCustomPlan) return;
    setState(() {
      _endDate = _calculateEndDate(_startDate, _planType);
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({
    required DateTime initialDate,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    onSelected(picked);
    setState(() {});
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final price = double.tryParse(_priceController.text.replaceAll(',', '.'));
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un precio valido.')),
      );
      return;
    }

    if (_endDate.isBefore(_startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La fecha de fin debe ser posterior a la de inicio.'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final updated = widget.initialMembership.copyWith(
      planName: _planLabel(_planType),
      price: price,
      startDate: _startDate,
      endDate: _endDate,
      billingCycleDays: _isCustomPlan
          ? null
          : _endDate.difference(_startDate).inDays,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      updatedAt: DateTime.now(),
    );

    final success = await widget.onSubmit(updated);

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Membresia actualizada.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No pudimos guardar tus cambios. Intenta nuevamente.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: EdgeInsets.fromLTRB(24, 24, 24, viewInsets + 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Actualizar membresia',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Modifica los datos de tu plan actual.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<_PlanType>(
                  initialValue: _planType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de plan',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  items: _PlanType.values
                      .map(
                        (type) => DropdownMenuItem<_PlanType>(
                          value: type,
                          child: Text(_planLabel(type)),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _planType = value;
                      if (!_isCustomPlan) {
                        _endDate = _calculateEndDate(_startDate, _planType);
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Precio mensual',
                    prefixIcon: Icon(Icons.payments_outlined),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa el precio de la membresia.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _DateField(
                        label: 'Inicio',
                        icon: Icons.play_circle_outline,
                        date: _startDate,
                        onTap: () => _pickDate(
                          initialDate: _startDate,
                          onSelected: (value) {
                            _startDate = value;
                            _updateEndDateForPlan();
                          },
                        ),
                        enabled: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _DateField(
                        label: 'Fin',
                        icon: Icons.event_available_outlined,
                        date: _endDate,
                        onTap: _isCustomPlan
                            ? () => _pickDate(
                                initialDate: _endDate,
                                onSelected: (value) {
                                  _endDate = value;
                                },
                              )
                            : null,
                        enabled: _isCustomPlan,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notas',
                    prefixIcon: Icon(Icons.sticky_note_2_outlined),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _isSubmitting ? null : _submit,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    _isSubmitting ? 'Guardando...' : 'Guardar cambios',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.icon,
    required this.date,
    required this.onTap,
    required this.enabled,
  });

  final String label;
  final IconData icon;
  final DateTime date;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          enabled: enabled,
        ),
        child: Text(_formatDate(date)),
      ),
    );
  }
}
