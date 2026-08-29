import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/prism_button.dart';
import '../../widgets/common/prism_input.dart';

/// Auth — Screen 4: Admin Login.
/// Minimal. Serious. Internal only. No back arrow, no subtext about
/// credentials being provided.
class AdminLoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const AdminLoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            widget.onLoginSuccess();
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final errorMessage = state is AuthFailure ? state.message : null;

          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Breadcrumb: "PRISM TEAM" JetBrains Mono 10px Dim.
                      Text(
                        'PRISM TEAM',
                        style: AppTextStyles.dataLabel,
                      ),
                      const SizedBox(height: 20),

                      // Heading: "Internal access" Space Grotesk 700.
                      Text('Internal access', style: AppTextStyles.pageTitle.copyWith(fontSize: 28)),
                      const SizedBox(height: 40),

                      PrismInput(
                        label: 'EMAIL',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => context.read<AuthBloc>().add(AdminEmailChanged(value)),
                      ),
                      const SizedBox(height: 24),

                      PrismInput(
                        label: 'PASSWORD',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        errorText: errorMessage,
                        onChanged: (value) => context.read<AuthBloc>().add(AdminPasswordChanged(value)),
                        trailing: IconButton(
                          splashRadius: 18,
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            size: 18,
                            color: AppColors.textDim,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      const SizedBox(height: 36),

                      PrismButton(
                        label: 'Log In',
                        isLoading: isLoading,
                        onPressed: () => context.read<AuthBloc>().add(const AdminLoginSubmitted()),
                      ),

                      const SizedBox(height: 32),

                      // Small text bottom: "All sessions are logged."
                      // JetBrains Mono 10px Dim.
                      Center(
                        child: Text('All sessions are logged.', style: AppTextStyles.dataLabel),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
