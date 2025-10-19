import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/domain/entities/auth_user.dart';
import '../../../memberships/domain/entities/membership.dart';
import '../../../memberships/presentation/viewmodels/client_membership_view_model.dart';
import '../../../memberships/presentation/widgets/membership_bottom_sheets.dart';
import '../../../progress/domain/entities/progress_record.dart';
import '../viewmodels/client_progress_view_model.dart';
import '../viewmodels/home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(user: user),
      child: const _HomeViewBody(),
    );
  }
}

class _HomeViewBody extends StatelessWidget {
  const _HomeViewBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final tabs = _HomeTabsBuilder.forUser(viewModel.user);

    final currentIndex = tabs.isEmpty
        ? 0
        : math.max(0, math.min(viewModel.currentIndex, tabs.length - 1));
    final subtitle = _HomeCopy.subtitleForRole(viewModel.user.role);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade50,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Gym App',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'Notificaciones',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: tabs.isEmpty ? const SizedBox.shrink() : tabs[currentIndex].page,
      ),
      bottomNavigationBar: tabs.isEmpty
          ? null
          : NavigationBar(
              height: 72,
              selectedIndex: currentIndex,
              onDestinationSelected: (index) =>
                  viewModel.onTabSelected(index, tabs.length),
              indicatorColor: Colors.blueGrey.shade100,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              destinations: tabs
                  .map((tab) => tab.destination)
                  .toList(growable: false),
            ),
    );
  }
}

class _HomeTabConfig {
  const _HomeTabConfig({required this.destination, required this.page});

  final NavigationDestination destination;
  final Widget page;
}

class _HomeTabsBuilder {
  static List<_HomeTabConfig> forUser(AuthUser user) {
    switch (user.role) {
      case AuthRole.admin:
        return [
          _HomeTabConfig(
            destination: const NavigationDestination(
              icon: Icon(Icons.auto_graph_outlined),
              selectedIcon: Icon(Icons.auto_graph),
              label: 'Insights',
            ),
            page: const _AdminInsightsPage(),
          ),
          _HomeTabConfig(
            destination: const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            page: const _AdminDashboardPage(),
          ),
          _HomeTabConfig(
            destination: const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
            page: const _ProfilePage(role: AuthRole.admin),
          ),
        ];
      case AuthRole.coach:
        return [
          _HomeTabConfig(
            destination: const NavigationDestination(
              icon: Icon(Icons.schedule_outlined),
              selectedIcon: Icon(Icons.schedule),
              label: 'Agenda',
            ),
            page: const _CoachSchedulePage(),
          ),
          _HomeTabConfig(
            destination: const NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Inicio',
            ),
            page: const _CoachDashboardPage(),
          ),
          _HomeTabConfig(
            destination: const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
            page: const _ProfilePage(role: AuthRole.coach),
          ),
        ];
      case AuthRole.client:
        return [
          _HomeTabConfig(
            destination: const NavigationDestination(
              icon: Icon(Icons.show_chart_outlined),
              selectedIcon: Icon(Icons.show_chart),
              label: 'Progreso',
            ),
            page: _ClientProgressPage(user: user),
          ),
          _HomeTabConfig(
            destination: const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            page: _ClientHomePage(user: user),
          ),
          _HomeTabConfig(
            destination: const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
            page: const _ProfilePage(role: AuthRole.client),
          ),
        ];
    }
  }
}

class _HomeCopy {
  static String subtitleForRole(AuthRole role) {
    switch (role) {
      case AuthRole.admin:
        return 'Gestiona tu gimnasio sin complicaciones';
      case AuthRole.coach:
        return 'Organiza entrenamientos y progreso de tus atletas';
      case AuthRole.client:
        return 'Sigue tu plan, progreso y proximas sesiones';
    }
  }

  static String roleDisplay(AuthRole role) {
    switch (role) {
      case AuthRole.admin:
        return 'Administrador';
      case AuthRole.coach:
        return 'Entrenador';
      case AuthRole.client:
        return 'Cliente';
    }
  }

