/// Change Password Page
/// Page for changing user password
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../core/constants/string_constants.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/extensions.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_text_field.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: CustomAppBar(title: StringConstants.changePasswordTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                label: StringConstants.currentPassword,
                controller: _currentPasswordController,
                obscureText: true,
                validator: (value) => Validators.validateRequired(
                  value,
                  StringConstants.currentPassword,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: StringConstants.newPassword,
                controller: _newPasswordController,
                obscureText: true,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: StringConstants.confirmNewPassword,
                controller: _confirmPasswordController,
                obscureText: true,
                validator: (value) => Validators.validateConfirmPassword(
                  _newPasswordController.text,
                  value ?? '',
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: StringConstants.save,
                isLoading: authState.isLoading,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await ref
                          .read(authProvider.notifier)
                          .changePassword(
                            _currentPasswordController.text,
                            _newPasswordController.text,
                          );
                      if (mounted) {
                        context.showSuccessSnackBar(
                          StringConstants.passwordChangedSuccess,
                        );
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (mounted) {
                        context.showErrorSnackBar(e.toString());
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
