import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/header.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/auth_provider.dart';

class CreateAdminPage extends ConsumerStatefulWidget {
  const CreateAdminPage({super.key});

  @override
  ConsumerState<CreateAdminPage> createState() => _CreateAdminPageState();
}

class _CreateAdminPageState extends ConsumerState<CreateAdminPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _userIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _verificationCodeController = TextEditingController();

  int _currentStep = 0;
  bool _emailVerified = false;
  bool _codeSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _userIdController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  Future<void> _sendVerificationCode() async {
    final success = await ref.read(authProvider.notifier).sendEmailVerification(_emailController.text);
    if (success) {
      setState(() {
        _codeSent = true;
      });
    }
  }

  Future<void> _verifyCode() async {
    final success = await ref.read(authProvider.notifier).validateEmailCode(
          _emailController.text,
          _verificationCodeController.text,
        );
    if (success) {
      setState(() {
        _emailVerified = true;
        _currentStep = 1;
      });
    }
  }

  Future<void> _createAdmin() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref.read(createAdminProvider.notifier).createAdmin(
            userId: _userIdController.text,
            email: _emailController.text,
            name: _nameController.text,
            password: _passwordController.text,
          );

      if (success && mounted) {
        context.go('/users');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final createAdminState = ref.watch(createAdminProvider);

    return Scaffold(
      body: Row(
        children: [
          const Sidebar(activeItem: 'create-admin'),
          Expanded(
            child: Column(
              children: [
                const Header(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Text(
                                'Create ',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: -1,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                'Admin',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: -1,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 48),

                              // Step indicator
                              Row(
                                children: [
                                  _StepIndicator(
                                    number: 1,
                                    label: 'VERIFICATION',
                                    isActive: _currentStep == 0,
                                    isCompleted: _emailVerified,
                                    colorScheme: colorScheme,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: colorScheme.onSurface.withOpacity(0.1),
                                    ),
                                  ),
                                  _StepIndicator(
                                    number: 2,
                                    label: 'DETAILS',
                                    isActive: _currentStep == 1,
                                    isCompleted: false,
                                    colorScheme: colorScheme,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 48),

                              // Forms
                              if (_currentStep == 0) ...[
                                TextFormField(
                                  controller: _emailController,
                                  enabled: !_codeSent,
                                  decoration: InputDecoration(
                                    labelText: 'Email Address',
                                    suffixIcon: !_codeSent
                                        ? TextButton(
                                            onPressed: _sendVerificationCode,
                                            child: const Text('SEND CODE'),
                                          )
                                        : const Icon(Icons.check, color: Colors.green),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter email';
                                    }
                                    return null;
                                  },
                                ),
                                if (_codeSent) ...[
                                  const SizedBox(height: 24),
                                  TextFormField(
                                    controller: _verificationCodeController,
                                    decoration: InputDecoration(
                                      labelText: 'Verification Code',
                                      suffixIcon: TextButton(
                                        onPressed: _verifyCode,
                                        child: const Text('VERIFY'),
                                      ),
                                    ),
                                  ),
                                ],
                              ] else ...[
                                TextFormField(
                                  controller: _userIdController,
                                  decoration: const InputDecoration(labelText: 'User ID'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter user ID';
                                    }
                                    if (value.length < 6 || value.length > 16) {
                                      return 'User ID must be 6-16 characters';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(labelText: 'Full Name'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(labelText: 'Password'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter password';
                                    }
                                    if (value.length < 8 || value.length > 20) {
                                      return 'Password must be 8-20 characters';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                                  validator: (value) {
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 48),
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: createAdminState.isLoading ? null : _createAdmin,
                                    child: createAdminState.isLoading
                                        ? const CircularProgressIndicator()
                                        : const Text('CREATE ADMIN ACCOUNT'),
                                  ),
                                ),
                              ],

                              if (createAdminState.error != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    createAdminState.error!,
                                    style: TextStyle(color: colorScheme.error),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
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

class _StepIndicator extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;
  final bool isCompleted;
  final ColorScheme colorScheme;

  const _StepIndicator({
    required this.number,
    required this.label,
    required this.isActive,
    required this.isCompleted,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive || isCompleted ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.2),
              width: 2,
            ),
            color: isCompleted ? colorScheme.primary : colorScheme.surface,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isActive || isCompleted ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