  static List<_ProfileAction> profileActions(AuthRole role) {
    switch (role) {
      case AuthRole.admin:
        return const [
          _ProfileAction(
            title: 'Configuracion general',
            subtitle: 'Gestiona usuarios, permisos y politicas.',
            icon: Icons.settings_outlined,
          ),
          _ProfileAction(
            title: 'Centro de ayuda',
            subtitle: 'Accede a guias y soporte de tu equipo.',
            icon: Icons.help_outline,
          ),
          _ProfileAction(
            title: 'Cerrar sesion',
            subtitle: 'Vuelve a la pantalla de acceso.',
            icon: Icons.logout,
          ),
        ];
      case AuthRole.coach:
        return const [
          _ProfileAction(
            title: 'Mis clientes',
            subtitle: 'Crea rutinas, controla asistencia y evaluaciones.',
            icon: Icons.people_outline,
          ),
          _ProfileAction(
            title: 'Preferencias',
            subtitle: 'Actualiza tus horarios y disponibilidad.',
            icon: Icons.tune,
          ),
          _ProfileAction(
            title: 'Cerrar sesion',
            subtitle: 'Salir de la cuenta actual.',
            icon: Icons.logout,
          ),
        ];
      case AuthRole.client:
        return const [
          _ProfileAction(
            title: 'Mi plan',
            subtitle: 'Consulta tu plan actual y facturacion.',
            icon: Icons.assignment_outlined,
          ),
          _ProfileAction(
            title: 'Preferencias',
            subtitle: 'Actualiza objetivos y recordatorios.',
            icon: Icons.favorite_outline,
          ),
          _ProfileAction(
            title: 'Cerrar sesion',
            subtitle: 'Salir de la cuenta actual.',
            icon: Icons.logout,
          ),
        ];
    }
  }
}

class _AdminDashboardPage extends StatelessWidget {
  const _AdminDashboardPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      key: const ValueKey('admin-dashboard'),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [Colors.blueGrey.shade700, Colors.blueGrey.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resumen diario',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _MetricChip(
                    icon: Icons.people,
                    label: 'Clientes activos',
                    value: '128',
                    color: Colors.orange.shade200,
                  ),
                  const SizedBox(width: 16),
                  _MetricChip(
                    icon: Icons.fitness_center,
                    label: 'Sesiones hoy',
                    value: '42',
                    color: Colors.teal.shade200,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blueGrey.shade700,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Crear nueva inscripcion'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Accesos rapidos',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: const [
            _QuickActionCard(
              icon: Icons.assignment_outlined,
              title: 'Membresias',
              description: 'Renueva, suspende o crea nuevas membresias.',
              color: Color(0xFFEEF2FF),
            ),
            _QuickActionCard(
              icon: Icons.inventory_2_outlined,
              title: 'Inventario',
              description: 'Administra ropa, accesorios y suplementos.',
              color: Color(0xFFEFFCF6),
            ),
            _QuickActionCard(
              icon: Icons.bar_chart_outlined,
              title: 'Progreso',
              description: 'Revisa medidas y objetivos de clientes.',
              color: Color(0xFFFFF6E5),
            ),
            _QuickActionCard(
              icon: Icons.schedule_outlined,
              title: 'Agenda',
              description: 'Organiza entrenamientos y clases grupales.',
              color: Color(0xFFF4ECFF),
            ),
          ],
        ),
      ],
    );
  }
}

class _AdminInsightsPage extends StatelessWidget {
  const _AdminInsightsPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      key: const ValueKey('admin-insights'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_graph, size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Panel de insights',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pronto veras aqui metricas detalladas de tu gimnasio.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CoachSchedulePage extends StatelessWidget {
  const _CoachSchedulePage();

  @override
  Widget build(BuildContext context) {
    final sessions = [
      const _ScheduleItem(
        title: 'Entrenamiento fuerza',
        subtitle: '08:00 - 09:00 | Sala principal',
        badgeText: 'Cliente: Ana Ruiz',
      ),
      const _ScheduleItem(
        title: 'Clase HIIT',
        subtitle: '10:30 - 11:15 | Sala A',
        badgeText: 'Participantes: 12',
      ),
      const _ScheduleItem(
        title: 'Evaluacion mensual',
        subtitle: '13:00 - 13:45 | Sala evaluacion',
        badgeText: 'Cliente: Marco Diaz',
      ),
    ];

    return ListView.builder(
      key: const ValueKey('coach-schedule'),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      itemCount: sessions.length,
      itemBuilder: (context, index) => sessions[index],
    );
  }
}

class _CoachDashboardPage extends StatelessWidget {
  const _CoachDashboardPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      key: const ValueKey('coach-dashboard'),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          color: theme.colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resumen del dia',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: const [
                    _CoachStatCard(
                      icon: Icons.event_available,
                      label: 'Sesiones',
                      value: '6',
                    ),
                    _CoachStatCard(
                      icon: Icons.pending_actions_outlined,
                      label: 'Evaluaciones',
                      value: '3',
                    ),
                    _CoachStatCard(
                      icon: Icons.message_outlined,
                      label: 'Mensajes',
                      value: '5',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Clientes destacados',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const _CoachClientCard(
          name: 'Carla Gutierrez',
          progress: 'Objetivo: bajar 3kg (70% completado)',
          status: 'Sesion agendada manana',
        ),
        const _CoachClientCard(
          name: 'Luis Medina',
          progress: 'Objetivo: +5kg fuerza (50% completado)',
          status: 'Actualizar rutina semanal',
        ),
      ],
    );
  }
}

