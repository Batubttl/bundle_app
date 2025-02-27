import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:bundle_app/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../views/auth/forget_password_view_model.dart';

class ForgotPasswordFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final ForgotPasswordViewModel viewModel;
  final Function(String) onSubmit;

  const ForgotPasswordFormWidget({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.viewModel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            decoration: InputDecoration(
              hintText: AppStrings.emailHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.secondary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.secondary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            validator: viewModel.validateEmail,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: viewModel.isLoading
                ? AppStrings.loadingText
                : AppStrings.resetPassword,
            onPressed: viewModel.isLoading
                ? null
                : () async {
                    if (formKey.currentState!.validate()) {
                      onSubmit(emailController.text.trim());
                    }
                  },
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
