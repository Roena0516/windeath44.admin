import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/header.dart';
import '../../../providers/user_provider.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(userListProvider.notifier).fetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    final userListState = ref.watch(userListProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Row(
        children: [
          const Sidebar(activeItem: 'users'),
          Expanded(
            child: Column(
              children: [
                const Header(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Text(
                          'SYSTEM ADMINISTRATION',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                            color: colorScheme.primary.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'User ',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w300,
                                letterSpacing: -1,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              'Management',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                letterSpacing: -1,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Loading/Error/Content
                        if (userListState.isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(48.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (userListState.error != null)
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  userListState.error!,
                                  style: TextStyle(color: colorScheme.error),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    ref.read(userListProvider.notifier).fetchUsers();
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        else if (userListState.userList != null)
                          Column(
                            children: [
                              // Stats
                              Row(
                                children: [
                                  Expanded(
                                    child: _StatCard(
                                      label: 'TOTAL USERS',
                                      value: userListState.userList!.totalUserCount.toString(),
                                      colorScheme: colorScheme,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _StatCard(
                                      label: 'CURRENT PAGE',
                                      value: '${userListState.currentPage + 1} / ${userListState.userList!.totalPages}',
                                      colorScheme: colorScheme,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _StatCard(
                                      label: 'SHOWING',
                                      value: userListState.userList!.content.length.toString(),
                                      colorScheme: colorScheme,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // User table
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: colorScheme.onSurface.withOpacity(0.1),
                                  ),
                                ),
                                child: DataTable(
                                  columns: const [
                                    DataColumn(label: Text('USER')),
                                    DataColumn(label: Text('EMAIL')),
                                    DataColumn(label: Text('ROLE')),
                                    DataColumn(label: Text('TOKENS')),
                                  ],
                                  rows: userListState.userList!.content.map((user) {
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 16,
                                                backgroundImage: NetworkImage(user.profile),
                                              ),
                                              const SizedBox(width: 12),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    user.name,
                                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                                  ),
                                                  Text(
                                                    user.userId,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: colorScheme.onSurface.withOpacity(0.5),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        DataCell(Text(user.email)),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: _getRoleColor(user.role).withOpacity(0.1),
                                              border: Border.all(
                                                color: _getRoleColor(user.role).withOpacity(0.2),
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              user.role,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1,
                                                color: _getRoleColor(user.role),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(Text(user.remainToken.toString())),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),

                              // Pagination
                              if (userListState.userList!.totalPages > 1)
                                Padding(
                                  padding: const EdgeInsets.only(top: 24),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: userListState.currentPage > 0
                                            ? () => ref.read(userListProvider.notifier).setPage(userListState.currentPage - 1)
                                            : null,
                                        icon: const Icon(Icons.chevron_left),
                                      ),
                                      const SizedBox(width: 16),
                                      Text('Page ${userListState.currentPage + 1} of ${userListState.userList!.totalPages}'),
                                      const SizedBox(width: 16),
                                      IconButton(
                                        onPressed: userListState.currentPage < userListState.userList!.totalPages - 1
                                            ? () => ref.read(userListProvider.notifier).setPage(userListState.currentPage + 1)
                                            : null,
                                        icon: const Icon(Icons.chevron_right),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
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

  Color _getRoleColor(String role) {
    switch (role) {
      case 'ADMIN':
        return Colors.purple;
      case 'CHIEF':
        return Colors.blue;
      case 'USER':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colorScheme;

  const _StatCard({
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w300,
              letterSpacing: -1,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
