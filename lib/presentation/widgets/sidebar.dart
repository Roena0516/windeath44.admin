import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/api_constants.dart';

class NavItem {
  final String id;
  final String label;
  final IconData icon;
  final String? route;
  final String? externalUrl;

  NavItem({
    required this.id,
    required this.label,
    required this.icon,
    this.route,
    this.externalUrl,
  });
}

class Sidebar extends StatefulWidget {
  final String? activeItem;

  const Sidebar({super.key, this.activeItem});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool isCollapsed = false;

  final List<NavItem> navItems = [
    NavItem(
      id: 'dashboard',
      label: 'Dashboard',
      icon: Icons.home_outlined,
      route: '/',
    ),
    NavItem(
      id: 'users',
      label: 'Users',
      icon: Icons.people_outline,
      route: '/users',
    ),
    NavItem(
      id: 'create-admin',
      label: 'Create Admin',
      icon: Icons.person_add_outlined,
      route: '/users/create',
    ),
    NavItem(
      id: 'grafana',
      label: 'Grafana',
      icon: Icons.bar_chart_outlined,
      externalUrl: ApiConstants.grafanaUrl,
    ),
    NavItem(
      id: 'argo-cd',
      label: 'Argo CD',
      icon: Icons.build_outlined,
      externalUrl: ApiConstants.argoCdUrl,
    ),
    NavItem(
      id: 'kiali',
      label: 'Kiali',
      icon: Icons.hub_outlined,
      externalUrl: ApiConstants.kialiUrl,
    ),
    NavItem(
      id: 'prometheus',
      label: 'Prometheus',
      icon: Icons.monitor_heart_outlined,
      externalUrl: ApiConstants.prometheusUrl,
    ),
    NavItem(
      id: 'kafka-ui',
      label: 'Kafka UI',
      icon: Icons.storage_outlined,
      externalUrl: ApiConstants.kafkaUiUrl,
    ),
  ];

  void _handleItemClick(NavItem item, BuildContext context) async {
    if (item.route != null) {
      context.go(item.route!);
    } else if (item.externalUrl != null) {
      final uri = Uri.parse(item.externalUrl!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeId = widget.activeItem ?? 'dashboard';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      width: isCollapsed ? 80 : 320,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(0.4),
          border: Border(
            right: BorderSide(
              color: colorScheme.onSurface.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isCollapsed)
                    Text(
                      'MENU',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.5,
                        color: colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isCollapsed = !isCollapsed;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimatedRotation(
                        turns: isCollapsed ? 0.5 : 0,
                        duration: const Duration(milliseconds: 500),
                        child: Icon(
                          Icons.chevron_left,
                          size: 16,
                          color: colorScheme.onSurface.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Navigation items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: navItems.map((item) {
                  final isActive = activeId == item.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () => _handleItemClick(item, context),
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(
                          horizontal: isCollapsed ? 16 : 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? colorScheme.onSurface.withOpacity(0.08)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              size: 20,
                              color: isActive
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurface.withOpacity(0.4),
                            ),
                            if (!isCollapsed) ...[
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isActive ? FontWeight.w500 : FontWeight.w300,
                                    letterSpacing: 0.5,
                                    color: isActive
                                        ? colorScheme.onSurface
                                        : colorScheme.onSurface.withOpacity(0.4),
                                  ),
                                ),
                              ),
                            ],
                            if (isActive && !isCollapsed)
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.onSurface,
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.onSurface.withOpacity(0.5),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Status panel
            if (!isCollapsed)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.onSurface.withOpacity(0.1),
                    ),
                    color: colorScheme.onSurface.withOpacity(0.02),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'STATUS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: colorScheme.onSurface.withOpacity(0.3),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.4),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'LIVE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.5,
                                  color: Colors.green.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.onSurface.withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'System operational.\nNo active incidents.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          fontWeight: FontWeight.w300,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
