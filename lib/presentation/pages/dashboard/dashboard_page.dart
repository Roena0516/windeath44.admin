import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/header.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/responsive.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      drawer: isMobile ? const Drawer(child: Sidebar(activeItem: 'dashboard')) : null,
      body: Row(
        children: [
          if (!isMobile) const Sidebar(activeItem: 'dashboard'),
          Expanded(
            child: Column(
              children: [
                const Header(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: Responsive.getResponsivePadding(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Editorial Header
                        Container(
                          padding: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: colorScheme.onSurface.withOpacity(0.1),
                              ),
                            ),
                          ),
                          child: isMobile
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'SERVER ADMINISTRATION',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                        color: colorScheme.onSurface.withOpacity(0.4),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Windeath44 ',
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w300,
                                            letterSpacing: -1,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                        Text(
                                          'Overview',
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w300,
                                            fontStyle: FontStyle.italic,
                                            letterSpacing: -1,
                                            color: colorScheme.onSurface.withOpacity(0.3),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateTime.now().toString().split(' ')[0].toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 2,
                                            color: colorScheme.onSurface.withOpacity(0.3),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'SYSTEM OPERATIONAL',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: colorScheme.onSurface.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'SERVER ADMINISTRATION',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2,
                                            color: colorScheme.onSurface.withOpacity(0.4),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Text(
                                              'Windeath44 ',
                                              style: TextStyle(
                                                fontSize: 48,
                                                fontWeight: FontWeight.w300,
                                                letterSpacing: -1,
                                                color: colorScheme.onSurface,
                                              ),
                                            ),
                                            Text(
                                              'Overview',
                                              style: TextStyle(
                                                fontSize: 48,
                                                fontWeight: FontWeight.w300,
                                                fontStyle: FontStyle.italic,
                                                letterSpacing: -1,
                                                color: colorScheme.onSurface.withOpacity(0.3),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          DateTime.now().toString().split(' ')[0].toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 2,
                                            color: colorScheme.onSurface.withOpacity(0.3),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'SYSTEM OPERATIONAL',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: colorScheme.onSurface.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                        const SizedBox(height: 48),

                        // Quick Actions Grid
                        Text(
                          'QUICK ACTIONS',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 24),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: isMobile ? 1 : 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: isMobile ? 2.5 : 3,
                          children: [
                            _QuickActionCard(
                              title: 'Manage Users',
                              description: 'View user accounts, roles, and activity status',
                              onTap: () => context.go('/users'),
                              colorScheme: colorScheme,
                            ),
                            _QuickActionCard(
                              title: 'Create Admin Account',
                              description: 'Set up new administrator accounts with verification',
                              onTap: () => context.go('/users/create'),
                              colorScheme: colorScheme,
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),

                        // Observability Section
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.onSurface.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'INFRASTRUCTURE',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 2,
                                      color: colorScheme.onSurface.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: isMobile ? 2 : (Responsive.isTablet(context) ? 3 : 5),
                                crossAxisSpacing: 1,
                                mainAxisSpacing: 1,
                                childAspectRatio: 1,
                                children: [
                                  _ObservabilityTile(
                                    title: 'Grafana',
                                    description: 'Dashboards & unified metrics',
                                    url: ApiConstants.grafanaUrl,
                                    colorScheme: colorScheme,
                                  ),
                                  _ObservabilityTile(
                                    title: 'Argo CD',
                                    description: 'Deployment pipelines & sync status',
                                    url: ApiConstants.argoCdUrl,
                                    colorScheme: colorScheme,
                                  ),
                                  _ObservabilityTile(
                                    title: 'Kiali',
                                    description: 'Service mesh topology',
                                    url: ApiConstants.kialiUrl,
                                    colorScheme: colorScheme,
                                  ),
                                  _ObservabilityTile(
                                    title: 'Prometheus',
                                    description: 'Raw metrics explorer',
                                    url: ApiConstants.prometheusUrl,
                                    colorScheme: colorScheme,
                                  ),
                                  _ObservabilityTile(
                                    title: 'Kafka UI',
                                    description: 'Event-stream inspection',
                                    url: ApiConstants.kafkaUiUrl,
                                    colorScheme: colorScheme,
                                  ),
                                ],
                              ),
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
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _QuickActionCard({
    required this.title,
    required this.description,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.onSurface.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ObservabilityTile extends StatelessWidget {
  final String title;
  final String description;
  final String url;
  final ColorScheme colorScheme;

  const _ObservabilityTile({
    required this.title,
    required this.description,
    required this.url,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border.all(
            color: colorScheme.onSurface.withOpacity(0.1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
                Icon(
                  Icons.open_in_new,
                  size: 12,
                  color: colorScheme.onSurface.withOpacity(0.1),
                ),
              ],
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 10,
                color: colorScheme.onSurface.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
