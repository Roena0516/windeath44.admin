import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/header.dart';
import '../../../providers/user_provider.dart';
import '../../../core/utils/responsive.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  final _searchController = TextEditingController();
  String? _selectedRoleFilter;
  String _selectedSort = 'createdAt,desc';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(userListProvider.notifier).fetchUsers());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    ref.read(userListProvider.notifier).fetchUsers(
          keyword: _searchController.text.isEmpty ? null : _searchController.text,
          roleFilter: _selectedRoleFilter,
          sortBy: _selectedSort,
          page: 0,
        );
  }

  @override
  Widget build(BuildContext context) {
    final userListState = ref.watch(userListProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      drawer: isMobile ? const Drawer(child: Sidebar(activeItem: 'users')) : null,
      body: Row(
        children: [
          if (!isMobile) const Sidebar(activeItem: 'users'),
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
                        // Header
                        isMobile
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colorScheme.primary,
                                          boxShadow: [
                                            BoxShadow(
                                              color: colorScheme.primary.withOpacity(0.8),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'SYSTEM ADMINISTRATION',
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'User Management',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -1,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () => context.go('/users/create'),
                                      icon: const Icon(Icons.add, size: 16),
                                      label: const Text(
                                        'CREATE ADMIN',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colorScheme.onSurface,
                                        foregroundColor: colorScheme.surface,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: colorScheme.primary,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: colorScheme.primary.withOpacity(0.8),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'SYSTEM ADMINISTRATION',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 3,
                                              color: colorScheme.primary,
                                            ),
                                          ),
                                        ],
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
                                    ],
                                  ),
                                  // Create Admin Button
                                  ElevatedButton.icon(
                                    onPressed: () => context.go('/users/create'),
                                    icon: const Icon(Icons.add, size: 12),
                                    label: const Text(
                                      'CREATE ADMIN',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colorScheme.onSurface,
                                      foregroundColor: colorScheme.surface,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(height: 24),

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
                              // Stats Overview
                              isMobile
                                  ? Column(
                                      children: [
                                        _StatCard(
                                          label: 'TOTAL USERS',
                                          value: userListState.userList!.totalUserCount.toString(),
                                          colorScheme: colorScheme,
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _StatCard(
                                                label: 'ACTIVE PAGE',
                                                value: '${userListState.currentPage + 1}',
                                                helper: '/ ${userListState.userList!.totalPages}',
                                                colorScheme: colorScheme,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: _StatCard(
                                                label: 'VISIBLE ROWS',
                                                value: userListState.userList!.content.length.toString(),
                                                colorScheme: colorScheme,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Expanded(
                                          child: _StatCard(
                                            label: 'TOTAL USERS',
                                            value: userListState.userList!.totalUserCount.toString(),
                                            colorScheme: colorScheme,
                                          ),
                                        ),
                                        const SizedBox(width: 24),
                                        Expanded(
                                          child: _StatCard(
                                            label: 'ACTIVE PAGE',
                                            value: '${userListState.currentPage + 1}',
                                            helper: '/ ${userListState.userList!.totalPages}',
                                            colorScheme: colorScheme,
                                          ),
                                        ),
                                        const SizedBox(width: 24),
                                        Expanded(
                                          child: _StatCard(
                                            label: 'VISIBLE ROWS',
                                            value: userListState.userList!.content.length.toString(),
                                            colorScheme: colorScheme,
                                          ),
                                        ),
                                      ],
                                    ),
                              const SizedBox(height: 24),

                              // Filters & Table Container
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: colorScheme.onSurface.withOpacity(0.1),
                                  ),
                                  color: colorScheme.surface.withOpacity(0.2),
                                ),
                                child: Column(
                                  children: [
                                    // Filters Toolbar
                                    Container(
                                      padding: EdgeInsets.all(isMobile ? 16 : 24),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: colorScheme.onSurface.withOpacity(0.1),
                                          ),
                                        ),
                                        color: colorScheme.onSurface.withOpacity(0.02),
                                      ),
                                      child: isMobile
                                          ? Column(
                                              children: [
                                                // Search field (Mobile)
                                                TextField(
                                              controller: _searchController,
                                              decoration: InputDecoration(
                                                hintText: 'SEARCH USERS...',
                                                hintStyle: TextStyle(
                                                  fontSize: 12,
                                                  letterSpacing: 1.5,
                                                  color: colorScheme.onSurface.withOpacity(0.2),
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.search,
                                                  size: 16,
                                                  color: colorScheme.onSurface.withOpacity(0.3),
                                                ),
                                                filled: true,
                                                fillColor: colorScheme.onSurface.withOpacity(0.05),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: BorderSide(
                                                    color: colorScheme.onSurface.withOpacity(0.1),
                                                  ),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: BorderSide(
                                                    color: colorScheme.onSurface.withOpacity(0.1),
                                                  ),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: BorderSide(
                                                    color: colorScheme.primary.withOpacity(0.5),
                                                  ),
                                                ),
                                                contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 10,
                                                ),
                                              ),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                letterSpacing: 1.5,
                                              ),
                                                  onSubmitted: (_) => _applyFilters(),
                                                ),
                                                const SizedBox(height: 12),

                                                // Role and Sort filters (Mobile)
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: DropdownButtonFormField<String>(
                                              value: _selectedRoleFilter,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: colorScheme.onSurface.withOpacity(0.05),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: BorderSide(
                                                    color: colorScheme.onSurface.withOpacity(0.1),
                                                  ),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: BorderSide(
                                                    color: colorScheme.onSurface.withOpacity(0.1),
                                                  ),
                                                ),
                                                contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 10,
                                                ),
                                              ),
                                              hint: Text(
                                                'ALL ROLES',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  letterSpacing: 1.5,
                                                  color: colorScheme.onSurface.withOpacity(0.6),
                                                ),
                                              ),
                                              items: ['ADMIN', 'CHIEF', 'USER', 'TESTER', 'ANONYMOUS']
                                                  .map((role) => DropdownMenuItem(
                                                        value: role,
                                                        child: Text(
                                                          role,
                                                          style: const TextStyle(
                                                            fontSize: 12,
                                                            letterSpacing: 1.5,
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _selectedRoleFilter = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: DropdownButtonFormField<String>(
                                              value: _selectedSort,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: colorScheme.onSurface.withOpacity(0.05),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: BorderSide(
                                                    color: colorScheme.onSurface.withOpacity(0.1),
                                                  ),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: BorderSide(
                                                    color: colorScheme.onSurface.withOpacity(0.1),
                                                  ),
                                                ),
                                                contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 10,
                                                ),
                                              ),
                                              items: const [
                                                DropdownMenuItem(
                                                  value: 'createdAt,desc',
                                                  child: Text(
                                                    'NEWEST FIRST',
                                                    style: TextStyle(fontSize: 12, letterSpacing: 1.5),
                                                  ),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'createdAt,asc',
                                                  child: Text(
                                                    'OLDEST FIRST',
                                                    style: TextStyle(fontSize: 12, letterSpacing: 1.5),
                                                  ),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'name,asc',
                                                  child: Text(
                                                    'NAME A-Z',
                                                    style: TextStyle(fontSize: 12, letterSpacing: 1.5),
                                                  ),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'name,desc',
                                                  child: Text(
                                                    'NAME Z-A',
                                                    style: TextStyle(fontSize: 12, letterSpacing: 1.5),
                                                  ),
                                                ),
                                              ],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _selectedSort = value!;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),

                                                // Apply filters button (Mobile)
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    onPressed: _applyFilters,
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: colorScheme.primary,
                                                      foregroundColor: Colors.white,
                                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      'APPLY FILTERS',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                        letterSpacing: 2,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                // Search field (Desktop)
                                                Expanded(
                                                  flex: 2,
                                                  child: TextField(
                                                    controller: _searchController,
                                                    decoration: InputDecoration(
                                                      hintText: 'SEARCH USERS...',
                                                      hintStyle: TextStyle(
                                                        fontSize: 12,
                                                        letterSpacing: 1.5,
                                                        color: colorScheme.onSurface.withOpacity(0.2),
                                                      ),
                                                      prefixIcon: Icon(
                                                        Icons.search,
                                                        size: 16,
                                                        color: colorScheme.onSurface.withOpacity(0.3),
                                                      ),
                                                      filled: true,
                                                      fillColor: colorScheme.onSurface.withOpacity(0.05),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide(
                                                          color: colorScheme.onSurface.withOpacity(0.1),
                                                        ),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide(
                                                          color: colorScheme.onSurface.withOpacity(0.1),
                                                        ),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide(
                                                          color: colorScheme.primary.withOpacity(0.5),
                                                        ),
                                                      ),
                                                      contentPadding: const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 10,
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      letterSpacing: 1.5,
                                                    ),
                                                    onSubmitted: (_) => _applyFilters(),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),

                                                // Role filter (Desktop)
                                                Expanded(
                                                  child: DropdownButtonFormField<String>(
                                                    value: _selectedRoleFilter,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: colorScheme.onSurface.withOpacity(0.05),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide(
                                                          color: colorScheme.onSurface.withOpacity(0.1),
                                                        ),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide(
                                                          color: colorScheme.onSurface.withOpacity(0.1),
                                                        ),
                                                      ),
                                                      contentPadding: const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 10,
                                                      ),
                                                    ),
                                                    hint: Text(
                                                      'ALL ROLES',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        letterSpacing: 1.5,
                                                        color: colorScheme.onSurface.withOpacity(0.6),
                                                      ),
                                                    ),
                                                    items: ['ADMIN', 'CHIEF', 'USER', 'TESTER', 'ANONYMOUS']
                                                        .map((role) => DropdownMenuItem(
                                                              value: role,
                                                              child: Text(
                                                                role,
                                                                style: const TextStyle(
                                                                  fontSize: 12,
                                                                  letterSpacing: 1.5,
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _selectedRoleFilter = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 16),

                                                // Sort dropdown (Desktop)
                                                Expanded(
                                                  child: DropdownButtonFormField<String>(
                                                    value: _selectedSort,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: colorScheme.onSurface.withOpacity(0.05),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide(
                                                          color: colorScheme.onSurface.withOpacity(0.1),
                                                        ),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                        borderSide: BorderSide(
                                                          color: colorScheme.onSurface.withOpacity(0.1),
                                                        ),
                                                      ),
                                                      contentPadding: const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 10,
                                                      ),
                                                    ),
                                                    items: const [
                                                      DropdownMenuItem(
                                                        value: 'createdAt,desc',
                                                        child: Text(
                                                          'NEWEST FIRST',
                                                          style: TextStyle(fontSize: 12, letterSpacing: 1.5),
                                                        ),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: 'createdAt,asc',
                                                        child: Text(
                                                          'OLDEST FIRST',
                                                          style: TextStyle(fontSize: 12, letterSpacing: 1.5),
                                                        ),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: 'name,asc',
                                                        child: Text(
                                                          'NAME A-Z',
                                                          style: TextStyle(fontSize: 12, letterSpacing: 1.5),
                                                        ),
                                                      ),
                                                      DropdownMenuItem(
                                                        value: 'name,desc',
                                                        child: Text(
                                                          'NAME Z-A',
                                                          style: TextStyle(fontSize: 12, letterSpacing: 1.5),
                                                        ),
                                                      ),
                                                    ],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _selectedSort = value!;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 16),

                                                // Apply filters button (Desktop)
                                                ElevatedButton(
                                                  onPressed: _applyFilters,
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: colorScheme.primary,
                                                    foregroundColor: Colors.white,
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 10,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'APPLY FILTERS',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      letterSpacing: 2,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),

                                    // User table or cards
                                    isMobile
                                        ? _buildUserCards(userListState, colorScheme)
                                        : _buildUserTable(userListState, colorScheme),

                                    // Pagination
                                    if (userListState.userList!.totalPages > 1)
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: colorScheme.onSurface.withOpacity(0.1),
                                            ),
                                          ),
                                          color: colorScheme.onSurface.withOpacity(0.02),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: userListState.currentPage > 0
                                                  ? () => ref.read(userListProvider.notifier).setPage(
                                                        userListState.currentPage - 1,
                                                      )
                                                  : null,
                                              child: Text(
                                                'PREVIOUS',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 2,
                                                  color: userListState.currentPage > 0
                                                      ? colorScheme.onSurface.withOpacity(0.6)
                                                      : colorScheme.onSurface.withOpacity(0.3),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: List.generate(
                                                userListState.userList!.totalPages > 5
                                                    ? 5
                                                    : userListState.userList!.totalPages,
                                                (index) {
                                                  final pageNum = (userListState.currentPage ~/ 5) * 5 + index;
                                                  if (pageNum >= userListState.userList!.totalPages) {
                                                    return const SizedBox.shrink();
                                                  }
                                                  final isActive = pageNum == userListState.currentPage;
                                                  return Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                                    child: InkWell(
                                                      onTap: () => ref
                                                          .read(userListProvider.notifier)
                                                          .setPage(pageNum),
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: Container(
                                                        width: 32,
                                                        height: 32,
                                                        decoration: BoxDecoration(
                                                          color: isActive
                                                              ? colorScheme.primary
                                                              : Colors.transparent,
                                                          borderRadius: BorderRadius.circular(8),
                                                          boxShadow: isActive
                                                              ? [
                                                                  BoxShadow(
                                                                    color: colorScheme.primary
                                                                        .withOpacity(0.4),
                                                                    blurRadius: 10,
                                                                  ),
                                                                ]
                                                              : null,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            '${pageNum + 1}',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color: isActive
                                                                  ? Colors.white
                                                                  : colorScheme.onSurface.withOpacity(0.4),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: userListState.currentPage <
                                                      userListState.userList!.totalPages - 1
                                                  ? () => ref.read(userListProvider.notifier).setPage(
                                                        userListState.currentPage + 1,
                                                      )
                                                  : null,
                                              child: Text(
                                                'NEXT',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 2,
                                                  color: userListState.currentPage <
                                                          userListState.userList!.totalPages - 1
                                                      ? colorScheme.onSurface.withOpacity(0.6)
                                                      : colorScheme.onSurface.withOpacity(0.3),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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

  Widget _buildUserCards(UserListState userListState, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: userListState.userList!.content.map((user) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.onSurface.withOpacity(0.1),
              ),
              color: colorScheme.surface,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Identity
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getRoleColor(user.role).withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          user.profile,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: colorScheme.onSurface.withOpacity(0.1),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: _getRoleColor(user.role).withOpacity(0.1),
                              child: Center(
                                child: Text(
                                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: _getRoleColor(user.role),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
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
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getRoleColor(user.role).withOpacity(0.1),
                        border: Border.all(
                          color: _getRoleColor(user.role).withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        user.role,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getRoleColor(user.role),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: colorScheme.onSurface.withOpacity(0.1)),
                const SizedBox(height: 12),

                // Email
                Row(
                  children: [
                    Icon(Icons.email_outlined, size: 16, color: colorScheme.onSurface.withOpacity(0.4)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Tokens and Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.token_outlined, size: 16, color: colorScheme.onSurface.withOpacity(0.4)),
                        const SizedBox(width: 8),
                        Text(
                          '${user.remainToken} TKN',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      DateTime.parse(user.createdAt).toString().split(' ')[0],
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Delete button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete User'),
                          content: Text('Are you sure you want to delete ${user.userId}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('CANCEL'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              child: const Text('DELETE'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && mounted) {
                        await ref.read(userListProvider.notifier).deleteUser(user.userId);
                      }
                    },
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: const Text('DELETE USER'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red.withOpacity(0.3)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUserTable(UserListState userListState, ColorScheme colorScheme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowHeight: 56,
        dataRowMinHeight: 72,
        dataRowMaxHeight: 72,
        columnSpacing: 48,
        headingRowColor: WidgetStateProperty.all(
          colorScheme.onSurface.withOpacity(0.02),
        ),
        columns: [
          DataColumn(
            label: Text(
              'USER IDENTITY',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'CONTACT',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'ROLE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'TOKENS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'JOINED',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'ACTIONS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ),
        ],
        rows: userListState.userList!.content.map((user) {
          return DataRow(
            cells: [
              // User Identity
              DataCell(
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getRoleColor(user.role).withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          user.profile,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: colorScheme.onSurface.withOpacity(0.1),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: _getRoleColor(user.role).withOpacity(0.1),
                              child: Center(
                                child: Text(
                                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _getRoleColor(user.role),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.userId,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                            color: colorScheme.onSurface.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    // Status indicator
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: user.role == 'ADMIN'
                            ? Colors.purple.withOpacity(0.8)
                            : Colors.green.withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: user.role == 'ADMIN'
                                ? Colors.purple.withOpacity(0.5)
                                : Colors.green.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Contact (Email)
              DataCell(
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),

              // Role
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getRoleColor(user.role).withOpacity(0.1),
                    border: Border.all(
                      color: _getRoleColor(user.role).withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      if (user.role == 'ADMIN' || user.role == 'CHIEF')
                        BoxShadow(
                          color: _getRoleColor(user.role).withOpacity(0.2),
                          blurRadius: 10,
                        ),
                    ],
                  ),
                  child: Text(
                    user.role,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: _getRoleColor(user.role),
                    ),
                  ),
                ),
              ),

              // Tokens
              DataCell(
                Row(
                  children: [
                    Text(
                      user.remainToken.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'monospace',
                        color: colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'TKN',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1,
                        color: colorScheme.onSurface.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),

              // Joined
              DataCell(
                Text(
                  DateTime.parse(user.createdAt).toString().split(' ')[0],
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    color: colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              ),

              // Actions
              DataCell(
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 16,
                    color: colorScheme.onSurface.withOpacity(0.2),
                  ),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete User'),
                        content: Text('Are you sure you want to delete ${user.userId}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('CANCEL'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('DELETE'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true && mounted) {
                      await ref.read(userListProvider.notifier).deleteUser(user.userId);
                    }
                  },
                  tooltip: 'Delete User',
                ),
              ),
            ],
          );
        }).toList(),
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
  final String? helper;
  final ColorScheme colorScheme;

  const _StatCard({
    required this.label,
    required this.value,
    this.helper,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -1,
                  color: colorScheme.onSurface,
                ),
              ),
              if (helper != null) ...[
                const SizedBox(width: 8),
                Text(
                  helper!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: colorScheme.onSurface.withOpacity(0.3),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
