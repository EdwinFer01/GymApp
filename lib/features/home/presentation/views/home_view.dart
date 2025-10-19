import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/domain/entities/auth_user.dart';
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
    final tabs = _HomeTabsBuilder.forRole(viewModel.user.role);

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
  static List<_HomeTabConfig> forRole(AuthRole role) {
    switch (role) {
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
            page: const _ClientProgressPage(),
          ),
          _HomeTabConfig(
            destination: const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            page: const _ClientHomePage(),
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
  const _ClientHomePage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                Text(
                  'Plan premium - Vence el 12/12/2025',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.payments_outlined),
                  label: const Text('Pagar siguiente mes'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Tus proximas clases',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
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
    );
  }
}

class _ClientProgressPage extends StatelessWidget {
  const _ClientProgressPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      key: const ValueKey('client-progress'),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progreso corporal',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: const [
                    _ProgressMetric(
                      label: 'Peso',
                      value: '72 kg',
                      delta: '-2.1 kg',
                    ),
                    _ProgressMetric(
                      label: 'Grasa corporal',
                      value: '18%',
                      delta: '-1.5%',
                    ),
                    _ProgressMetric(
                      label: 'Masa muscular',
                      value: '41%',
                      delta: '+1.2%',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Ultimos registros',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const _ProgressLogTile(
          title: 'Pecho + hombro',
          description: 'Press banca 3x12 - 50kg - Nueva marca personal',
          date: 'Hace 2 dias',
        ),
        const _ProgressLogTile(
          title: 'Pierna + core',
          description: 'Sentadilla 4x10 - 80kg - Mejor tecnica',
          date: 'Hace 4 dias',
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
      key: ValueKey('profile-${role.name}'),
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

class _ProgressMetric extends StatelessWidget {
  const _ProgressMetric({
    required this.label,
    required this.value,
    required this.delta,
  });

  final String label;
  final String value;
  final String delta;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          Text(
            delta,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.green.shade700),
          ),
        ],
      ),
    );
  }
}

class _ProgressLogTile extends StatelessWidget {
  const _ProgressLogTile({
    required this.title,
    required this.description,
    required this.date,
  });

  final String title;
  final String description;
  final String date;

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
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
