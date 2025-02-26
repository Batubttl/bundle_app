import 'package:bundle_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/close_icon_widget.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_form.dart';
import '../../../services/auth_services.dart';
import 'signup_view_model.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpViewModel(AuthService()),
      child: Consumer<SignUpViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          backgroundColor: AppColors.lightBackground,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CloseWidget(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            AppStrings.titleText,
                            style: TextStyle(
                              color: AppColors.lightText,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 40),
                          _buildSignUpForm(context, viewModel),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm(BuildContext context, SignUpViewModel viewModel) {
    return Form(
      key: viewModel.formKey,
      child: Column(
        children: [
          CustomTextFormField(
            controller: viewModel.nameController,
            hintText: AppStrings.nameHint,
            validator: viewModel.validateName,
          ),
          CustomTextFormField(
            controller: viewModel.surnameController,
            hintText: AppStrings.surnameHint,
            validator: viewModel.validateSurname,
          ),
          CustomTextFormField(
            controller: viewModel.emailController,
            hintText: AppStrings.emailHint,
            validator: viewModel.validateEmail,
          ),
          CustomTextFormField(
            controller: viewModel.passwordController,
            hintText: AppStrings.passwordHint,
            isPassword: true,
            validator: viewModel.validatePassword,
          ),
          if (viewModel.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                viewModel.errorMessage!,
                style: TextStyle(color: AppColors.primaryRed),
              ),
            ),
          const SizedBox(height: 24),
          CustomButton(
            text: AppStrings.signUpButtonText,
            onPressed: viewModel.isLoading
                ? null
                : () => viewModel.handleSignUp(context),
            backgroundColor: AppColors.primaryRed,
            hasMargin: false,
          ),
        ],
      ),
    );
  }
}