class _ClientHomePage extends StatelessWidget {
  const _ClientHomePage({required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClientMembershipViewModel>(
      create: (_) => ClientMembershipViewModel(user: user)..load(),
      child: const _ClientHomeContent(),
    );
  }
}

class _ClientHomeContent extends StatelessWidget {
  const _ClientHomeContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final membershipViewModel = context.watch<ClientMembershipViewModel>();
    final membership = membershipViewModel.currentMembership;
    final showClasses = _shouldShowClassesSection(membership);
    final isBusy = membershipViewModel.isBusy;
    final error = membershipViewModel.lastError;

    return ListView(
      key: const ValueKey('client-home'),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          color: theme.colorScheme.primaryContainer,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: membership == null
                ? null
                : () => _handleMembershipDetail(context, membership),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tu membresia',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (isBusy && membership == null)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      ),
                    )
                  else if (membership == null)
                    Text(
                      'Aun no registras una membresia activa. Usa Actualizar '
                      'para agregar los datos de tu plan.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    )
                  else ...[
                    Text(
                      membership.planName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Vence el ${_formatMembershipDate(membership.endDate)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onPrimaryContainer.withValues(
                          alpha: 0.12,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Text(
                          'Estado: ${_membershipStatusLabel(membership.status)}',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                    if ((membership.notes ?? '').trim().isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        membership.notes!.trim(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ],
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: isBusy
                        ? null
                        : () => _handleEditMembership(
                            context,
                            membershipViewModel,
                          ),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Actualizar'),
                  ),
                  if (!isBusy && error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      error,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (showClasses) ...[
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tus proximas clases',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: () => _handleScheduleTraining(context),
                icon: const Icon(Icons.event_available_outlined),
                label: const Text('Agendar entrenamiento'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _ClientScheduleCard(
            title: 'Funcional',
            datetime: 'Hoy - 19:00',
            trainer: 'Entrenador: Natalia Vazquez',
          ),
          const _ClientScheduleCard(
            title: 'Boxing Fit',
            datetime: 'Manana - 08:00',
            trainer: 'Entrenador: Diego Rios',
          ),
        ],
      ],
    );
  }
}

void _handleMembershipDetail(BuildContext context, Membership membership) {
  showMembershipDetailSheet(context, membership: membership);
}

Future<void> _handleEditMembership(
  BuildContext context,
  ClientMembershipViewModel viewModel,
) async {
  final membership =
      viewModel.currentMembership ?? _emptyMembership(viewModel.clientId);

  await showMembershipEditSheet(
    context,
    initialMembership: membership,
    onSubmit: viewModel.saveMembership,
  );
}

void _handleScheduleTraining(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (modalContext) {
      final theme = Theme.of(modalContext);
      final options = <_TrainingOption>[
        const _TrainingOption(
          icon: Icons.fitness_center_outlined,
          title: 'Entrenamiento de fuerza',
          description: 'Sesiones centradas en levantamiento y resistencia.',
        ),
        const _TrainingOption(
          icon: Icons.directions_run_outlined,
          title: 'Cardio intensivo',
          description: 'Clases para mejorar tu resistencia aeróbica.',
        ),
        const _TrainingOption(
          icon: Icons.self_improvement_outlined,
          title: 'Rehabilitación',
          description: 'Enfoque en movilidad, estiramientos y recuperación.',
        ),
        const _TrainingOption(
          icon: Icons.group_outlined,
          title: 'Grupales',
          description: 'Agenda sesiones compartidas con otros miembros.',
        ),
      ];

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                    onTap: () {
                      Navigator.of(modalContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Abriremos la agenda para "${option.title}" pronto.',
                          ),
                        ),
                      );
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

String _formatMembershipDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();
  return '$day/$month/$year';
}

String _membershipStatusLabel(MembershipStatus status) {
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

Membership _emptyMembership(int clientId) {
  final now = DateTime.now();
  return Membership(
    clientId: clientId,
    planName: 'Personalizado',
    price: 0,
    startDate: now,
    endDate: now.add(const Duration(days: 30)),
    status: MembershipStatus.pending,
    billingCycleDays: null,
  );
}

bool _shouldShowClassesSection(Membership? membership) {
  if (membership == null) return false;
  final isActive = membership.status == MembershipStatus.active;
  final isCustomPlan =
      membership.planName.toLowerCase().trim() == 'personalizado';
  return isActive && isCustomPlan;
}

class _ClientProgressPage extends StatelessWidget {
  const _ClientProgressPage({required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClientProgressViewModel>(
      create: (_) => ClientProgressViewModel(user: user)..load(),
      child: const _ClientProgressBody(),
    );
  }
}

class _TrainingOption {
  const _TrainingOption({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

class _ClientProgressBody extends StatelessWidget {
  const _ClientProgressBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ClientProgressViewModel>();

    return ListView(
      key: const ValueKey('client-progress'),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      children: [
        _NavigationCard(
          icon: Icons.monitor_weight_outlined,
          title: 'Mediciones corporales',
          description: 'Consulta y administra tu historial de medidas.',
          onTap: () => _openMeasurements(context),
        ),
        const SizedBox(height: 16),
        _NavigationCard(
          icon: Icons.fitness_center_outlined,
          title: 'Registro de ejercicios',
          description: 'Revisa tus entrenamientos y cargas registradas.',
          onTap: () => _openExercises(context),
        ),
        if (viewModel.lastError != null) ...[
          const SizedBox(height: 16),
          _StatusBanner(message: viewModel.lastError!, color: Colors.orange),
        ],
      ],
    );
  }

  void _openMeasurements(BuildContext context) {
    final viewModel = context.read<ClientProgressViewModel>();
    Navigator.of(context)
        .push<bool>(
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: viewModel,
              child: const _MeasurementsHistoryView(),
            ),
          ),
        )
        .then((saved) {
          if (saved == true && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mediciones registradas correctamente'),
                backgroundColor: Colors.green,
              ),
            );
          }
        });
  }

  void _openExercises(BuildContext context) {
    final viewModel = context.read<ClientProgressViewModel>();
    Navigator.of(context)
        .push<bool>(
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: viewModel,
              child: const _ExercisesHistoryView(),
            ),
          ),
        )
        .then((saved) {
          if (saved == true && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ejercicio registrado correctamente'),
                backgroundColor: Colors.green,
              ),
            );
          }
        });
  }
}

class _NavigationCard extends StatelessWidget {
  const _NavigationCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.blueGrey.shade100,
          child: Icon(icon, color: Colors.blueGrey.shade800),
        ),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(description),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.message, required this.color});

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
      ),
    );
  }
}

class _MeasurementsHistoryView extends StatelessWidget {
  const _MeasurementsHistoryView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ClientProgressViewModel>();
    final records = viewModel.records
        .where(_isMeasurementRecord)
        .toList(growable: false);

    Future<void> handleEdit(ProgressRecord record) async {
      final saved = await _showProgressForm(
        context: context,
        viewModel: viewModel,
        type: _ProgressEntryType.measurements,
        initialRecord: record,
      );
      if (saved == true && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Medicion actualizada'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    }

    Future<void> handleDelete(ProgressRecord record) async {
      final recordId = record.id;
      if (recordId == null) return;
      final confirm = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Eliminar medicion'),
            content: const Text(
              'Esta accion eliminara la medicion seleccionada. '
              'Deseas continuar?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Eliminar'),
              ),
            ],
          );
        },
      );
      if (confirm != true) return;

      final success = await viewModel.deleteRecord(recordId);
      if (!context.mounted) return;

      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Medicion eliminada'
                : (viewModel.lastError ??
                      'No se pudo eliminar la medicion. Intenta de nuevo.'),
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mediciones corporales')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: _ProgressHistoryList(
          isLoading: viewModel.isBusy && records.isEmpty,
          emptyMessage:
              'Aun no registras mediciones. Utiliza el boton para agregar una.',
          records: records,
          itemBuilder: (context, record) => _ProgressLogTile(
            title: 'Medicion corporal',
            description: _buildMeasurementDescription(record),
            date: _formatRecordTimestamp(context, record.recordedAt),
            onEdit: () => handleEdit(record),
            onDelete: () => handleDelete(record),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.isBusy
            ? null
            : () async {
                final saved = await _showProgressForm(
                  context: context,
                  viewModel: viewModel,
                  type: _ProgressEntryType.measurements,
                  initialRecord: null,
                );
                if (saved == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mediciones registradas correctamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ExercisesHistoryView extends StatelessWidget {
  const _ExercisesHistoryView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ClientProgressViewModel>();
    final records = viewModel.records
        .where(_isExerciseRecord)
        .toList(growable: false);

    Future<void> handleEdit(ProgressRecord record) async {
      final saved = await _showProgressForm(
        context: context,
        viewModel: viewModel,
        type: _ProgressEntryType.exercise,
        initialRecord: record,
      );
      if (saved == true && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ejercicio actualizado'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    }

    Future<void> handleDelete(ProgressRecord record) async {
      final recordId = record.id;
      if (recordId == null) return;
      final confirm = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Eliminar ejercicio'),
            content: const Text(
              'Esta accion eliminara el registro de ejercicio seleccionado. '
              'Deseas continuar?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Eliminar'),
              ),
            ],
          );
        },
      );
      if (confirm != true) return;

      final success = await viewModel.deleteRecord(recordId);
      if (!context.mounted) return;

      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Ejercicio eliminado'
                : (viewModel.lastError ??
                      'No se pudo eliminar el ejercicio. Intenta de nuevo.'),
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Registro de ejercicios')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: _ProgressHistoryList(
          isLoading: viewModel.isBusy && records.isEmpty,
          emptyMessage:
              'Aun no registras ejercicios. Utiliza el boton para agregar uno.',
          records: records,
          itemBuilder: (context, record) => _ProgressLogTile(
            title: record.exerciseName ?? 'Entrenamiento',
            description: _buildExerciseDescription(record),
            date: _formatRecordTimestamp(context, record.recordedAt),
            onEdit: () => handleEdit(record),
            onDelete: () => handleDelete(record),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.isBusy
            ? null
            : () async {
                final saved = await _showProgressForm(
                  context: context,
                  viewModel: viewModel,
                  type: _ProgressEntryType.exercise,
                  initialRecord: null,
                );
                if (saved == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ejercicio registrado correctamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProgressHistoryList extends StatelessWidget {
  const _ProgressHistoryList({
    required this.isLoading,
    required this.emptyMessage,
    required this.records,
    required this.itemBuilder,
  });

  final bool isLoading;
  final String emptyMessage;
  final List<ProgressRecord> records;
  final Widget Function(BuildContext context, ProgressRecord) itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (records.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
        ),
      );
    }
    return ListView.separated(
      itemCount: records.length,
      itemBuilder: (context, index) => itemBuilder(context, records[index]),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
    );
  }
}

enum _ProgressEntryType { measurements, exercise }

Future<bool?> _showProgressForm({
  required BuildContext context,
  required ClientProgressViewModel viewModel,
  required _ProgressEntryType type,
  ProgressRecord? initialRecord,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (modalContext) {
      return ChangeNotifierProvider.value(
        value: viewModel,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(modalContext).viewInsets.bottom,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _ProgressEntryForm(
                entryType: type,
                initialRecord: initialRecord,
                onCancel: () => Navigator.of(modalContext).pop(false),
                onSuccess: () => Navigator.of(modalContext).pop(true),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _ProgressEntryForm extends StatefulWidget {
  const _ProgressEntryForm({
    required this.entryType,
    required this.onCancel,
    required this.onSuccess,
    this.initialRecord,
  });

  final _ProgressEntryType entryType;
  final VoidCallback onCancel;
  final VoidCallback onSuccess;
  final ProgressRecord? initialRecord;

  @override
  State<_ProgressEntryForm> createState() => _ProgressEntryFormState();
}

class _ProgressEntryFormState extends State<_ProgressEntryForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _weightController;
  late final TextEditingController _bodyFatController;
  late final TextEditingController _chestController;
  late final TextEditingController _waistController;
  late final TextEditingController _hipController;
  late final TextEditingController _armController;
  late final TextEditingController _notesController;
  late final TextEditingController _exerciseNameController;
  late final TextEditingController _exerciseWeightController;
  late final TextEditingController _exerciseRepsController;
  late DateTime _selectedDateTime;

  String? _feedbackMessage;
  Color _feedbackColor = Colors.orange;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
    _bodyFatController = TextEditingController();
    _chestController = TextEditingController();
    _waistController = TextEditingController();
    _hipController = TextEditingController();
    _armController = TextEditingController();
    _notesController = TextEditingController();
    _exerciseNameController = TextEditingController();
    _exerciseWeightController = TextEditingController();
    _exerciseRepsController = TextEditingController();
    _selectedDateTime = widget.initialRecord?.recordedAt ?? DateTime.now();
    _populateFromInitialRecord();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _bodyFatController.dispose();
    _chestController.dispose();
    _waistController.dispose();
    _hipController.dispose();
    _armController.dispose();
    _notesController.dispose();
    _exerciseNameController.dispose();
    _exerciseWeightController.dispose();
    _exerciseRepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ClientProgressViewModel>();
    final isBusy = viewModel.isBusy;
    final entryType = widget.entryType;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entryType == _ProgressEntryType.measurements
                ? 'Registrar mediciones'
                : 'Registrar ejercicio',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (_feedbackMessage != null) ...[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _feedbackColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _feedbackMessage!,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: _feedbackColor),
              ),
            ),
          ],
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Fecha del registro'),
              subtitle: Text(_formatSelectedDateTime(context)),
              trailing: const Icon(Icons.edit_calendar_outlined),
              onTap: isBusy ? null : () => _pickDateTime(context),
            ),
          ),
          const SizedBox(height: 16),
          if (entryType == _ProgressEntryType.measurements)
            _MeasurementsFormFields(
              weightController: _weightController,
              bodyFatController: _bodyFatController,
              chestController: _chestController,
              waistController: _waistController,
              hipController: _hipController,
              armController: _armController,
            )
          else
            _ExerciseFormFields(
              exerciseNameController: _exerciseNameController,
              exerciseWeightController: _exerciseWeightController,
              exerciseRepsController: _exerciseRepsController,
            ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Notas',
              hintText: 'Observaciones adicionales',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isBusy ? null : widget.onCancel,
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: isBusy
                      ? null
                      : () => _handleSubmit(entryType, viewModel),
                  child: isBusy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Guardar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit(
    _ProgressEntryType entryType,
    ClientProgressViewModel viewModel,
  ) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (entryType == _ProgressEntryType.measurements) {
      final hasMeasurements = [
        _weightController,
        _bodyFatController,
        _chestController,
        _waistController,
        _hipController,
        _armController,
      ].any((controller) => controller.text.trim().isNotEmpty);

      if (!hasMeasurements && _notesController.text.trim().isEmpty) {
        _setFeedback(
          'Ingresa al menos una medicion o una nota',
          color: Colors.orange,
        );
        return;
      }
    }

    double? parseDouble(String text) =>
        text.trim().isEmpty ? null : double.tryParse(text);
    int? parseInt(String text) =>
        text.trim().isEmpty ? null : int.tryParse(text);

    final existing = widget.initialRecord;
    final isMeasurement = entryType == _ProgressEntryType.measurements;

    final weightKg = isMeasurement
        ? parseDouble(_weightController.text)
        : existing?.weightKg;
    final bodyFat = isMeasurement
        ? parseDouble(_bodyFatController.text)
        : existing?.bodyFatPercentage;
    final chest = isMeasurement
        ? parseDouble(_chestController.text)
        : existing?.chestCm;
    final waist = isMeasurement
        ? parseDouble(_waistController.text)
        : existing?.waistCm;
    final hip = isMeasurement
        ? parseDouble(_hipController.text)
        : existing?.hipCm;
    final arm = isMeasurement
        ? parseDouble(_armController.text)
        : existing?.armCm;

    final exerciseName = isMeasurement
        ? existing?.exerciseName
        : (_exerciseNameController.text.trim().isEmpty
              ? null
              : _exerciseNameController.text.trim());
    final exerciseWeight = isMeasurement
        ? existing?.exerciseWeight
        : parseDouble(_exerciseWeightController.text);
    final exerciseReps = isMeasurement
        ? existing?.exerciseReps
        : parseInt(_exerciseRepsController.text);

    final record = ProgressRecord(
      id: existing?.id,
      clientId: viewModel.clientId,
      recordedAt: _selectedDateTime,
      weightKg: weightKg,
      bodyFatPercentage: bodyFat,
      chestCm: chest,
      waistCm: waist,
      hipCm: hip,
      armCm: arm,
      thighCm: existing?.thighCm,
      exerciseName: exerciseName,
      exerciseWeight: exerciseWeight,
      exerciseReps: exerciseReps,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: existing?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await viewModel.addRecord(record);
    if (!mounted) return;

    if (success) {
      widget.onSuccess();
      return;
    }

    _setFeedback(
      viewModel.lastError ??
          'No se pudo guardar el progreso. Intenta de nuevo.',
      color: Colors.red,
    );
  }

  void _setFeedback(String message, {required Color color}) {
    setState(() {
      _feedbackMessage = message;
      _feedbackColor = color;
    });
  }

  void _populateFromInitialRecord() {
    final record = widget.initialRecord;
    if (record == null) return;

    String formatDouble(double? value) {
      if (value == null) return '';
      final hasDecimals = value % 1 != 0;
      return hasDecimals ? value.toStringAsFixed(1) : value.toStringAsFixed(0);
    }

    if (widget.entryType == _ProgressEntryType.measurements) {
      _weightController.text = formatDouble(record.weightKg);
      _bodyFatController.text = formatDouble(record.bodyFatPercentage);
      _chestController.text = formatDouble(record.chestCm);
      _waistController.text = formatDouble(record.waistCm);
      _hipController.text = formatDouble(record.hipCm);
      _armController.text = formatDouble(record.armCm);
    } else {
      _exerciseNameController.text = record.exerciseName ?? '';
      _exerciseWeightController.text = formatDouble(record.exerciseWeight);
      _exerciseRepsController.text = record.exerciseReps != null
          ? record.exerciseReps.toString()
          : '';
    }

    _notesController.text = record.notes ?? '';
    _selectedDateTime = record.recordedAt;
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final initial = _selectedDateTime;
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 20);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: now,
    );
    if (!context.mounted) return;
    if (pickedDate == null) return;

    final initialTime = TimeOfDay.fromDateTime(initial);
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (!context.mounted) return;
    if (pickedTime == null) return;

    final selected = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() => _selectedDateTime = selected);
  }

  String _formatSelectedDateTime(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final use24h = MediaQuery.maybeOf(context)?.alwaysUse24HourFormat ?? false;
    final dateText = localizations.formatMediumDate(_selectedDateTime);
    final timeText = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(_selectedDateTime),
      alwaysUse24HourFormat: use24h,
    );
    return '$dateText • $timeText';
  }
}

bool _isMeasurementRecord(ProgressRecord record) {
  return record.weightKg != null ||
      record.bodyFatPercentage != null ||
      record.chestCm != null ||
      record.waistCm != null ||
      record.hipCm != null ||
      record.armCm != null ||
      record.thighCm != null;
}

bool _isExerciseRecord(ProgressRecord record) {
  return (record.exerciseName ?? '').trim().isNotEmpty ||
      record.exerciseWeight != null ||
      record.exerciseReps != null;
}

String _buildMeasurementDescription(ProgressRecord record) {
  final pieces = <String>[];
  if (record.weightKg != null) {
    final weight = record.weightKg!;
    final formatted = weight % 1 == 0
        ? weight.toStringAsFixed(0)
        : weight.toStringAsFixed(1);
    pieces.add('Peso: $formatted kg');
  }
  if (record.bodyFatPercentage != null) {
    final fat = record.bodyFatPercentage!;
    final formatted = fat % 1 == 0
        ? fat.toStringAsFixed(0)
        : fat.toStringAsFixed(1);
    pieces.add('Grasa: $formatted %');
  }
  if (record.chestCm != null) {
    final chest = record.chestCm!;
    final formatted = chest % 1 == 0
        ? chest.toStringAsFixed(0)
        : chest.toStringAsFixed(1);
    pieces.add('Pecho: $formatted cm');
  }
  if (record.waistCm != null) {
    final waist = record.waistCm!;
    final formatted = waist % 1 == 0
        ? waist.toStringAsFixed(0)
        : waist.toStringAsFixed(1);
    pieces.add('Cintura: $formatted cm');
  }
  if (record.hipCm != null) {
    final hip = record.hipCm!;
    final formatted = hip % 1 == 0
        ? hip.toStringAsFixed(0)
        : hip.toStringAsFixed(1);
    pieces.add('Cadera: $formatted cm');
  }
  if (record.armCm != null) {
    final arm = record.armCm!;
    final formatted = arm % 1 == 0
        ? arm.toStringAsFixed(0)
        : arm.toStringAsFixed(1);
    pieces.add('Brazo: $formatted cm');
  }
  if ((record.notes ?? '').isNotEmpty) {
    pieces.add(record.notes!);
  }
  return pieces.isEmpty ? 'Sin detalles registrados' : pieces.join(' - ');
}

String _buildExerciseDescription(ProgressRecord record) {
  final weightValue = record.exerciseWeight;
  final weightText = weightValue == null
      ? '--'
      : (weightValue % 1 == 0
            ? weightValue.toStringAsFixed(0)
            : weightValue.toStringAsFixed(1));
  final repsText = record.exerciseReps?.toString() ?? '--';
  final pieces = <String>['Peso: $weightText kg', 'Repeticiones: $repsText'];
  if ((record.notes ?? '').isNotEmpty) {
    pieces.add(record.notes!);
  }
  return pieces.join(' - ');
}

String _formatRelativeDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);
  if (difference.inDays >= 7) {
    return '${date.day}/${date.month}/${date.year}';
  }
  if (difference.inDays >= 1) {
    return 'Hace ${difference.inDays} dias';
  }
  if (difference.inHours >= 1) {
    return 'Hace ${difference.inHours} horas';
  }
  if (difference.inMinutes >= 1) {
    return 'Hace ${difference.inMinutes} minutos';
  }
  return 'Hace unos instantes';
}

String _formatRecordTimestamp(BuildContext context, DateTime dateTime) {
  final localizations = MaterialLocalizations.of(context);
  final use24h = MediaQuery.maybeOf(context)?.alwaysUse24HourFormat ?? false;
  final dateText = localizations.formatMediumDate(dateTime);
  final timeText = localizations.formatTimeOfDay(
    TimeOfDay.fromDateTime(dateTime),
    alwaysUse24HourFormat: use24h,
  );
  final relative = _formatRelativeDate(dateTime);
  return '$dateText • $timeText ($relative)';
}

class _ProgressLogTile extends StatelessWidget {
  const _ProgressLogTile({
    required this.title,
    required this.description,
    required this.date,
    this.onEdit,
    this.onDelete,
  });

  final String title;
  final String description;
  final String date;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final hasActions = onEdit != null || onDelete != null;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(description),
              const SizedBox(height: 4),
              Text(
                date,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        trailing: hasActions
            ? PopupMenuButton<_ProgressLogAction>(
                onSelected: (action) {
                  switch (action) {
                    case _ProgressLogAction.edit:
                      onEdit?.call();
                      break;
                    case _ProgressLogAction.delete:
                      onDelete?.call();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if (onEdit != null)
                    const PopupMenuItem<_ProgressLogAction>(
                      value: _ProgressLogAction.edit,
                      child: Text('Editar'),
                    ),
                  if (onDelete != null)
                    const PopupMenuItem<_ProgressLogAction>(
                      value: _ProgressLogAction.delete,
                      child: Text('Eliminar'),
                    ),
                ],
              )
            : const Icon(Icons.chevron_right),
        onTap: onEdit,
      ),
    );
  }
}

enum _ProgressLogAction { edit, delete }

class _MeasurementsFormFields extends StatelessWidget {
  const _MeasurementsFormFields({
    required this.weightController,
    required this.bodyFatController,
    required this.chestController,
    required this.waistController,
    required this.hipController,
    required this.armController,
  });

  final TextEditingController weightController;
  final TextEditingController bodyFatController;
  final TextEditingController chestController;
  final TextEditingController waistController;
  final TextEditingController hipController;
  final TextEditingController armController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Peso (kg)',
            prefixIcon: Icon(Icons.scale_outlined),
          ),
          validator: _optionalNumberValidator,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: bodyFatController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Grasa corporal (%)',
            prefixIcon: Icon(Icons.percent_outlined),
          ),
          validator: _optionalNumberValidator,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: chestController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Pecho (cm)',
            prefixIcon: Icon(Icons.straighten),
          ),
          validator: _optionalNumberValidator,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: waistController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Cintura (cm)',
            prefixIcon: Icon(Icons.straighten),
          ),
          validator: _optionalNumberValidator,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: hipController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Cadera (cm)',
            prefixIcon: Icon(Icons.straighten),
          ),
          validator: _optionalNumberValidator,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: armController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Brazo (cm)',
            prefixIcon: Icon(Icons.straighten),
          ),
          validator: _optionalNumberValidator,
        ),
      ],
    );
  }

  String? _optionalNumberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return double.tryParse(value) == null ? 'Ingresa un numero valido' : null;
  }
}

class _ExerciseFormFields extends StatelessWidget {
  const _ExerciseFormFields({
    required this.exerciseNameController,
    required this.exerciseWeightController,
    required this.exerciseRepsController,
  });

  final TextEditingController exerciseNameController;
  final TextEditingController exerciseWeightController;
  final TextEditingController exerciseRepsController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: exerciseNameController,
          decoration: const InputDecoration(
            labelText: 'Ejercicio',
            prefixIcon: Icon(Icons.fitness_center_outlined),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Ingresa el nombre del ejercicio';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: exerciseWeightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Peso (kg)',
            prefixIcon: Icon(Icons.scale_outlined),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Ingresa el peso utilizado';
            }
            return double.tryParse(value) == null
                ? 'Ingresa un numero valido'
                : null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: exerciseRepsController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Repeticiones',
            prefixIcon: Icon(Icons.numbers_outlined),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Ingresa las repeticiones';
            }
            return int.tryParse(value) == null
                ? 'Ingresa un numero valido'
                : null;
          },
        ),
      ],
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage({required this.role});

  final AuthRole role;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actions = _HomeCopy.profileActions(role);

    return ListView(
      key: ValueKey('profile-'),
      padding: const EdgeInsets.all(24),
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.person,
            size: 48,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _HomeCopy.roleDisplay(role),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        for (final action in actions)
          _ProfileTile(
            title: action.title,
            subtitle: action.subtitle,
            icon: action.icon,
          ),
      ],
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Colors.black87),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        color: color,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 28, color: Colors.grey.shade900),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueGrey.shade600),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}

class _ProfileAction {
  const _ProfileAction({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}

class _ScheduleItem extends StatelessWidget {
  const _ScheduleItem({
    required this.title,
    required this.subtitle,
    required this.badgeText,
  });

  final String title;
  final String subtitle;
  final String badgeText;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(subtitle),
            const SizedBox(height: 12),
            Chip(
              label: Text(badgeText),
              avatar: const Icon(Icons.info_outline, size: 18),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}

class _CoachStatCard extends StatelessWidget {
  const _CoachStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Icon(icon, color: Colors.blueGrey.shade600),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(label, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}

class _CoachClientCard extends StatelessWidget {
  const _CoachClientCard({
    required this.name,
    required this.progress,
    required this.status,
  });

  final String name;
  final String progress;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blueGrey.shade100,
                  child: Text(name.substring(0, 1)),
                ),
                const SizedBox(width: 12),
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(progress),
            const SizedBox(height: 8),
            Text(
              status,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClientScheduleCard extends StatelessWidget {
  const _ClientScheduleCard({
    required this.title,
    required this.datetime,
    required this.trainer,
  });

  final String title;
  final String datetime;
  final String trainer;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey.shade100,
          child: const Icon(Icons.access_time, color: Colors.black87),
        ),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(datetime),
            const SizedBox(height: 4),
            Text(trainer),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
